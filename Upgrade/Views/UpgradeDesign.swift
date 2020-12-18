//
//  UpgradeHeaderView.swift
//  Upgrade
//
//  Created by Arash Nur Iman on 21/07/20.
//  Copyright © 2020 Ora. All rights reserved.
//

import UIKit

extension UIButton {

    func applyButtonDesign(_ gradientLayer: CAGradientLayer) {
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
        self.layer.addSublayer(gradientLayer)
    }

}

extension UIView {

    func applyHeaderDesign(_ gradientLayer: CAGradientLayer) {
        self.layer.addSublayer(gradientLayer)
    }

}
