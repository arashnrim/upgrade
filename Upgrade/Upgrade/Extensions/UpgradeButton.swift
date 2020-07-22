//
//  UpgradeButton.swift
//  Upgrade
//
//  Created by Arash Nur Iman on 22/07/20.
//  Copyright © 2020 Ora. All rights reserved.
//

import UIKit

class UpgradeButton: UIButton {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.layer.cornerRadius = 10.0
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(named: "UP Blue")!.cgColor, UIColor(named: "UP Purple")!.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = self.bounds
        gradient.cornerRadius = 10.0
        self.layer.insertSublayer(gradient, at: 0)
        self.clipsToBounds = true
    }
    
}
