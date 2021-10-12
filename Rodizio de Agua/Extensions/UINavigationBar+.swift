//
//  UINavigationBar+.swift
//  Rodizio de Agua
//
//  Created by Djenifer Renata Pereira on 12/10/21.
//

import UIKit

extension UINavigationBar {
    func setBackgroundHidden() {
        self.backgroundColor = .clear
        self.isTranslucent = true

        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()

        if #available(iOS 13.0, *) {
            self.standardAppearance.backgroundColor = .clear
            self.standardAppearance.backgroundEffect = .none
            self.standardAppearance.shadowColor = .clear
        }
    }
}
