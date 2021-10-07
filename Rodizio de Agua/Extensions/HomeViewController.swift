//
//  HomeViewController.swift
//  Rodizio de Agua
//
//  Created by Djenifer Renata Pereira on 07/10/21.
//

import UIKit
import SnapKit

class HomeViewController: ScrollableViewController {
    private lazy var waterBalloon: WaterQuestionBalloon = .init()

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

        contentStackView.addArrangedSubview(headerView)
        contentStackView.addArrangedSubview(rightBalloonsContainer)

        setupRightBalloons()
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
