//
//  UpgradeButton.swift
//  Upgrade
//
//  Created by Arash Nur Iman on 22/07/20.
//  Copyright © 2020 Ora. All rights reserved.
//

import UIKit

extension UIButton {

    func applyButtonDesign() {
        // Adds a cornered radius around the sides of the button.
        self.layer.cornerRadius = 10.0

        // Applies the "UP Purple" colour.
        self.backgroundColor = UIColor(named: "UP Purple")!
    }

}
