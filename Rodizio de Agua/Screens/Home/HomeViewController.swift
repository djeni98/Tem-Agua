//
//  HomeViewController.swift
//  Rodizio de Agua
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
            print("Location not informed")
        }
    }

    @objc private func requestLocationInfo() {
        guard let x = xPoint, let y = yPoint else { return }

        rightBalloonsContainer.arrangedSubviews.forEach { view in
            rightBalloonsContainer.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        let api = APIService()
        api.getLocationRelatedInfo(x: x, y: y) { id, polygonCoordinates in
            print("Retrieved Id: \(id)")
            self.objectId = id
            self.requestCurrentWaterRotation()
        }

    }

    @objc private func requestCurrentWaterRotation() {
        guard let objectId = objectId else { return }

        let api = APIService()
        api.getCurrentWaterRotation(objectId: objectId) { relatedRecords in
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
        api.getNewWaterRotationWithin24Hours(objectId: objectId) { relatedRecords in
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
