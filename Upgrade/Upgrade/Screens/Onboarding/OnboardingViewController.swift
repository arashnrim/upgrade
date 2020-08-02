//
//  OnboardingViewController.swift
//  Upgrade
//
//  Created by Arash on 28/07/20.
//  Copyright © 2020 Ora. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, UITextFieldDelegate {

    // MARK: Outlets
    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets the delegate of the text field as OnboardingViewController.
        self.nameTextField.delegate = self
        
        // Allows editing to end when any part of the screen is tapped outside the keyboard area.
        self.dismissKeyboardOnTap(completion: nil)
    }
    
    // MARK: Text Field Protocols
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(false)
        return false
    }
    
    // MARK: Functions
    /**
     * Verifies if the name in `nameTextField` is valid.
     *
     * If the name is not empty and therefore is valid, this function will return `true`. Otherwise, the function returns `false`.
     *
     * - Returns: A boolean value of the outcome of the check.
     */
    func isNameValid() -> Bool {
        guard let name = nameTextField.text else {
            print("Warning: An error occurred while fetching the text value of nameTextField. Following functions may fail.")
            return false
        }
        
        return !(name.isEmpty || name == "")
    }
    
    func saveName(completion: () -> Void) {
        guard let name = nameTextField.text else {
            print("Warning: An error occurred while fetching the text value of nameTextField. Following functions may fail.")
            return
        }
        let defaults = UserDefaults.standard
        
        defaults.set(name, forKey: "name")
        completion()
    }
    
    // MARK: Actions
    @IBAction func continueButton(_ sender: Any) {
        // Verifies if the user name is valid before continuing.
        // If no user name is provided, the app will prompt via a UIAlert.
        // Else, the name is saved locally.
        let nameValid = isNameValid()
        
        if nameValid {
            saveName {
                self.performSegue(withIdentifier: "complete", sender: nil)
            }
        } else {
            self.displayAlert(title: "Wait a second!", message: "You've not given us a name to address you by. You can override this decision and use the app without a name or dismiss this alert to enter your name again.") { (alert) in
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                
                // TODO: This is pre-defined and not the expected behaviour. Please amend later on.
                alert.addAction(UIAlertAction(title: "Proceed without Name", style: .destructive, handler: nil))
            }
        }
    }
    
}
