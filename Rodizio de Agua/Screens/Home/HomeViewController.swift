//
//  HomeViewController.swift
//  Rodizio de Agua
//
//  Created by Djenifer Renata Pereira on 07/10/21.
//

import UIKit
import SnapKit

class HomeViewController: ScrollableViewController {
    private var politecnicoId = 117
    private var jockeyPlazaId = 135

    private var objectId: Int?

    private lazy var waterBalloon: WaterQuestionBalloon = .init()

    private var xPoint: Double?
    private var yPoint: Double?

    private lazy var buttonsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillProportionally
        
        for location in Location.allCases {
            let uiAction = UIAction() { _ in
                let point = location.getPoint()
                self.xPoint = point.x
                self.yPoint = point.y

                self.requestLocationInfo()
            }

            let button = UIButton(primaryAction: uiAction)
            button.setTitle(location.rawValue, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = 10
            button.snp.makeConstraints { make in
                make.height.equalTo(60)
            }

            stackView.addArrangedSubview(button)
        }

        return stackView
    }()

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

    override func setupContentStackViewConstraints() {
        let vertical = LayoutMetrics.contentStackViewVerticalOffset
        let horizontal = LayoutMetrics.contentStackViewHorizontalOffset
        
        let inset = UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
        contentStackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView).inset(inset)
            make.width.equalTo(scrollView).offset(-horizontal*2)
        }
    }

    private func setupContent() {
        contentStackView.alignment = .fill
        contentStackView.spacing = 16

        contentStackView.addArrangedSubview(buttonsContainer)
        contentStackView.addArrangedSubview(headerView)
        contentStackView.addArrangedSubview(rightBalloonsContainer)
    }

    private func setupRightBalloons() {
        let answerBalloon = AnswerBalloon()
        rightBalloonsContainer.addArrangedSubview(answerBalloon)

        let rotationBalloon = WaterRotationBalloon()
        // rotationBalloon.configure(isNextRotation: true, rotationInfoText: "Teste")
        rightBalloonsContainer.addArrangedSubview(rotationBalloon)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    private enum Location: String, CaseIterable {
        case politecnico, jockeyPlaza, estacao

        func getPoint() -> (x: Double, y: Double) {
            switch self {
            case .politecnico:
                return (x: -49.231733212404365, y: -25.450797458953218)
            case .jockeyPlaza:
                return (x: -49.21442003679073, y: -25.42961165831857)
            case .estacao:
                return (x: -49.266369974740044, y: -25.437978201876945)
            }
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
        if objectId == nil { objectId = jockeyPlazaId }
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

    private struct LayoutMetrics {
        static let contentStackViewVerticalOffset: CGFloat = 16
        static let contentStackViewHorizontalOffset: CGFloat = 32
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
