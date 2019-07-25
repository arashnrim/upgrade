import UIKit
import Hero
import Firebase

class SettingsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var viewMain: UIView!
    @IBOutlet var labelGreet1: UILabel!
    @IBOutlet var labelGreet2: UILabel!
    @IBOutlet var viewAccount: UIView!
    @IBOutlet var viewAbout: UIView!
    @IBOutlet var viewSignOut: UIView!
    
    // MARK: - Overrides
    /// Configures status bar color; changes color from black (default) to white for better readability
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Prints out line to command for better debug purposes
        print("upgradeconsoleREDIRECT: Redirection to SettingsViewController executed.")
        
        /// Calls extension function configureView() (see UIView+Design.swift) to configure background gradient color for SettingsViewController
        self.view.configureView(color1: "UP Purple", color2: "UP Blue")
        
        /// Configures viewMain to have cornerRadius of 20; some corners are then masked to retain original rectangle shape
        viewMain.layer.cornerRadius = 20
        viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /// Retrieves the user display name; if present, it will be displayed to the user
        guard let userName = Auth.auth().currentUser?.displayName else { return }
        
        if userName != "" {
            labelGreet1.text = "Hi there,"
            labelGreet2.text = "\(userName)!"
        } else {
            labelGreet1.text = "Hello"
            labelGreet2.text = "there!"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        /// Overrides segues and adds additional information onto the segue.
        /* In this instance, the Hero framework is used to configure the transition type for each segue.
         This is done by retrieving the end destination of the segue, and then configuring the segue using the Hero framework.
         */
        if segue.identifier == "menu" {
            destination.hero.modalAnimationType = .selectBy(presenting: .cover(direction: .right), dismissing: .uncover(direction: .left))
        } else if segue.identifier == "account" {
            destination.hero.modalAnimationType = .selectBy(presenting: .cover(direction: .left), dismissing: .uncover(direction: .right))
        } else if segue.identifier == "about" {
            destination.hero.modalAnimationType = .selectBy(presenting: .cover(direction: .left), dismissing: .uncover(direction: .right))
        } else if segue.identifier == "signOut" {
            destination.hero.modalAnimationType = .zoom
        }
        
    }
    
    // MARK: - Actions
    @IBAction func buttonSignOut(_ sender: UIButton) {
        let alert = UIAlertController(title: NSLocalizedString("Are you sure?", comment: "Lets the user confirm their chocie"), message: NSLocalizedString("Signing out will lead you back into the sign in page.", comment: "Shows instructions"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "signOut", sender: nil)
            } catch let error as NSError {
                let alert = UIAlertController(title: NSLocalizedString("Something went wrong.", comment: "Distress title"), message: NSLocalizedString(error.localizedDescription, comment: "Error localized string"), preferredStyle: .alert)
                alert.addTextField(configurationHandler: { (textField) in
                    textField.placeholder = "Email"
                })
                alert.addTextField(configurationHandler: { (textField) in
                    textField.placeholder = "Password"
                })
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (error) in
                    guard let email = alert.textFields![0].text else { return }
                    guard let password = alert.textFields![1].text else { return }
                    
                    let credential = EmailAuthProvider.credential(withEmail: email, password: password)
                    
                    Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (user, error) in
                        if let error = error {
                            let alert = UIAlertController(title: NSLocalizedString("Something went wrong.", comment: "Distress title"), message: NSLocalizedString(error.localizedDescription, comment: "Error localized string"), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                            }))
                            self.present(alert, animated: true)
                        } else {
                            self.performSegue(withIdentifier: "signOut", sender: nil)
                        }
                    })
                }))
                self.present(alert, animated: true)
            }
        }))
        present(alert, animated: true)
        
    }
    
}
