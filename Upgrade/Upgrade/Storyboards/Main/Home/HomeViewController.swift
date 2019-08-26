import UIKit
import Hero
import Firebase

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var viewBar: UIView!
    @IBOutlet var viewMain: UIView!
    @IBOutlet var labelQuote: UILabel!
    @IBOutlet var labelAuthor: UILabel!
    @IBOutlet var imageIllustration: UIImageView!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelGreeting: UILabel!
    
    // MARK: - Properties
    let quotes = Quotes()
    var quoteCount = Int.random(in: 1..<8)
    var imageCount = Int.random(in: 1..<3)
    let illustrations = ["Bookworm", "Studying", "Learning"]
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
        labelQuote.text = quotes.quote[quoteCount]
        labelAuthor.text = quotes.author[quoteCount]
        
        /// Configures viewMain to have a cornerRadius of 20; some corners are then masked to retain the original rectangle shape.
        viewMain.layer.cornerRadius = 20
        viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        /// Configures viewBar to have round corners.
        viewBar.layer.cornerRadius = viewBar.bounds.height/2
        
        // Retrieves user name and shows it if available.
        guard let name = Auth.auth().currentUser?.displayName else { return }
        
        if name != "" {
            labelName.text = "Hi \(name),"
        } else {
            labelName.text = "Hi there,"
        }
        
        // Retrieves current time and greets based on time.
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        if hour < 12 {
            labelGreeting.text = "Good morning!"
        } else if hour >= 12 && hour < 18 {
            labelGreeting.text = "Good afternoon!"
        } else {
            labelGreeting.text = "Good evening!"
        }
        
        // Randomizes the image shown.
        imageIllustration.image = UIImage(named: illustrations[imageCount])
        
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
    @IBAction func pannedView(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            if sender.translation(in: self.view).y >= 0 {
                self.viewMain.transform = CGAffineTransform(translationX: 0, y: sender.translation(in: self.view).y)
            }
        case .changed:
            print(sender.translation(in: self.view).y)
            print(self.viewMain.frame.height / 2)
            
            if sender.translation(in: self.view).y >= 0 {
                self.viewMain.transform = CGAffineTransform(translationX: 0, y: sender.translation(in: self.view).y)
            }
            
        case .ended:
            if sender.direction == .down {
                UIView.animate(withDuration: 0.5) {
                    self.viewMain.transform = CGAffineTransform(translationX: 0, y: 600)
                }
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.viewMain.transform = CGAffineTransform(translationX: 0, y: 0)
                }
            }
            
        case .cancelled:
            if sender.direction == .down {
                UIView.animate(withDuration: 0.5) {
                    self.viewMain.transform = CGAffineTransform(translationX: 0, y: 600)
                }
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.viewMain.transform = CGAffineTransform(translationX: 0, y: 0)
                }
            }
        case .failed:
            if sender.direction == .down {
                UIView.animate(withDuration: 0.5) {
                    self.viewMain.transform = CGAffineTransform(translationX: 0, y: 600)
                }
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.viewMain.transform = CGAffineTransform(translationX: 0, y: 0)
                }
            }
        case .possible:
            break
        @unknown default:
            break
        }
    }
    
}

public enum PanDirection: Int {
    case up, down, left, right
    public var isVertical: Bool { return [.up, .down].contains(self) }
    public var isHorizontal: Bool { return !isVertical }
}

public extension UIPanGestureRecognizer {
    var direction: PanDirection? {
        let velocity = self.velocity(in: view)
        let isVertical = abs(velocity.y) > abs(velocity.x)
        switch (isVertical, velocity.x, velocity.y) {
        case (true, _, let y) where y < 0: return .up
        case (true, _, let y) where y > 0: return .down
        case (false, let x, _) where x > 0: return .right
        case (false, let x, _) where x < 0: return .left
        default: return nil
        }
    }
    
}
