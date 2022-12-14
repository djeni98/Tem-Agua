//
//  GeolocationCardView.swift
//  Tem Agua
//
//  Created by Djenifer Renata Pereira on 10/10/21.
//

import UIKit
import SnapKit

class GeolocationCardView: CardView {
    var selected = true {
        didSet {
            toggle.isOn = selected
            layer.shadowOpacity = selected ? BalloonsLayoutMetrics.shadowOpacity : 0
        }
    }

    override var isAccessibilityElement: Bool {
        get { return true }
        set {}
    }

    override var accessibilityLabel: String? {
        get { return titleLabel.accessibilityLabel }
        set {}
    }

    override var accessibilityValue: String? {
        get { return toggle.isOn ? "Ativado" : "Desativado" }
        set {}
    }

    override var accessibilityHint: String? {
        get { return "Toque duas vezes para alternar a configuração" }
        set {}
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Usar geolocalização"
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0

        return label
    }()

    var toggleAction: ((Bool) -> Void)?

    private lazy var toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = selected
        toggle.addTarget(self, action: #selector(toggleSwitch), for: .valueChanged)
        toggle.setContentCompressionResistancePriority(.required, for: .horizontal)
        toggle.setContentCompressionResistancePriority(.required, for: .vertical)

        toggle.setContentHuggingPriority(.required, for: .horizontal)
        toggle.setContentHuggingPriority(.required, for: .vertical)

        return toggle
    }()

    private lazy var container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = LayoutMetrics.stackViewSpacing

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(toggle)
        stackView.alignment = .center

        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        self.addSubview(container)
        let offset = LayoutMetrics.stackViewOffset
        container.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(offset)
            make.leading.equalToSuperview().offset(offset)
            make.trailing.equalToSuperview().offset(-offset)
        }

        self.snp.makeConstraints { make in
            make.bottom.equalTo(container).offset(offset)
        }
    }

    @objc private func toggleSwitch() {
        self.selected = toggle.isOn
        toggleAction?(self.selected)
    }

    override func accessibilityActivate() -> Bool {
        toggle.setOn(!toggle.isOn, animated: true)
        self.selected = toggle.isOn
        toggleAction?(self.selected)

        return true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private struct LayoutMetrics {
        static let stackViewSpacing: CGFloat = 12
        static let stackViewOffset: CGFloat = 12
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct GeolocationCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }

    struct ContentView: UIViewRepresentable {

        func makeUIView(context: Context) -> UIView {
            return GeolocationCardView()
        }

        func updateUIView(_ uiView: UIView, context: Context) {}
    }
}
#endif
