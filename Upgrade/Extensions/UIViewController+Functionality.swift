//
//  UIViewController+Functionality.swift
//  Upgrade
//
//  Created by Arash on 30/07/20.
//  Copyright © 2020 Ora. All rights reserved.
//

import UIKit

extension UIViewController {

    // MARK: - Alerts
    /**
     * Creates an alert that will be displayed to the user.
     *
     * This function makes use of `UIAlertController` and heavily subsidises the need to continually make new alerts whenever needed. This function also presents an optional override if more control over the alert is needed; otherwise, the alert defaults to having one `UIAlertAction` (showing "OK") and dismisses itself automatically.
     *
     * - Parameters:
     *      - title: A string value of the alert's title.
     *      - message: A string value of the alert's full body text.
     *      - override: (Optional) A closure to allow greater customization of the alert. A `UIAlertController` is the only parameter of this closure.
     */
    func displayAlert(title: String, message: String, override: ((_ alert: UIAlertController) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if let override = override {
            override(alert)
        } else {
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.show(alert, sender: nil)
        }
    }

    // MARK: - User Defaults
    func saveToUserDefaults(value: Any, key: String, completion: (() -> Void)?) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
        if let completion = completion {
            completion()
        }
    }

    func readFromUserDefaults(key: String) -> Any? {
        let defaults = UserDefaults.standard
        let value = defaults.object(forKey: key)
        return value
    }

}
