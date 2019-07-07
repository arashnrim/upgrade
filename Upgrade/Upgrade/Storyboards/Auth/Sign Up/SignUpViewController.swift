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
    /// Configures status bar color; changes color from black (default) to white for better readabilty
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Prints out line to command for better debug purposes
        print("upgradeconsoleREDIRECT: Redirection to SignUpViewController executed.")
        
        /// Assigns textFieldDelegates to the textFields for management of keyboard first responders
        fieldName.delegate = self
        fieldEmail.delegate = self
        fieldPassword.delegate = self
        
        /// Calls extension function configureTextField (see UITextField+Design.swift) to configure overall design for textFields
        fieldName.configureTextField()
        fieldEmail.configureTextField()
        fieldPassword.configureTextField()
        
        /// Embeds icons into the textFields for better user readability
        fieldName.tintColor = .gray
        fieldEmail.tintColor = .gray
        fieldPassword.tintColor = .gray
        fieldName.setIcon(#imageLiteral(resourceName: "Name"))
        fieldEmail.setIcon(#imageLiteral(resourceName: "User"))
        fieldPassword.setIcon(#imageLiteral(resourceName: "Password"))
        
        /// Calls extension function configureButton (see UIButton+Design.swift) to configure overall design for buttonContinue
        buttonSignUp.configureButton()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /// Configures Hero transitions for segues signedIn and signedOut
        if segue.identifier == "signedUp" {
            let destination = segue.destination
            destination.hero.modalAnimationType = .zoomOut
        }
        
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
        if textField == fieldName {
            fieldName.resignFirstResponder()
            fieldEmail.becomeFirstResponder()
        } else if textField == fieldEmail {
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
    
    /// Creates a UIAlertController with a customised message for the user
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: NSLocalizedString(title, comment: message), message: NSLocalizedString(message, comment: message), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    // MARK: - Firebase
    /// This function force-retrieves a value from the textFields and uses it to create a user account using Firebase
    /// If errors are found, the execution stop with an alert showing the user an error; they can try to perform a solution
    /// If otherwise, the completeted function calls forth the next function, createDatabase()
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
    
    /// This function creates a pre-set and pre-valued database into the Firestore server
    /// If errors are found, the execution stops with an alert showing the user an error (even though most errors are usually programmatically or on the console-side)
    /// If otherwise, the completed function calls forth the next function, updateName()
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
        databaseFormat(subject: science)
        databaseFormat(subject: motherTongue)
        databaseFormat(subject: integratedHumanities)
        databaseFormat(subject: appliedSubject)
        
        print("upgradeconsoleDATABASE: Database creation successfully completed.")
        updateName()
        
    }
    
    /// Provides a structured function for better organisation and readability of code
    func databaseFormat(subject: [String: Any]) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("upgradeconsoleAUTHERROR: No user or uid found: is the user authenticated?")
            createAlert(title: "Something went wrong.", message: "A user error occured. Please contact discipuli for assistance.")
            return
        }
        
        reference = Firestore.firestore().document("users/\(userID)/subjects/\(subject["name"]!))")
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
    
    /// This function sets the user display name based on what is given by the user
    /// If errors are found, the execution stops with an alert showing the user an error (even though most errors are usually programmatically or on the console-side)
    /// If otherwise, the completed function performs the segue to InitialViewController
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
