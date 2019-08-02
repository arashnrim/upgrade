import UIKit

class AboutViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var viewMain: UIView!
    @IBOutlet var contentView: UIScrollView!
    
    // MARK: - Overrides
    /// Configures status bar color; changes color from black (default) to white for better readability
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Prints out line to command for better debug purposes
        print("upgradeconsoleREDIRECT: Redirection to AboutViewController executed.")
        
        /// Calls extension function configureView() (see UIView+Design.swift) to configure background gradient color for SettingsViewController
        self.view.configureView(color1: "UP Purple", color2: "UP Blue")
        
        /// Configures viewMain to have cornerRadius of 20; some corners are then masked to retain original rectangle shape
        viewMain.layer.cornerRadius = 20
        contentView.layer.cornerRadius = 20
        viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    // MARK: - Actions
    @IBAction func buttonBack(_ sender: UIButton) {
        self.hero.dismissViewController()
    }
    
}
