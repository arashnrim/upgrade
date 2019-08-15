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
    /// Overrides preferred status bar style (color) from black (default) to white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Prints out to command line for better debugging purposes.
        print("upgradeconsoleREDIRECT: Redirection to SettingsViewController executed.")
        
        /// Calls extension function configureView() (see UIView+Design.swift) to configure background gradient color for SettingsViewController.
        self.view.configureView(color1: "UP Purple", color2: "UP Blue")
        
        /// Configures viewMain to have a cornerRadius of 20; some corners are then masked to retain the original rectangle shape.
        viewMain.layer.cornerRadius = 20
        viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        /// Retrieves the user display name; if present, it will be displayed to the user.
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
        let signOutAlert = UIAlertController(title: "Are you sure?", message: "Your session in Upgrade will end here if you continue.", preferredStyle: .alert)
        signOutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
        }))
        signOutAlert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "signOut", sender: nil)
            } catch let error as NSError {
                fatalError(error.localizedDescription)
            }
        }))
        present(signOutAlert, animated: true)
    }
    
}
