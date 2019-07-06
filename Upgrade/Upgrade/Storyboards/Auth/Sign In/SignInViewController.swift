import UIKit
import Firebase

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet var viewCredentials: UIView!
    @IBOutlet var fieldEmail: UITextField!
    @IBOutlet var fieldPassword: UITextField!
    @IBOutlet var buttonSignIn: UIButton!
    
    // MARK: - Properties
    var currentTextField = UITextField()
    
    // MARK: - Overrides
    /// Configures status bar color; changes color from black (default) to white for better readability
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Prints out line to command for better debug purposes
        print("upgradeconsoleREDIRECT: Redirection to SignInViewController executed.")
        
        /// Assigns textFieldDelegates to the textFields for management of keyboard first responders
        fieldEmail.delegate = self
        fieldPassword.delegate = self
        
        /// Calls extension function configureTextField (see UITextField+Design.swift) to configure overall design for textFields
        fieldEmail.configureTextField()
        fieldPassword.configureTextField()
        
        /// Embeds icons into the textFields for better user readability
        fieldEmail.tintColor = .gray
        fieldPassword.tintColor = .gray
        fieldEmail.setIcon(#imageLiteral(resourceName: "User"))
        fieldPassword.setIcon(#imageLiteral(resourceName: "Password"))
        
        /// Calls extension function configureButton (see UIButton+Design.swift) to configure overall design for buttonContinue
        buttonSignIn.configureButton()
        
    }
    
    // MARK: - Functions
    /// This function executes when the textField is highlighted and editing begins
    /// The code changes the value of currentTextField to the current highlighted textField, and requests that viewCredentials bring the currentTextField to the front
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
        viewCredentials.bringSubviewToFront(currentTextField)
    }
    
    /// This function executes when the return key in the current textField is pressed
    /// The code evaluates the current active text field; if the current textField is fieldEmail, the keyboard will be resigned and the focus is switched over to fieldPassword
    /// If the current textField is fieldPassword, the keyboard will be resigned
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fieldEmail {
            fieldEmail.resignFirstResponder()
            fieldPassword.becomeFirstResponder()
        } else {
            fieldPassword.resignFirstResponder()
        }
        return true
    }
    
    /// This function executes when the textField is done editing and proceeds to the next textField
    /// The code evaluates the text in the fields; if the text is not empty (""), then the shadow is removed, prompting to the user design-wise that their input is no longer needed
    /// If the above mentioned is not true, then the opacity will be restored back to the default value (0.2)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if currentTextField.text != "" {
            UIView.animate(withDuration: 1) {
                self.currentTextField.layer.shadowOpacity = 0
            }
        } else {
            UIView.animate(withDuration: 1) {
                self.currentTextField.layer.shadowOpacity = 0.2
            }
        }
    }
    
    /// Evaluates the current condition and manages the UITextFields and UIButtons states
    /// The following is changed:
    /// a. enabled status
    /// b. shadows (if applicable)
    /// c. alphas
    /// d. titles or text
    func status(enabled: Bool) {
        if enabled == true {
            fieldEmail.isEnabled = true
            fieldPassword.isEnabled = true
            buttonSignIn.isEnabled = true
            
            fieldEmail.layer.shadowOpacity = 0.2
            fieldPassword.layer.shadowOpacity = 0.2
            buttonSignIn.layer.shadowOpacity = 0.2
            
            buttonSignIn.alpha = 1
            
            buttonSignIn.setTitle("Sign In", for: .normal)
        } else {
            fieldEmail.isEnabled = false
            fieldPassword.isEnabled = false
            buttonSignIn.isEnabled = false
            
            fieldEmail.layer.shadowOpacity = 0
            fieldPassword.layer.shadowOpacity = 0
            buttonSignIn.layer.shadowOpacity = 0
            
            buttonSignIn.alpha = 0.5
        }
    }
    
    /// Creates a UIAlertController with a customised message for the user
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: NSLocalizedString(title, comment: message), message: NSLocalizedString(message, comment: message), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    // MARK: - Firebase
    func signIn() {
        guard let email = fieldEmail.text else { return }
        guard let password = fieldPassword.text else { return }
        
        if email == "" || password == "" {
            createAlert(title: "Something's missing.", message: "One of the compulsory text fields are left blank.")
        } else {
            status(enabled: false)
            buttonSignIn.setTitle("Signing in...", for: .disabled)
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    self.status(enabled: true)
                    self.fieldEmail.text = ""
                    self.fieldPassword.text = ""
                    
                    self.createAlert(title: "Something went wrong.", message: error.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "signedIn", sender: nil)
                }
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func buttonSignIn(_ sender: UIButton) {
        signIn()
    }
    
}
