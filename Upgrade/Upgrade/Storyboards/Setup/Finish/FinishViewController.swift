import UIKit
import Hero

class FinishViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var buttonContinue: UIButton!
    
    // MARK: - Overrides
    /// Overrides preferred status bar (color) from black (default) to white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Prints out to command line for better debugging purposes.
        print("upgradeconsoleREDIRECT: User account set up complete.")
        
        /// Calls extension function configureButton() (see UIButton+Design.swift) to configure the overall design for buttonContinue.
        buttonContinue.configureButton(color1: "UP Purple", color2: "UP Blue")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        if segue.identifier == "home" {
            destination.hero.modalAnimationType = .uncover(direction: .down)
        }
    }
    
}
