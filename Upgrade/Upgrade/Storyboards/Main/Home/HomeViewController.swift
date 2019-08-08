import UIKit
import Hero
import Firebase

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var viewBar: UIView!
    @IBOutlet var viewMain: UIView!
    @IBOutlet var labelQuote: UILabel!
    @IBOutlet var labelAuthor: UILabel!
    
    // MARK: - Properties
    let quotes = Quotes()
    var count = Int.random(in: 1..<8)
    var reference: DocumentReference!
    
    // MARK: - Overrides
    /// Overrides preferred status bar style (color) from black (default) to white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Prints out to command line for better debugging purposes.
        print("upgradeconsoleREDIRECT: Redirection to WelcomeViewController executed.")

        /// Calls extension function configureView() (see UIView+Design.swift) to configure the background gradient color for HomeViewController.
        self.view.configureView(color1: "UP Purple", color2: "UP Blue")
        
        /// Calls struct Quotes to assign and display a random quote.
        labelQuote.text = quotes.quote[count]
        labelAuthor.text = quotes.author[count]
        
        /// Configures viewMain to have a cornerRadius of 20; some corners are then masked to retain the original rectangle shape.
        viewMain.layer.cornerRadius = 20
        viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        /// Configures viewBar to have round corners.
        viewBar.layer.cornerRadius = viewBar.bounds.height/2
        
        /// Adds gesture recognizers to move viewMain up and down.
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestures(gesture:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        viewMain.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestures(gesture:)))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        viewMain.addGestureRecognizer(swipeUp)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        reference = Firestore.firestore().document("users/\(uid)")
        reference.getDocument { (docSnapshot, error) in
            if let docSnapshot = docSnapshot {
                if let data = docSnapshot.data() {
                    let level = data["level"] as! Int
                    
                    if level == 0 {
                        self.performSegue(withIdentifier: "setup", sender: nil)
                    }
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        /// Overrides segues and adds additional information onto the segue.
        /* In this instance, the Hero framework is used to configure the transition type for each segue.
         This is done by retrieving the end destination of the segue, and then configuring the segue using the Hero framework.
         */
        if segue.identifier == "menu" {
            destination.hero.modalAnimationType = .selectBy(presenting: .cover(direction: .right), dismissing: .uncover(direction: .left))
        } else if segue.identifier == "signedOut" {
            destination.hero.modalAnimationType = .zoomOut
        }
        
    }
    
    // MARK: - Functions
    @objc func swipeGestures(gesture: UIGestureRecognizer) {
        if let gesture = gesture as? UISwipeGestureRecognizer {
            switch gesture.direction {
            case UISwipeGestureRecognizer.Direction.down:
                UIView.animate(withDuration: 0.5) {
                    self.viewMain.transform = CGAffineTransform(translationX: 0, y: 600)
                }
            case UISwipeGestureRecognizer.Direction.up:
                UIView.animate(withDuration: 0.5) {
                    self.viewMain.transform = CGAffineTransform(translationX: 0, y: 0)
                }
            default:
                break
            }
        }
    }
    
}
