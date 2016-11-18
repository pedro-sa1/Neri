//
//  GradiantLayer.swift
//  Neri
//
//  Created by Ana Carolina Nascimento on 18/11/16.
//  Copyright © 2016 Pedro de Sá. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView
{
    
    @IBInspectable var startColor: UIColor = UIColor.white
    @IBInspectable var endColor:   UIColor = UIColor.black
    
    @IBInspectable var startLocation: Double = 0.05
    @IBInspectable var endLocation:   Double = 0.95
    
    @IBInspectable var horizontalMode: Bool = false
    @IBInspectable var diagonalMode: Bool = false
    
    override class var layerClass: AnyClass
    {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        guard let layer = layer as? CAGradientLayer else { return }
        if horizontalMode {
            if diagonalMode {
                layer.startPoint = CGPoint(x: 1, y: 0)
                layer.endPoint   = CGPoint(x: 0, y: 1)
            } else {
                layer.startPoint = CGPoint(x: 0, y: 0.5)
                layer.endPoint   = CGPoint(x: 1, y: 0.5)
            }
        } else {
            if diagonalMode {
                layer.startPoint = CGPoint(x: 0, y: 0)
                layer.endPoint   = CGPoint(x: 1, y: 1)
            } else {
                layer.startPoint = CGPoint(x: 0.5, y: 0)
                layer.endPoint   = CGPoint(x: 0.5, y: 1)
            }
        }
        layer.locations = [NSNumber(value: startLocation), NSNumber(value: endLocation)]
        layer.colors    = [startColor.cgColor, endColor.cgColor]
    }
    
}
