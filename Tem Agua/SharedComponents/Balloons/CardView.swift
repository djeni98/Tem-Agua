//
//  CardView.swift
//  Tem Agua
//
//  Created by Djenifer Renata Pereira on 10/10/21.
//

import UIKit

class CardView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShadow()

        backgroundColor = .appBackgroundSecondary
        layer.cornerRadius = BalloonsLayoutMetrics.cornerRadius
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
