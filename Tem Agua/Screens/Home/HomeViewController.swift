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
    private lazy var repository: RepositoryService = .init()

    private var objectId: Int?

    private lazy var waterBalloon: WaterQuestionBalloon = {
        let balloon = WaterQuestionBalloon()
        balloon.action = waterBalloonRequest
        return balloon
    }()

    private var xPoint: Double?
    private var yPoint: Double?

    private lazy var headerView: UIView = {
        let view = UIView()

        view.addSubview(waterBalloon)
        waterBalloon.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
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

        navigationItem.title = "Início"
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

    private func isSameLocation(_ point: (x: Double, y: Double)) -> Bool {
        if let xPoint = xPoint, let yPoint = yPoint,
           xPoint == point.x, yPoint == point.y {
            return true
        }
        return false
    }

    private func didTimeout() -> Bool {
        guard let lastSearch = persistence.getLastSearchDate() else { return true }
        let timeoutTime: TimeInterval = 60 * 60
        return Date() > (lastSearch + timeoutTime)
    }

    private var isLoading = false
    private func waterBalloonRequest() {
        startRequests(withTimeout: false)
    }

    private func startRequests(withTimeout: Bool = true) {
        if isLoading { return }
        isLoading = true

        if let location = persistence.getLocationPoint() {
            let point = location.toTuple()

            if isSameLocation(point) && withTimeout && !didTimeout() {
                isLoading = false
                return
            }

            xPoint = point.x
            yPoint = point.y

            requestLocationInfo()
            persistence.saveLastSearchDate(Date())
        } else {
            // TODO: let user inform location here
            rightBalloonsContainer.arrangedSubviews.forEach { view in
                rightBalloonsContainer.removeArrangedSubview(view)
                view.removeFromSuperview()
            }

            let balloon = SimpleRightBalloon()
            var text = "A localização não foi informada."

            text += "\n\n" + "Para obter uma resposta, use a geolocalização ou informe as coordenadas manualmente nas configurações."


            balloon.text = text
            rightBalloonsContainer.addArrangedSubview(balloon)
            isLoading = false
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
                    self.isLoading = false
                }

                return
            }

            self.objectId = id
            Task {
                await self.requestCurrentWaterRotation()
            }
        }

    }

    @objc private func requestCurrentWaterRotation() async {
        guard let objectId = objectId else { return }

        do {
            let waterRotation = try await repository.getCurrentWaterRotation(objectId: objectId)
            self.configureAnswerBalloon(with: waterRotation == nil ? "Sim!" : "Não!")

            if let currentRotation = waterRotation {
                self.configureCurrentRotation(with: currentRotation)
            } else {
                await self.requestWaterRotationWithin24Hours()
            }
        } catch {
            DispatchQueue.main.async {
                let balloon = SimpleRightBalloon()
                balloon.text = "Tente novamente mais tarde."
                self.rightBalloonsContainer.addArrangedSubview(balloon)
                self.isLoading = false
            }
        }
    }

    private func configureAnswerBalloon(with text: String) {
        DispatchQueue.main.async {
            let answerBalloon = AnswerBalloon()
            answerBalloon.setAnswer(text)
            self.rightBalloonsContainer.addArrangedSubview(answerBalloon)
        }
    }

    private func configureCurrentRotation(with rotation: WaterRotation) {
        DispatchQueue.main.async {
            let viewModel = WaterRotationViewModel(model: rotation)
            let waterBalloon = WaterRotationBalloon()
            waterBalloon.configure(
                isNextRotation: false,
                rotationInfoText: viewModel.getInfoTextAboutCurrentRotation(),
                observationText: rotation.observacao
            )
            self.rightBalloonsContainer.addArrangedSubview(waterBalloon)
            self.isLoading = false
        }
    }

    @objc private func requestWaterRotationWithin24Hours() async {
        guard let objectId = objectId else { return }

        do {
            let waterRotation = try await repository.getNewWaterRotationWithin24Hours(objectId: objectId)

            if let rotation = waterRotation {
                self.configure24HoursRotation(with: rotation)
            } else {
                self.configureNoWaterRotation()
            }
        } catch {
            DispatchQueue.main.async {
                self.showErrorAlert()
                self.isLoading = false
            }
        }
    }

    private func configure24HoursRotation(with rotation: WaterRotation) {
        let viewModel = WaterRotationViewModel(model: rotation)
        DispatchQueue.main.async {
            let waterBalloon = WaterRotationBalloon()
            waterBalloon.configure(
                isNextRotation: false,
                rotationInfoText: viewModel.getInfoTextAbout24HoursRotation(),
                observationText: rotation.observacao
            )
            self.rightBalloonsContainer.addArrangedSubview(waterBalloon)
            self.isLoading = false
        }
    }

    private func configureNoWaterRotation() {
        DispatchQueue.main.async {
            let waterBalloon = WaterRotationBalloon()
            waterBalloon.configure(
                isNextRotation: false,
                rotationInfoText: "Sem rodízio nas próximas 24 horas.",
                observationText: nil
            )
            self.rightBalloonsContainer.addArrangedSubview(waterBalloon)
            self.isLoading = false
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
