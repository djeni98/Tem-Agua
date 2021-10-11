//
//  BorderedTextField.swift
//  Rodizio de Agua
//
//  Created by Djenifer Renata Pereira on 11/10/21.
//

import UIKit

class BorderedTextField: UITextField {
    private let insetX: CGFloat = 16
    private let insetY: CGFloat = 10

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }

    static func get() -> BorderedTextField {
        let textField = BorderedTextField()
        textField.backgroundColor = .appBackground
        textField.layer.cornerRadius = 12
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1

        return textField
    }
}
