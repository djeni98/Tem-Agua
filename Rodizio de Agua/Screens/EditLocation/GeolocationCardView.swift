//
//  GeolocationCardView.swift
//  Rodizio de Agua
//
//  Created by Djenifer Renata Pereira on 10/10/21.
//

import UIKit
import SnapKit

class GeolocationCardView: CardView {
    var selected = true

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Usar geolocalização"
        label.font = .preferredFont(forTextStyle: .body)

        return label
    }()

    var toggleAction: ((Bool) -> Void)?

    private lazy var toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = selected
        toggle.addTarget(self, action: #selector(toggleSwitch), for: .valueChanged)

        return toggle
    }()

    private lazy var container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = LayoutMetrics.stackViewSpacing

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(toggle)

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
        layer.shadowOpacity = selected ? BalloonsLayoutMetrics.shadowOpacity : 0

        toggleAction?(self.selected)
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
