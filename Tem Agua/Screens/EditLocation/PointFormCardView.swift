//
//  PointFormCardView.swift
//  Tem Agua
//
//  Created by Djenifer Renata Pereira on 11/10/21.
//

import UIKit
import SnapKit

class PointFormCardView: CardView {

    var selected: Bool = false {
        didSet { isSelected(selected) }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Inserir manualmente"
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.numberOfLines = 0

        return label
    }()

    var latitude: Double? {
        get { Double(latitudeTextField.text ?? "") }
        set { latitudeTextField.text = newValue == nil ? nil : String(describing: newValue!) }
    }

    private lazy var latitudeTextField: CoordinateTextField = {
        let textField = CoordinateTextField()
        textField.placeholder = "Latitude"

        return textField
    }()

    var longitude: Double? {
        get { Double(longitudeTextField.text ?? "") }
        set { longitudeTextField.text = newValue == nil ? nil : String(describing: newValue!) }
    }

    private lazy var longitudeTextField: CoordinateTextField = {
        let textField = CoordinateTextField()
        textField.placeholder = "Longitude"

        return textField
    }()

    var isValid: Bool {
        get { latitude != nil && longitude != nil }
    }

    private lazy var container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = LayoutMetrics.stackViewSpacing

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(latitudeTextField)
        stackView.addArrangedSubview(longitudeTextField)

        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()

        isSelected(selected)
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

    private func isSelected(_ selected: Bool) {
        layer.shadowOpacity = selected ? BalloonsLayoutMetrics.shadowOpacity : 0
        titleLabel.textColor = selected ? .label : .secondaryLabel
        latitudeTextField.isEnabled = selected
        longitudeTextField.isEnabled = selected
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private struct LayoutMetrics {
        static let stackViewSpacing: CGFloat = 16
        static let stackViewOffset: CGFloat = 12
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct PointFormCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }

    struct ContentView: UIViewRepresentable {

        func makeUIView(context: Context) -> UIView {
            return PointFormCardView()
        }

        func updateUIView(_ uiView: UIView, context: Context) {}
    }
}
#endif
