//
//  GradientView.swift
//  iMonoChat
//
//  Created by Alisher Abdukarimov on 8/9/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

// able to work in sotryboard
@IBDesignable
class GradientView: UIView {
    
    // dynamicallky change
    @IBInspectable var topColor: UIColor = .blue {
        didSet {
            self.setNeedsLayout()
        }
    }
    // dynamicallky change
    @IBInspectable var bottomColor: UIColor = .green {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        // we need color, needs starting and end point, how big shape will it be filling
        
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        // x origin top left 0, ... positive to the right
        // y origin top left 0 ... negative to the bottom
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
