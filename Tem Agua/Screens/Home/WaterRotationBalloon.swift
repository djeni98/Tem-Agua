//
//  WaterRotationBalloon.swift
//  Tem Agua
//
//  Created by Djenifer Renata Pereira on 07/10/21.
//

import UIKit
import SnapKit

class WaterRotationBalloon: RightBalloonView {
    private lazy var nextRotationLabel: UILabel = {
        let label = UILabel()
        label.text = "E o próximo rodízio?"
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.numberOfLines = 0

        return label
    }()

    private lazy var rotationInfoLabel: UILabel = {
        let label = UILabel()
        label.text = Array(1...50).reduce("", { $0 + "\($1)" })
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.numberOfLines = 0

        return label
    }()

    private lazy var observationLabel: UILabel = {
        let label = UILabel()
        label.text = Array(1...10).reduce("", { $0 + "\($1)" })
        label.font = .preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.numberOfLines = 0

        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = Array(1...10).reduce("", { $0 + "\($1)" })
        label.font = .preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.numberOfLines = 0

        return label
    }()

    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12

        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.rightBalloonCornerRadius()
        setup()
    }

    private func setup() {
        self.addSubview(containerStackView)

        let verticalOffset = LayoutMetrics.stackViewVerticalOffset
        let horizontalOffset = LayoutMetrics.stackViewHorizontalOffset
        containerStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(verticalOffset)
            make.leading.equalToSuperview().offset(horizontalOffset)
            make.trailing.equalToSuperview().offset(-horizontalOffset)
        }

        self.snp.makeConstraints { make in
            make.bottom.equalTo(containerStackView).offset(verticalOffset)
        }

        containerStackView.addArrangedSubview(nextRotationLabel)
        containerStackView.addArrangedSubview(rotationInfoLabel)
        containerStackView.addArrangedSubview(observationLabel)
    }

    func configure(isNextRotation: Bool, rotationInfoText: String, observationText: String? = nil) {
        containerStackView.arrangedSubviews.forEach { view in
            containerStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        if isNextRotation {
            containerStackView.addArrangedSubview(nextRotationLabel)
        }

        rotationInfoLabel.text = rotationInfoText
        containerStackView.addArrangedSubview(rotationInfoLabel)

        if let observation = observationText, !observation.isEmpty {
            observationLabel.text = observation
            containerStackView.addArrangedSubview(observationLabel)
        }

        dateLabel.text = "Pesquisa feita em \(Date().toPortugueseText())"
        containerStackView.addArrangedSubview(dateLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private struct LayoutMetrics {
        static let stackViewVerticalOffset: CGFloat = 8
        static let stackViewHorizontalOffset: CGFloat = 12
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct WaterRotationBalloon_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }

    struct ContentView: UIViewRepresentable {

        func makeUIView(context: Context) -> UIView {
            return WaterRotationBalloon()
        }

        func updateUIView(_ uiView: UIView, context: Context) {}
    }
}
#endif
