import UIKit
import Firebase
import Hero

class InitialViewController: UIViewController {

    // MARK: - Overrides
    /// Configures status bar color; changes color from black (default) to white for better readability
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        /// Calls forward Firebase Auth to verify currentUser state.
        /// If:
        /// a. user != nil (user is signed in), redirect to HomeViewController
        /// b. user == nil (user not signed in), redirect to WelcomeViewController
        let user = Auth.auth().currentUser
        
        // TODO: - Create HomeViewController and WelcomeViewController
        // Code has been commented to prevent crashes; please remove this when implementation is done.
        if user != nil {
            print("upgradeconsoleAUTH: User is signed in, redirecting to HomeViewController...")
            performSegue(withIdentifier: "signedIn", sender: nil)
        } else {
            print("upgradeconsoleAUTH: User is not signed in, redirecting to WelcomeViewController...")
            performSegue(withIdentifier: "signedOut", sender: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /// Configures Hero transitions for segues signedIn and signedOut
        if segue.identifier == "signedIn" {
            let destination = segue.destination
            destination.hero.modalAnimationType = .zoom
        } else if segue.identifier == "signedOut" {
            let destination = segue.destination
            destination.hero.modalAnimationType = .zoomOut
        }
        
    }


}

