//
//  CoordinateTextField.swift
//  Rodizio de Agua
//
//  Created by Djenifer Renata Pereira on 11/10/21.
//

import UIKit
import SnapKit

class CoordinateTextField: UIView {
    var placeholder: String? {
        get { placeholderLabel.text }
        set { placeholderLabel.text = newValue }
    }

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .secondaryLabel
        label.text = "Placeholder"

        return label
    }()

    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    var isEnabled: Bool {
        get { textField.isEnabled }
        set {
            textField.isEnabled = newValue
            textField.backgroundColor = textField.isEnabled ? .appBackground : .clear
            textField.textColor = textField.isEnabled ? .label : .secondaryLabel
        }
    }
    
    private lazy var textField: BorderedTextField = {
        let textField = BorderedTextField.get()
        // textField.keyboardType = .numberPad

        return textField
    }()

    private lazy var container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = LayoutMetrics.stackViewSpacing

        stackView.addArrangedSubview(placeholderLabel)
        stackView.addArrangedSubview(textField)

        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        self.addSubview(container)
        container.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        self.snp.makeConstraints { make in
            make.bottom.equalTo(container)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private struct LayoutMetrics {
        static let stackViewSpacing: CGFloat = 4
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct LabeledTextField_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }

    struct ContentView: UIViewRepresentable {

        func makeUIView(context: Context) -> UIView {
            return CoordinateTextField()
        }

        func updateUIView(_ uiView: UIView, context: Context) {}
    }
}
#endif
