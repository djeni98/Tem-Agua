//
//  HomeViewController.swift
//  Tem Agua
//
//  Created by Djenifer Renata Pereira on 07/10/21.
//

import UIKit
import SnapKit

class HomeViewController: ScrollableViewController {
    private lazy var persistence: PersistenceService = .init()

    private var objectId: Int?

    private lazy var waterBalloon: WaterQuestionBalloon = .init()

    private var xPoint: Double?
    private var yPoint: Double?

    private lazy var headerView: UIView = {
        let view = UIView()

        view.addSubview(waterBalloon)
        waterBalloon.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        return view
    }()

    private lazy var rightBalloonsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .trailing

        return stackView
    }()

    override func loadView() {
        super.loadView()

        view.backgroundColor = .appBackground
        setupContent()
    }

    private func setupContent() {
        contentStackView.alignment = .fill
        contentStackView.spacing = 16

        contentStackView.addArrangedSubview(headerView)
        contentStackView.addArrangedSubview(rightBalloonsContainer)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startRequests()
    }

    private func startRequests() {
        if let location = persistence.getLocationPoint() {
            let point = location.toTuple()

            if let xPoint = xPoint, let yPoint = yPoint,
                xPoint == point.x, yPoint == point.y {
                // Same location
                return
            }

            xPoint = point.x
            yPoint = point.y

            requestLocationInfo()
        } else {
            // TODO: let user inform location here
            let balloon = SimpleRightBalloon()
            var text = "A localização não foi informada."

            text += "\n\n" + "Para obter uma resposta, use a geolocalização ou informe as coordenadas manualmente nas configurações."


            balloon.text = text
            rightBalloonsContainer.addArrangedSubview(balloon)
        }
    }

    private func showErrorAlert(title: String = "Um erro ocorreu", message: String? = "Tente novamente mais tarde.") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }

    @objc private func requestLocationInfo() {
        guard let x = xPoint, let y = yPoint else { return }

        rightBalloonsContainer.arrangedSubviews.forEach { view in
            rightBalloonsContainer.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        let api = APIService()
        api.getLocationRelatedInfo(x: x, y: y) { id, polygonCoordinates, error in
            if let error = error {
                DispatchQueue.main.async {
                    switch error {
                    case .dataExtractionFailure(_):
                        self.showErrorAlert(title: "Localização informada sem resultados.", message: nil)
                    default:
                        self.showErrorAlert()
                    }

                    let balloon = SimpleRightBalloon()
                    balloon.text = "Verifique se a localização informada está na região metropolitana de Curitiba."
                    self.rightBalloonsContainer.addArrangedSubview(balloon)
                }

                return
            }

            self.objectId = id
            self.requestCurrentWaterRotation()
        }

    }

    @objc private func requestCurrentWaterRotation() {
        guard let objectId = objectId else { return }

        let api = APIService()
        api.getCurrentWaterRotation(objectId: objectId) { relatedRecords, error in
            if let _ = error {
                DispatchQueue.main.async {
                    let balloon = SimpleRightBalloon()
                    balloon.text = "Tente novamente mais tarde."
                    self.rightBalloonsContainer.addArrangedSubview(balloon)
                }

                return
            }

            guard let relatedRecords = relatedRecords else { return }

            print("RelatedRecords.count:", relatedRecords.count)
            print(relatedRecords)

            DispatchQueue.main.async {
                let answerBalloon = AnswerBalloon()
                answerBalloon.setAnswer(relatedRecords.isEmpty ? "Sim!" : "Não!")
                self.rightBalloonsContainer.addArrangedSubview(answerBalloon)
            }

            if relatedRecords.isEmpty {
                self.requestWaterRotationWithin24Hours()
            } else {
                guard let currentRotation = WaterRotation.from(relatedRecords.first!) else {
                    print("\(#line): Could not transform dictionary to WaterRotation model")
                    return
                }

                let viewModel = WaterRotationViewModel(model: currentRotation)
                DispatchQueue.main.async {
                    let waterBalloon = WaterRotationBalloon()
                    waterBalloon.configure(
                        isNextRotation: false,
                        rotationInfoText: viewModel.getInfoTextAboutCurrentRotation(),
                        observationText: currentRotation.observacao
                    )
                    self.rightBalloonsContainer.addArrangedSubview(waterBalloon)
                }
            }
        }
    }

    @objc private func requestWaterRotationWithin24Hours() {
        guard let objectId = objectId else { return }

        let api = APIService()
        api.getNewWaterRotationWithin24Hours(objectId: objectId) { relatedRecords, error in
            if let _ = error {
                DispatchQueue.main.async {
                    self.showErrorAlert()
                }

                return
            }

            guard let relatedRecords = relatedRecords else { return }

            print("24 Hours count:", relatedRecords.count)
            print(relatedRecords)

            if relatedRecords.isEmpty {
                DispatchQueue.main.async {
                    let waterBalloon = WaterRotationBalloon()
                    waterBalloon.configure(
                        isNextRotation: false,
                        rotationInfoText: "Sem rodízio nas próximas 24 horas.",
                        observationText: nil
                    )
                    self.rightBalloonsContainer.addArrangedSubview(waterBalloon)
                }
            } else {
                guard let rotation = WaterRotation.from(relatedRecords.first!) else {
                    print("\(#line): Could not transform dictionary to WaterRotation model")
                    return
                }

                let viewModel = WaterRotationViewModel(model: rotation)
                DispatchQueue.main.async {
                    let waterBalloon = WaterRotationBalloon()
                    waterBalloon.configure(
                        isNextRotation: false,
                        rotationInfoText: viewModel.getInfoTextAbout24HoursRotation(),
                        observationText: rotation.observacao
                    )
                    self.rightBalloonsContainer.addArrangedSubview(waterBalloon)
                }
            }
        }
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }

    struct ContentView: UIViewControllerRepresentable {

        func makeUIViewController(context: Context) -> UIViewController {
            return HomeViewController()
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    }
}
#endif
