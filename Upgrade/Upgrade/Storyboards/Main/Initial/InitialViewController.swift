import UIKit
import Firebase
import Hero

class InitialViewController: UIViewController {

    // MARK: - Overrides
    /// Overrides preferred status bar style (color) from black (default) to white.
    /* NOTE: This does not affect the general status bar style in other View Controllers or LaunchScreen.storyboard; they will have to be set manually or through Info.plist.
             This notice will only appear once.
    */
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        /// Calls Firebase Auth to retrieve currentUser state and use logic to redirect user;
        /* If:
           a. user != nil (user is signed in), redirect to HomeViewController
           b. user == nil (user not signed in), redirect to WelcomeViewController
        */
        let user = Auth.auth().currentUser
        
        if user != nil {
            print("upgradeconsoleAUTH: User is signed in, redirecting to HomeViewController...")
            performSegue(withIdentifier: "signedIn", sender: nil)
        } else {
            print("upgradeconsoleAUTH: User is not signed in, redirecting to WelcomeViewController...")
            performSegue(withIdentifier: "signedOut", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /// Overrides segues and adds additional information onto the segue.
        /* In this instance, the Hero framework is used to configure the transition type for each segue.
           This is done by retrieving the end destination of the segue, and then configuring the segue using the Hero framework.
        */
        if segue.identifier == "signedIn" {
            let destination = segue.destination
            destination.hero.modalAnimationType = .zoom
        } else if segue.identifier == "signedOut" {
            let destination = segue.destination
            destination.hero.modalAnimationType = .zoomOut
        }
        
    }


}

