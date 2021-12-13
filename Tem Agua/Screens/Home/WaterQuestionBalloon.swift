//
//  WaterQuestionBalloon.swift
//  Tem Agua
//
//  Created by Djenifer Renata Pereira on 06/10/21.
//

import UIKit
import SnapKit

class WaterQuestionBalloon: LeftBalloonView {

    var action: (() -> Void)?

    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.text = "Tem Água?"
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .largeTitle).rounded().bold()
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0

        return label
    }()

    private lazy var whiteOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.leftBalloonCornerRadius()
        view.alpha = 0

        return view
    }()

    private lazy var gradientBackground: GradientBackgroundView = {
        let gradient = GradientBackgroundView.getBlueLinearGradient()
        gradient.leftBalloonCornerRadius()

        gradient.addSubview(questionLabel)

        let vertical = LayoutMetrics.labelVerticalInset
        let horizontal = LayoutMetrics.labelHorizontalInset
        let inset = UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
        questionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(inset)
        }

        return gradient
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        self.backgroundColor = .clear
        
        self.addSubview(gradientBackground)
        gradientBackground.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        self.snp.makeConstraints { make in
            make.bottom.equalTo(gradientBackground)
        }

        self.addSubview(whiteOverlay)
        whiteOverlay.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        singleTap.numberOfTouchesRequired = 1
        singleTap.numberOfTapsRequired = 1

        self.addGestureRecognizer(singleTap)
        self.isUserInteractionEnabled = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func tapAction() {
        guard let action = action else {
            print("\(#file): Action not defined")
            return
        }

        UIView.animate(withDuration: 0.5) {
            self.whiteOverlay.alpha = 0.2
            self.whiteOverlay.alpha = 0
        }

        action()
    }

    private struct LayoutMetrics {
        static let labelVerticalInset: CGFloat = 16
        static let labelHorizontalInset: CGFloat = 32
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct WaterQuestionBalloon_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }

    struct ContentView: UIViewRepresentable {

        func makeUIView(context: Context) -> UIView {
            return WaterQuestionBalloon()
        }

        func updateUIView(_ uiView: UIView, context: Context) {}
    }
}
#endif
