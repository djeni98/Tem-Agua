//
//  UIFont+.swift
//  Rodizio de Agua
//
//  Created by Djenifer Renata Pereira on 06/10/21.
//

import UIKit

extension UIFont {
    func rounded() -> UIFont {
        guard let descriptor = fontDescriptor.withDesign(.rounded) else {
            return self
        }

        return UIFont(descriptor: descriptor, size: pointSize)
    }

    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0) //size 0 means keep the size as it is
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
}
