//
//  UpgradeHeaderView.swift
//  Upgrade
//
//  Created by Arash Nur Iman on 21/07/20.
//  Copyright © 2020 Ora. All rights reserved.
//

import UIKit

class UpgradeHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        roundCorners()
        addGradient()
    }
    
    func roundCorners() {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .bottomRight, cornerRadii: CGSize(width: 20.0, height: 20.0))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(named: "UP Blue")!.cgColor, UIColor(named: "UP Purple")!.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}
