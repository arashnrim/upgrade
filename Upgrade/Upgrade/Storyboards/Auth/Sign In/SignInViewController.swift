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
    /// Overrides preferred status bar style (color) from black (default) to white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Prints out to command line for better debugging purposes.
        print("upgradeconsoleREDIRECT: Redirection to SignInViewController executed.")
        
        /// Assigns the delegates to the textFields to manage keyboard first responders.
        /* A delegate is an object that acts on behalf of, or in coordination with, another object when that object encounters an event in a program.
           In this instance, the delegates for the textFields are assigned to SignInViewController; from this, SignInViewController acts as the delegate for the UITextField, and therefore protocol functions in SignInViewController can be useable.
           This notice will only appear once.
        */
        fieldEmail.delegate = self
        fieldPassword.delegate = self
        
        /// Calls extension function configureTextField() (see UITextField+Design.swift) to configure the overall design for the textFields.
        fieldEmail.configureTextField()
        fieldPassword.configureTextField()
        
        /// Embeds icons into the textFields for better user readability (see UITextField+Design.swift).
        fieldEmail.tintColor = .gray
        fieldPassword.tintColor = .gray
        fieldEmail.setIcon(#imageLiteral(resourceName: "User"))
        fieldPassword.setIcon(#imageLiteral(resourceName: "Password"))
        
        /// Calls extension function configureButton() (see UIButton+Design.swift) to configure the overall design for buttonContinue.
        buttonSignIn.configureButton(color1: "UP Purple", color2: "UP Blue")
        
        self.dismissKeyboardWhenTapped()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /// Overrides segues and adds additional information onto the segue.
        /* In this instance, the Hero framework is used to configure the transition type for each segue.
         This is done by retrieving the end destination of the segue, and then configuring the segue using the Hero framework.
        */
        if segue.identifier == "signedIn" {
            let destination = segue.destination
            destination.hero.modalAnimationType = .zoomOut
        }
    }
    
    // MARK: - Functions
    // This function is a protocol for UITextFieldDelegate; it is executed when the textField is being interacted with and highlighted.
    /// Retrieves the current, highlighted textField (that is being interacted with) and brings it to the front in viewCredentials.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
        viewCredentials.bringSubviewToFront(currentTextField)
    }
    
    // This function is a protocol for UITextFieldDelegate; it is executed when the return key of the keyboard is pressed.
    /// Evaluates the current active text field.
    /* If the current textField is fieldEmail, the keyboard will be resigned and the focus is switched over to fieldPassword.
       Else, if the current textField is fieldPassword, the keyboard will be resigned.
    */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case fieldEmail:
            fieldEmail.resignFirstResponder()
            fieldPassword.becomeFirstResponder()
        default:
            fieldPassword.resignFirstResponder()
        }
        return true
    }
    
    // This function is a protocol for UITextField Delegate; it is executed when the textField is done editing and proceeds to the next textField.
    /// Evaluates the text in the fields.
    /* If the text is not empty (""), then the shadow is removed, prompting to the user design-wise that their input is no longer needed.
       Else, if the text is empty, the opacity will be restored back to the default value (0.2), prompting to the user design-wise that their input is required.
    */
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
    
    /// Evaluates the current condition and manages the UITextFields and UIButtons states.
    /* The following is changed:
       a. enabled status
       b. shadows (if applicable)
       c. alphas
       d. titles or text
    */
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
    
    /// Creates a UIAlertController with a single UIAlertAction for presentation to the user.
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: NSLocalizedString(title, comment: message), message: NSLocalizedString(message, comment: message), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    // MARK: - Firebase
    /// Retrieves values from textFields and attempts to sign the user in.
    /* This function force-retrieves a value from the textFields and uses it to authenticate the user using Firebase.
       If errors are found, the execution stops with an alert showing the user an error; they can try to perform a solution from this.
    */
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
    
    @IBAction func buttonCancel(_ sender: UIButton) {
        self.hero.dismissViewController()
    }
    
}
