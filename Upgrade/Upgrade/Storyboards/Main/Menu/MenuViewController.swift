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
        
        /// Calls extension function configureView() (see UIView+Design.swift) to configure background gradient color for MenuViewController
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
