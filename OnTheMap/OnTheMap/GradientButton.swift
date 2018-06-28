//
//  GradientButton.swift
//  OnTheMap
//
//  Created by Bernadett Kiss on 6/28/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import UIKit

@IBDesignable
class GradientButton: UIButton {
    
    let gradientLayer = CAGradientLayer()
    
    let topColor: UIColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    let bottomColor: UIColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    let cornerRadius: CGFloat = 7.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        alpha = 0.8
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        alpha = 1
    }
    
    override func cancelTracking(with event: UIEvent?) {
        alpha = 1
    }
    
    private func setupView() {
        setGradient(topColor: topColor, bottomColor: bottomColor)
        layer.masksToBounds = true
    }
    
    private func setGradient(topColor: UIColor, bottomColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.cornerRadius = cornerRadius
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
