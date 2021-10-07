//
//  GradientBackgroundView.swift
//  Rodizio de Agua
//
//  Created by Djenifer Renata Pereira on 06/10/21.
//

import UIKit

// Reference
// https://www.advancedswift.com/gradient-view-background-in-swift/

class GradientBackgroundView: UIView {
    // Enables more convenient access to layer
    internal var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }

    var startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0) {
        didSet { gradientLayer.startPoint = startPoint }
    }

    var endPoint: CGPoint = CGPoint(x: 1.0, y: 1.0) {
        didSet { gradientLayer.endPoint = endPoint }
    }

    // implement cgcolorgradient in the next section
    var startColor: UIColor? {
        didSet { gradientLayer.colors = cgColorGradient }
    }

    var endColor: UIColor? {
        didSet { gradientLayer.colors = cgColorGradient }
    }

    // For this implementation, both colors are required to display
    // a gradient. You may want to extend cgColorGradient to support
    // other use cases, like gradients with three or more colors.
    internal var cgColorGradient: [CGColor]? {
        guard let startColor = startColor, let endColor = endColor else {
            return nil
        }

        return [startColor.cgColor, endColor.cgColor]
    }

    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }

    static func getBlueLinearGradient() -> GradientBackgroundView {
        let gradient = GradientBackgroundView()
        gradient.startColor = .systemIndigo
        gradient.endColor = .systemBlue

        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0)

        return gradient
    }
}
