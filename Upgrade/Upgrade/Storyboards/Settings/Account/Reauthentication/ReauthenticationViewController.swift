import UIKit
import Firebase

class ReauthenticationViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet var viewMain: UIView!
    @IBOutlet var viewCredentials: UIView!
    @IBOutlet var fieldEmail: UITextField!
    @IBOutlet var fieldPassword: UITextField!
    @IBOutlet var buttonReauthenticate: UIButton!
    
    // MARK: - Properties
    var currentTextField = UITextField()
    
    // MARK: - Overrides
    /// Overrides preferred status bar style (color) from black (default) to white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        /// Prints out a custom line to the application console for debugging purposes.
        print("upgradeconsoleREDIRECT: Redirection to SignInViewController executed.")
        
        /// Calls extension function configureView() (see UIView+Design.swift) to configure background gradient color for DeleteViewController
        self.view.configureView(color1: "UP Orange", color2: "UP Red")
        
        /// Assigns the delegates to the textFields to manage keyboard first responders.
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
        buttonReauthenticate.configureButton(color1: "UP Orange", color2: "UP Red")
        
        /// Configures viewMain to have cornerRadius of 20; some corners are then masked to retain original rectangle shape
        viewMain.layer.cornerRadius = 20
        viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
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
    
    /// Creates a UIAlertController with a single UIAlertAction for presentation to the user.
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: NSLocalizedString(title, comment: message), message: NSLocalizedString(message, comment: message), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    // MARK: - Firebase
    func reauthenticate() {
        guard let email = fieldEmail.text else { return }
        guard let password = fieldPassword.text else { return }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (user, error) in
            if let error = error {
                self.createAlert(title: "Something went wrong.", message: error.localizedDescription)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })
        
    }
    
    @IBAction func buttonReauthenticate(_ sender: UIButton) {
        reauthenticate()
    }
    
}
