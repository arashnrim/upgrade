import UIKit

class MenuViewController: UIViewController {
    
    // MARK: - Overrides
    /// Overrides preferred status bar style (color) from black (default) to white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Prints out to command line for better debugging purposes.
        print("upgradeconsoleREDIRECT: Redirection to MenuViewController executed.")
        
        /// Calls extension function configureView() (see UIView+Design.swift) to configure the background gradient color for MenuViewController.
        self.view.configureView(color1: "UP Purple", color2: "UP Blue")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        /// Configures Hero transitions for segue menu
        if segue.identifier == "dismiss" {
            destination.hero.modalAnimationType = .uncover(direction: .left)
        }
        
    }

    @IBAction func buttonCancel(_ sender: UIButton) {
        self.hero.dismissViewController()
    }
    
}
