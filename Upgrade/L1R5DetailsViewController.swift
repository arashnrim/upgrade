import UIKit
import SafariServices

class L1R5DetailsViewController: UIViewController, SFSafariViewControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet var viewMain: UIView!
    @IBOutlet var viewDisplay: UIView!
    @IBOutlet var viewScroll: UIScrollView!
    
    // MARK: - Overrides
    /// Overrides preferred status bar style (color) from black (default) to white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        /// Prints out to command line for better debugging purposes.
        print("upgradeconsoleREDIRECT: Redirection to L1R5DetailsViewController executed.")
        
        /// Calls extension function configureView() (see UIView+Design.swift) to configure background gradient color for DetailViewController.
        self.view.configureView(color1: "UP Purple", color2: "UP Blue")
        
        /// Configures viewMain to have a cornerRadius of 20; some corners are then masked to retain the original rectangle shape.
        viewMain.layer.cornerRadius = 20
        viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewDisplay.layer.cornerRadius = 20
        viewDisplay.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewScroll.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewScroll.layer.cornerRadius = 20
    }
    
    // MARK: - Functions
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @IBAction func buttonBack(_ sender: UIButton) {
        self.hero.dismissViewController()
    }
    
    @IBAction func buttonWeb(_ sender: UIButton) {
        let safariVC = SFSafariViewController(url: URL(string: "https://www.moe.gov.sg/admissions/direct-admissions/dsa-jc/eligibility")!)
        safariVC.delegate = self
        self.present(safariVC, animated: true)
    }
    
}
