import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Outlets
    @IBOutlet var viewCredentials: UIView!
    @IBOutlet var fieldName: UITextField!
    @IBOutlet var fieldEmail: UITextField!
    @IBOutlet var fieldPassword: UITextField!
    @IBOutlet var buttonSignUp: UIButton!
    
    // MARK: - Properties
    var currentTextField = UITextField()
    var reference: DocumentReference!
    
    // MARK: - Overrides
    /// Overrides preferred status bar style (color) from black (default) to white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Prints out a custom line to the application console for debugging purposes.
        print("upgradeconsoleREDIRECT: Redirection to SignUpViewController executed.")
        
        /// Assigns the delegates to the textFields to manage keyboard first responders.
        fieldName.delegate = self
        fieldEmail.delegate = self
        fieldPassword.delegate = self
        
        /// Calls extension function configureTextField() (see UITextField+Design.swift) to configure the overall design for the textFields.
        fieldName.configureTextField()
        fieldEmail.configureTextField()
        fieldPassword.configureTextField()
        
        /// Embeds icons into the textFields for better user readability (see UITextField+Design.swift).
        fieldName.tintColor = .gray
        fieldEmail.tintColor = .gray
        fieldPassword.tintColor = .gray
        fieldName.setIcon(#imageLiteral(resourceName: "Name"))
        fieldEmail.setIcon(#imageLiteral(resourceName: "User"))
        fieldPassword.setIcon(#imageLiteral(resourceName: "Password"))
        
        /// Calls extension function configureButton() (see UIButton+Design.swift) to configure the overall design for buttonContinue.
        buttonSignUp.configureButton(color1: "UP Purple", color2: "UP Blue")
        
        self.dismissKeyboardWhenTapped()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /// Overrides segues and adds additional information onto the segue.
        /* In this instance, the Hero framework is used to configure the transition type for each segue.
         This is done by retrieving the end destination of the segue, and then configuring the segue using the Hero framework.
         */
        if segue.identifier == "signedUp" {
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
    /* If the current textField is fieldName, the keyboard will be resigned and the focus is switched over to fieldEmail.
       Else, if the current textField is fieldEmail, the keyboard will be resigned and the focus is switched over to fieldPassword.
       Else, the current textField if fieldPassword, the keyboard will be resigned.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case fieldName:
            fieldName.resignFirstResponder()
            fieldEmail.becomeFirstResponder()
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
            fieldName.isEnabled = true
            fieldEmail.isEnabled = true
            fieldPassword.isEnabled = true
            buttonSignUp.isEnabled = true
            
            fieldName.layer.shadowOpacity = 0.2
            fieldEmail.layer.shadowOpacity = 0.2
            fieldPassword.layer.shadowOpacity = 0.2
            buttonSignUp.layer.shadowOpacity = 0.2
            
            buttonSignUp.alpha = 1
            
            buttonSignUp.setTitle("Sign Up", for: .normal)
        } else {
            fieldName.isEnabled = false
            fieldEmail.isEnabled = false
            fieldPassword.isEnabled = false
            buttonSignUp.isEnabled = false
            
            fieldName.layer.shadowOpacity = 0
            fieldEmail.layer.shadowOpacity = 0
            fieldPassword.layer.shadowOpacity = 0
            buttonSignUp.layer.shadowOpacity = 0
            
            buttonSignUp.alpha = 0.5
        }
    }
    
    /// Creates a UIAlertController with a single UIAlertAction for presentation to the user.
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: NSLocalizedString(title, comment: message), message: NSLocalizedString(message, comment: message), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    // MARK: - Firebase
    /// Retrieves values from textFields and attempts to sign the user up.
    /* This function force-retrieves a value from the textFields and uses it to create a user account using Firebase.
       If errors are found, the execution stops with an alert showing the user an error; they can try to perform a solution from this.
       If no errors are found, the completed function calls the follow-up function, createDatabase().
     */
    func signUp() {
        print("upgradeconsoleAUTH: User account creation started.")
        guard let email = fieldEmail.text else { return }
        guard let password = fieldPassword.text else { return }
        
        if email == "" || password == "" {
            print("upgradeconsoleAUTHERROR: One of the compulsory text fields are left blank.")
            createAlert(title: "Something's missing.", message: "One of the compulsory text fields are left blank.")
        } else {
            status(enabled: false)
            buttonSignUp.setTitle("Creating account...", for: .disabled)
            
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    self.status(enabled: true)
                    self.fieldName.text = ""
                    self.fieldEmail.text = ""
                    self.fieldPassword.text = ""
                    
                    print("upgradeconsoleAUTHERROR: \(error.localizedDescription)")
                    self.createAlert(title: "Something went wrong.", message: error.localizedDescription)
                } else {
                    print("upgradeconsoleAUTH: User account creation successful.")
                    self.createDatabase()
                }
            }
        }
    }
    
    /// Creates a pre-set and pre-value database.
    /* This function creates a pre-set and pre-valued database into the Firestore server.
       If errors are found, the execution stops with an alert showing the user an error (even though most errors are usually programmatically or on the console-side).
       If no errors are found, the completed function calls the follow-up function, uodateName().
    */
    func createDatabase() {
        print("upgradeconsoleDATABASE: Database creation started.")
        buttonSignUp.setTitle("Creating database...", for: .disabled)
        
        // PERSONALISATION: Edit or change subjects here to personalise what is stored in the database
        let languageArts: [String: Any] = ["name": "Language Arts"]
        let mathematics: [String: Any] = ["name": "Mathematics"]
        let science: [String: Any] = ["name": "Science"]
        let motherTongue: [String: Any] = ["name": "Mother Tongue"]
        let integratedHumanities: [String: Any] = ["name": "Integrated Humanities"]
        let appliedSubject: [String: Any] = ["name": "Applied Subject"]
        let data: [String: Any] = ["level": 0]
        guard let userID = Auth.auth().currentUser?.uid else {
            print("upgradeconsoleAUTHERROR: No user or uid found: is the user authenticated?")
            createAlert(title: "Something went wrong.", message: "A user error occured. Please contact discipuli for assistance.")
            return
        }
        
        reference = Firestore.firestore().document("users/\(userID)")
        reference.setData(data)
        
        // PERSONALISATION: Edit or change subjects here to personalise what is stored in the database
        databaseFormat(subject: languageArts)
        databaseFormat(subject: mathematics)
        databaseFormat(subject: science)
        databaseFormat(subject: motherTongue)
        databaseFormat(subject: integratedHumanities)
        databaseFormat(subject: appliedSubject)
        
        print("upgradeconsoleDATABASE: Database creation successfully completed.")
        updateName()
    }
    
    /// Provides a structured format for better organisation and readability of code; sub-function for createDatabase().
    func databaseFormat(subject: [String: Any]) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("upgradeconsoleAUTHERROR: No user or uid found: is the user authenticated?")
            createAlert(title: "Something went wrong.", message: "A user error occured. Please contact discipuli for assistance.")
            return
        }
        
        reference = Firestore.firestore().document("users/\(userID)/subjects/\(subject["name"]!)")
        reference.setData(subject) { (error) in
            if let error = error {
                print("upgradeconsoleDATABASEERROR: \(error.localizedDescription)")
                self.createAlert(title: "Something went wrong.", message: error.localizedDescription)
                
                /// Reverts the process and deletes the user account to start again
                self.reference = Firestore.firestore().document("users/\(userID)")
                self.reference.delete()
                Auth.auth().currentUser?.delete(completion: { (error) in
                    if let error = error {
                        print("upgradeconsoleAUTHERROR: \(error.localizedDescription)")
                    }
                })
                
                self.status(enabled: true)
                self.fieldName.text = ""
                self.fieldEmail.text = ""
                self.fieldPassword.text = ""
            }
        }
    }
    
    /// Retrieves values from fieldName and updates user display name.
    /*  This function sets the user display name based on what is given by the user.
        If errors are found, the execution stops with an alert showing the user an error (even though most errors are usually programmatically or on the console-side).
        If no errors are found, the completed function performs the segue signedUp.
    */
    func updateName() {
        print("upgradeconsoleAUTH: Changing user display name.")
        buttonSignUp.setTitle("Updating name...", for: .disabled)
        
        guard let request = Auth.auth().currentUser?.createProfileChangeRequest() else { return }
        guard let name = fieldName.text else { return }
        
        if name == "" {
            print("upgradeconsoleAUTH: No value provided, skipping function")
            performSegue(withIdentifier: "signedUp", sender: nil)
        } else {
            request.displayName = name
            request.commitChanges { (error) in
                if let error = error {
                    print("upgradeconsoleAUTHERROR: \(error.localizedDescription)")
                    self.createAlert(title: "Something went wrong.", message: error.localizedDescription)
                } else {
                    print("upgradeconsoleAUTH: User display name changed successfully.")
                    self.performSegue(withIdentifier: "signedUp", sender: nil)
                }
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func buttonSignUp(_ sender: UIButton) {
        signUp()
    }
    
    @IBAction func buttonCancel(_ sender: UIButton) {
        self.hero.dismissViewController()
    }
    
}
