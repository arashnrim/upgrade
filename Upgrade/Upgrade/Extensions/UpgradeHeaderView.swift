//
//  UpgradeHeaderView.swift
//  Upgrade
//
//  Created by Arash Nur Iman on 21/07/20.
//  Copyright © 2020 Ora. All rights reserved.
//

import UIKit

class UpgradeHeaderView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    /**
     * Initialises the View with a rounded corner (bottom-right) and a gradient.
     *
     * This function is simply invoking two other functions, `roundCorners()` and `addGradient()`. See more about them below.
     */
    private func setupView() {
        roundCorners()
        addGradient()
    }
    
    /**
     * Rounds the bottom-right corner of the View.
     */
    func roundCorners() {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .bottomRight, cornerRadii: CGSize(width: 20.0, height: 20.0))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    /**
     * Adds Upgrade's blue-purple gradient across the View.
     *
     * This function applies the gradient in a diagonal way — the blue will be located at the upper-left corner `(x: 0, y: 0)` and the purple is located at the lower-right corner `(x: 1, y: 1)`
     */
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(named: "UP Blue")!.cgColor, UIColor(named: "UP Purple")!.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}
