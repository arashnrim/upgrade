import UIKit

class MenuViewController: UIViewController {
    
    // MARK: - Overrides
    /// Configures status bar color; changes color from black (default) to white for better readability
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Prints out line to command for better debug purposes
        print("upgradeconsoleREDIRECT: Redirection to MenuViewController executed.")
        
        /// Calls extension function (see UIView+Design.swift) to configure background gradient color for HomeViewController
        self.view.configureViewController(color1: "UP Purple", color2: "UP Blue")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /// Configures Hero transitions for segues signedIn and signedOut
        if segue.identifier == "dismiss" {
            let destination = segue.destination
            destination.hero.modalAnimationType = .uncover(direction: .left)
        }
        
    }

    @IBAction func buttonCancel(_ sender: UIButton) {
        self.hero.dismissViewController()
    }
    
}
