//
//  UIView+.swift
//  Rodizio de Agua
//
//  Created by Djenifer Renata Pereira on 06/10/21.
//

import UIKit

extension UIView {
    func leftBalloonCornerRadius() {
        clipsToBounds = false
        layer.cornerRadius = BalloonsLayoutMetrics.cornerRadius
        layer.maskedCorners = [
            .layerMaxXMinYCorner,

            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner
        ]
    }

    func rightBalloonCornerRadius() {
        clipsToBounds = false
        layer.cornerRadius = BalloonsLayoutMetrics.cornerRadius
        layer.maskedCorners = [
            .layerMinXMinYCorner,

            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner
        ]
    }
}
