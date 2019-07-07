import UIKit
import Hero

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var viewBar: UIView!
    @IBOutlet var viewMain: UIView!
    @IBOutlet var labelQuote: UILabel!
    @IBOutlet var labelAuthor: UILabel!
    
    // MARK: - Properties
    let quotes = Quotes()
    var count = Int.random(in: 1...8)
    
    // MARK: - Overrides
    /// Configures status bar color; changes color from black (default) to white for better readability
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        /// Prints out line to command for better debug purposes
        print("upgradeconsoleREDIRECT: Redirection to WelcomeViewController executed.")

        /// Calls extension function (see UIView+Design.swift) to configure background gradient color for HomeViewController
        self.view.configureViewController(color1: "UP Purple", color2: "UP Blue")
        
        /// Calls struct Quotes to assign a random quote
        labelQuote.text = quotes.quote[count]
        labelAuthor.text = quotes.author[count]
        
        /// Configures viewMain to have cornerRadius of 20; some corners are then masked to retain original rectangle shape
        viewMain.layer.cornerRadius = 20
        viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        /// Configures viewBar to have round corners
        viewBar.layer.cornerRadius = viewBar.bounds.height/2
        
        /// Adds gesture recognizers to move viewMain up and down
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestures(gesture:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        viewMain.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestures(gesture:)))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        viewMain.addGestureRecognizer(swipeUp)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /// Configures Hero transitions for segues signedIn and signedOut
        if segue.identifier == "menu" {
            let destination = segue.destination
            destination.hero.modalAnimationType = .selectBy(presenting: .cover(direction: .right), dismissing: .uncover(direction: .left))
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
