//
//  LeftBalloonView.swift
//  Rodizio de Agua
//
//  Created by Djenifer Renata Pereira on 06/10/21.
//

import UIKit

class LeftBalloonView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShadow()
        backgroundColor = .appBackgroundSecondary
    }

    internal func setupShadow() {
        let offset = BalloonsLayoutMetrics.shadowOffset
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: offset, height: offset)
        layer.shadowOpacity = BalloonsLayoutMetrics.shadowOpacity
        layer.shadowRadius = BalloonsLayoutMetrics.shadowRadius
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

