//
//  OnboardingViewController.swift
//  Upgrade
//
//  Created by Arash on 28/07/20.
//  Copyright © 2020 Ora. All rights reserved.
//

import UIKit
import Hero

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "complete" {
            let destination = segue.destination
            destination.hero.modalAnimationType = .zoom
        }
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

    /**
     * Saves the user's name to User Defaults.
     *
     * The name is stored locally, and will never leave the phone. This function contains a `completion` closure to execute code after the task has asynchronously concluded.
     *
     * - Parameters:
     *      - completion: A closure to run code after the task has asynchronously concluded.
     */
    func saveName(completion: () -> Void) {
        guard let name = nameTextField.text else {
            print("Warning: An error occurred while fetching the text value of nameTextField. Following functions may fail.")
            return
        }
        let defaults = UserDefaults.standard

        defaults.set(name, forKey: "name")
        defaults.set(true, forKey: "configured")
        completion()
    }

    // MARK: Actions
    @IBAction func continueButton(_ sender: Any) {
        // Verifies if the user name is valid before continuing.
        // If no user name is provided, the app will display a UIAlert; the Alert asks if the user really wants to proceed without a name saved.
        // Else, the name is saved locally.
        let nameValid = isNameValid()

        if nameValid {
            saveName {
                self.performSegue(withIdentifier: "complete", sender: nil)
            }
        } else {
            self.displayAlert(title: "Wait a second!", message: "You've not given us a name to address you by. You can override this decision and use the app without a name or dismiss this alert to enter your name again.") { (alert) in
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))

                alert.addAction(UIAlertAction(title: "Proceed without Name", style: .destructive, handler: { (_) in
                    let defaults = UserDefaults.standard
                    defaults.set(true, forKey: "configured")

                    self.performSegue(withIdentifier: "complete", sender: nil)
                }))

                self.show(alert, sender: nil)
            }
        }
    }

}
