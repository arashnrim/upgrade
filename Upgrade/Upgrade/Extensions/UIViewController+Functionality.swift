//
//  UIViewController+Functionality.swift
//  Upgrade
//
//  Created by Arash on 30/07/20.
//  Copyright © 2020 Ora. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func displayAlert(title: String, message: String, override: ((_ alert: UIAlertController) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let override = override {
            override(alert)
        } else {
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.show(alert, sender: nil)
        }
    }
    
}
