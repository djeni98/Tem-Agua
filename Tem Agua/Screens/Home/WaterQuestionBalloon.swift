//
//  WaterQuestionBalloon.swift
//  Tem Agua
//
//  Created by Djenifer Renata Pereira on 06/10/21.
//

import UIKit
import SnapKit

class WaterQuestionBalloon: LeftBalloonView {
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.text = "Tem Água?"
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .largeTitle).rounded().bold()

        return label
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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
