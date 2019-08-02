import UIKit
import Hero
import Firebase

class AccountViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet var viewMain: UIView!
    @IBOutlet var viewCredentials: UIView!
    @IBOutlet var fieldName: UITextField!
    @IBOutlet var fieldEmail: UITextField!
    @IBOutlet var fieldUID: UITextField!
    @IBOutlet var buttonUpdate: UIButton!
    
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
        print("upgradeconsoleREDIRECT: Redirection to AccountViewController executed.")
        
        /// Calls extension function configureView() (see UIView+Design.swift) to configure background gradient color for AccountViewController
        self.view.configureView(color1: "UP Purple", color2: "UP Blue")
        
        /// Assigns the delegates to the textFields to manage keyboard first responders.
        fieldName.delegate = self
        fieldEmail.delegate = self
        fieldUID.delegate = self
        
        /// Calls extension function configureTextField() (see UITextField+Design.swift) to configure the overall design for the textFields.
        fieldName.configureTextField()
        fieldEmail.configureTextField()
        fieldUID.configureTextField()
        
        fieldUID.layer.shadowOpacity = 0
        
        /// Embeds icons into the textFields for better user readability (see UITextField+Design.swift).
        fieldName.tintColor = .gray
        fieldEmail.tintColor = .gray
        fieldUID.tintColor = .gray
        fieldName.setIcon(#imageLiteral(resourceName: "Name"))
        fieldEmail.setIcon(#imageLiteral(resourceName: "User"))
        fieldUID.setIcon(#imageLiteral(resourceName: "Password"))
        
        /// Calls extension function configureButton() (see UIButton+Design.swift) to configure the overall design for buttonContinue.
        buttonUpdate.configureButton(color1: "UP Purple", color2: "UP Blue")
        
        /// Configures viewMain to have cornerRadius of 20; some corners are then masked to retain original rectangle shape
        viewMain.layer.cornerRadius = 20
        viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        /// Retrieves the user information and displays to the user
        guard let user = Auth.auth().currentUser else { return }
        
        fieldName.text = user.displayName
        fieldEmail.text = user.email
        fieldUID.text = user.uid
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        /// Overrides segues and adds additional information onto the segue.
        /* In this instance, the Hero framework is used to configure the transition type for each segue.
         This is done by retrieving the end destination of the segue, and then configuring the segue using the Hero framework.
         */
        if segue.identifier == "delete" {
            destination.hero.modalAnimationType = .selectBy(presenting: .cover(direction: .left), dismissing: .uncover(direction: .right))
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
    /* If the current textField is fieldName, the keyboard will be resigned and the focus is switched over to fieldEmail.
     Else, if the current textField is fieldEmail, the keyboard will be resigned and the focus is switched over to fieldPassword.
     Else, the current textField if fieldPassword, the keyboard will be resigned.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case fieldName:
            fieldName.resignFirstResponder()
            fieldEmail.becomeFirstResponder()
        default:
            fieldEmail.resignFirstResponder()
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
            fieldName.isEnabled = true
            fieldEmail.isEnabled = true
            buttonUpdate.isEnabled = true
            
            fieldName.layer.shadowOpacity = 0.2
            fieldEmail.layer.shadowOpacity = 0.2
            buttonUpdate.layer.shadowOpacity = 0.2
            
            buttonUpdate.alpha = 1
            
            buttonUpdate.setTitle("Update", for: .normal)
        } else {
            fieldName.isEnabled = false
            fieldEmail.isEnabled = false
            buttonUpdate.isEnabled = false
            
            fieldName.layer.shadowOpacity = 0
            fieldEmail.layer.shadowOpacity = 0
            buttonUpdate.layer.shadowOpacity = 0
            
            buttonUpdate.alpha = 0.5
        }
    }
    
    /// Creates a UIAlertController with a single UIAlertAction for presentation to the user.
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: NSLocalizedString(title, comment: message), message: NSLocalizedString(message, comment: message), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    // MARK: - Actions
    @IBAction func buttonBack(_ sender: UIButton) {
        self.hero.dismissViewController()
    }
    
    // MARK: - Firebase
    func changeName() {
        status(enabled: false)
        guard let name = fieldName.text else { return }
        guard let currentUser = Auth.auth().currentUser else { return }
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        
        if currentUser.displayName != name {
            changeRequest?.displayName = name
            
            changeRequest?.commitChanges(completion: { (error) in
                if let error = error {
                    self.createAlert(title: "Something went wrong.", message: error.localizedDescription)
                    self.status(enabled: true)
                } else {
                    self.changeEmail()
                }
            })
        } else {
            changeEmail()
        }
       
    }
    
    func changeEmail() {
        guard let email = fieldEmail.text else { return }
        guard let currentUser = Auth.auth().currentUser else { return }
        
        currentUser.updateEmail(to: email) { (error) in
            if error != nil {
                 self.performSegue(withIdentifier: "reauthenticate", sender: nil)
            } else {
                self.createAlert(title: "Done!", message: "Your account details have been updated. You may have to refresh some pages to update the changes.")
            }
        }
        
    }
    
    @IBAction func buttonUpdate(_ sender: UIButton) {
        guard let name = fieldName.text else { return }
        guard let email = fieldEmail.text else { return }
        guard let currentUser = Auth.auth().currentUser else { return }

        if currentUser.displayName == name && currentUser.email == email {
            self.createAlert(title: "Nothing's different.", message: "Nothing has changed, so we intervened the process.")
        } else {
            buttonUpdate.setTitle("Updating...", for: .disabled)
            status(enabled: false)
            changeName()
        }

    }
    
}
