import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var buttonContinue: UIButton!
    
    // MARK: - Overrides
    /// Configures status bar color; changes color from black (default) to white for better readability
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Prints out line to command for better debug purposes
        print("upgradeconsoleREDIRECT: Redirection to WelcomeViewController executed.")
        
        /// Calls extension function configureButton (see UIButton+Design.swift) to configure overall design for buttonContinue
        buttonContinue.configureButton()
        
    }
    
}
