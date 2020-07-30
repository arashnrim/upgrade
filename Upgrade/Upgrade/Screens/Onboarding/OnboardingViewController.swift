//
//  OnboardingViewController.swift
//  Upgrade
//
//  Created by Arash on 28/07/20.
//  Copyright © 2020 Ora. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: Functions
    func isNameValid() -> Bool {
        guard let name = nameTextField.text else {
            print("Warning: An error occurred while fetching the text value of nameTextField. Following functions may fail.")
            return false
        }
        
        return !(name.isEmpty || name == "")
    }
    
    // MARK: Actions
    @IBAction func continueButton(_ sender: Any) {
        // Verifies if the user name is valid before continuing.
        // If no user name is provided, the app will prompt via a UIAlert.
        // Else, the name is saved locally.
        let nameValid = isNameValid()
        
        if nameValid {
            // TODO: Save the data here and add the segue. Please amend later on.
        } else {
            self.displayAlert(title: "Wait a second!", message: "You've not given us a name to address you by. You can override this decision and use the app without a name or dismiss this alert to enter your name again.") { (alert) in
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                
                // TODO: This is pre-defined and not the expected behaviour. Please amend later on.
                alert.addAction(UIAlertAction(title: "Proceed without Name", style: .destructive, handler: nil))
            }
        }
    }
    
}
