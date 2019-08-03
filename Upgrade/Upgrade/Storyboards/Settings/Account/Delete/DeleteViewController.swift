import UIKit
import Firebase

class DeleteViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet var viewMain: UIView!
    @IBOutlet var labelEmail: UILabel!
    @IBOutlet var fieldVerify: UITextField!
    @IBOutlet var buttonDeleteData: UIButton!
    @IBOutlet var buttonDeleteAccount: UIButton!
    
    // MARK: - Properties
    var currentTextField = UITextField()
    var reference: DocumentReference!
    var subjects: CollectionReference!
    
    // MARK: - Overrides
    /// Overrides preferred status bar style (color) from black (default) to white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Prints out to command line for better debugging purposes.
        print("upgradeconsoleREDIRECT: Redirection to DeleteViewController executed.")
        
        /// Calls extension function configureView() (see UIView+Design.swift) to configure background gradient color for DeleteViewController.
        self.view.configureView(color1: "UP Orange", color2: "UP Red")
        
        /// Assigns the delegates to the textFields to manage keyboard first responders.
        fieldVerify.delegate = self
        
        /// Calls extension function configureTextField() (see UITextField+Design.swift) to configure the overall design for the textFields.
        fieldVerify.configureTextField()
        
        /// Embeds icons into the textFields for better user readability (see UITextField+Design.swift).
        fieldVerify.tintColor = .gray
        fieldVerify.setIcon(#imageLiteral(resourceName: "Name"))
        
        /// Calls extension function configureButton() (see UIButton+Design.swift) to configure the overall design for the Buttons.
        buttonDeleteData.configureButton(color1: "UP Orange", color2: "UP Red")
        buttonDeleteAccount.configureButton(color1: "UP Orange", color2: "UP Red")
        
        /// Configures viewMain to have a cornerRadius of 20; some corners are then masked to retain the original rectangle shape.
        viewMain.layer.cornerRadius = 20
        viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        /// Retrieves the user email and displays it for verification.
        guard let user = Auth.auth().currentUser else { return }
        
        labelEmail.text = user.email
        
    }
    
    // MARK: - Functions
    // This function is a protocol for UITextFieldDelegate; it is executed when the textField is being interacted with and highlighted.
    /// Retrieves the current, highlighted textField (that is being interacted with) and brings it to the front in viewCredentials.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
        viewMain.bringSubviewToFront(currentTextField)
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
    
    // This function is a protocol for UITextFieldDelegate; it is executed when the return key of the keyboard is pressed.
    /// Evaluates the current active text field.
    /* If the current textField is fieldVerify, the keyboard will be resigned.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        default:
            fieldVerify.resignFirstResponder()
        }
        return true
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
            fieldVerify.isEnabled = true
            buttonDeleteData.isEnabled = true
            buttonDeleteAccount.isEnabled = true
            
            buttonDeleteData.layer.shadowOpacity = 0.2
            buttonDeleteAccount.layer.shadowOpacity = 0.2
            
            buttonDeleteData.alpha = 1
            buttonDeleteAccount.alpha = 1
            
            buttonDeleteData.setTitle("Delete Data", for: .normal)
            buttonDeleteAccount.setTitle("Delete Account", for: .normal)
        } else {
            fieldVerify.isEnabled = false
            buttonDeleteData.isEnabled = false
            buttonDeleteAccount.isEnabled = false
            
            buttonDeleteData.layer.shadowOpacity = 0
            buttonDeleteAccount.layer.shadowOpacity = 0
            
            buttonDeleteData.alpha = 0.5
            buttonDeleteAccount.alpha = 0.5
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
    /// Resets back to a pre-set and pre-value database.
    /* This function creates a pre-set and pre-valued database into the Firestore server.
     If errors are found, the execution stops with an alert showing the user an error (even though most errors are usually programmatically or on the console-side).
     If no errors are found, the completed function calls the follow-up function, uodateName().
     */
    func deleteData() {
        status(enabled: false)
        print("upgradeconsoleDATABASE: Database reset started.")
        buttonDeleteData.setTitle("Clearing database...", for: .disabled)
        buttonDeleteAccount.setTitle("", for: .disabled)
        
        // PERSONALISATION: Edit or change subjects here to personalise what is stored in the database
        let languageArts: [String: Any] = ["name": "Language Arts"]
        let mathematics: [String: Any] = ["name": "Mathematics"]
        let science: [String: Any] = ["name": "Science"]
        let motherTongue: [String: Any] = ["name": "Mother Tongue"]
        let integratedHumanities: [String: Any] = ["name": "Integrated Humanities"]
        let appliedSubject: [String: Any] = ["name": "Applied Subject"]
        let data: [String: Any] = ["level": 0]
        guard let uid = Auth.auth().currentUser?.uid else {
            print("upgradeconsoleAUTHERROR: No user or uid found: is the user authenticated?")
            createAlert(title: "Something went wrong.", message: "A user error occured. Please contact discipuli for assistance.")
            return
        }
        
        reference = Firestore.firestore().document("users/\(uid)")
        reference.delete()
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
        createAlert(title: "Data clearance successful.", message: "All your data has been deleted.")
        status(enabled: true)
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
                self.fieldVerify.text = ""
            }
        }
    }
    
    /// Deletes the user account.
    func deleteAccount() {
        status(enabled: false)
        print("upgradeconsoleDATABASE: Account deletion started.")
        buttonDeleteAccount.setTitle("Deleting database...", for: .disabled)
        buttonDeleteData.setTitle("", for: .disabled)
        
        guard let user = Auth.auth().currentUser else { return }
        
        reference = Firestore.firestore().document("users/\(user.uid)")
        reference.delete { (error) in
            if let error = error {
                self.createAlert(title: "Something went wrong.", message: error.localizedDescription)
            } else {
                self.buttonDeleteAccount.setTitle("Deleting account...", for: .disabled)
                user.delete { error in
                    if error != nil {
                        self.performSegue(withIdentifier: "reauthenticate", sender: nil)
                        self.status(enabled: true)
                    } else {
                        self.performSegue(withIdentifier: "deleteAccount", sender: nil)
                    }
                }
            }
        }

    }
    
    // MARK: - Actions
    @IBAction func buttonDeleteData(_ sender: UIButton) {
        guard let email = fieldVerify.text else { return }
        guard let currentUser = Auth.auth().currentUser else { return }
        
        if email == currentUser.email {
            let alert = UIAlertController(title: NSLocalizedString("Are you sure?", comment: "Confirmation title"), message: NSLocalizedString("All data pertaining to you will be deleted and reset.", comment: "Explanation"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { (_) in
                self.deleteData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            }))
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: NSLocalizedString("Please try again.", comment: "Error title"), message: NSLocalizedString("The emails do not match.", comment: "Explanation"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
            }))
            self.present(alert, animated: true)
        }
        
    }
    
    @IBAction func buttonDeleteAccount(_ sender: UIButton) {
        guard let email = fieldVerify.text else { return }
        guard let currentUser = Auth.auth().currentUser else { return }
        
        if email == currentUser.email {
            let alert = UIAlertController(title: NSLocalizedString("Are you sure?", comment: "Confirmation title"), message: NSLocalizedString("All data pertaining to you will be deleted.", comment: "Explanation"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { (_) in
                self.deleteAccount()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            }))
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: NSLocalizedString("Please try again.", comment: "Error title"), message: NSLocalizedString("The emails do not match.", comment: "Explanation"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
            }))
            self.present(alert, animated: true)
        }
    }
    
    
}
