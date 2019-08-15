import UIKit

class AddViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var viewMain: UIView!
    
    // MARK: - Properties
    var subject = String()
    
    // MARK: - Overrides
    /// Overrides preferred status bar style (color) from black (default) to white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Prints out to command line for better debugging purposes.
        print("upgradeconsoleREDIRECT: Redirection to AddViewController executed.")
        
        /// Calls extension function configureView() (see UIView+Design.swift) to configure background gradient color for SettingsViewController.
        self.view.configureView(color1: "UP Purple", color2: "UP Blue")
        
        /// Configures viewMain to have a cornerRadius of 20; some corners are then masked to retain the original rectangle shape.
        viewMain.layer.cornerRadius = 20
        viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }
    
    // MARK: - Actions
    @IBAction func buttonCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
