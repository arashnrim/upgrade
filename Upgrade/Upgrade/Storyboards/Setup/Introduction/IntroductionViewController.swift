import UIKit

class IntroductionViewController: UIViewController {

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
        print("upgradeconsoleREDIRECT: User account not set up, redirecton to SetupViewController executed.")

        /// Calls extension function configureButton() (see UIButton+Design.swift) to configure the overall design for buttonContinue.
        buttonContinue.configureButton(color1: "UP Purple", color2: "UP Blue")

    }

}
