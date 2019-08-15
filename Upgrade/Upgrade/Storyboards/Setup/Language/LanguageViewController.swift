import UIKit
import Firebase

class LanguageViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet var pickerLanguage: UIPickerView!
    @IBOutlet var fieldLanguage: UITextField!
    @IBOutlet var buttonContinue: UIButton!
    @IBOutlet var viewLoading: UIView!
    
    // MARK: - Properties
    let data = ["Language Arts + Chinese", "Language Arts + Malay", "Language Arts + Hindi", "Language Arts + Others"]
    var language2 = String()
    var reference: DocumentReference!
    
    // MARK: - Overrides
    /// Overrides preferred status bar style (color) from black (default) to white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Prints out to command line for better debugging purposes.
        print("upgradeconsoleREDIRECT: Redirection to SignInViewController executed.")// Do any additional setup after loading the view.
        
        /// Assigns the delegates to pickerLevel to manage data.
        pickerLanguage.delegate = self
        
        /// Assigns the delegates to the textFields to manage keyboard first responders.
        fieldLanguage.delegate = self
        
        /// Calls extension function configureTextField() (see UITextField+Design.swift) to configure the overall design for the textFields.
        fieldLanguage.configureTextField()
        fieldLanguage.layer.shadowOpacity = 0.1
        
        /// Embeds icons into the textFields for better user readability (see UITextField+Design.swift).
        fieldLanguage.tintColor = .gray
        fieldLanguage.setIcon(#imageLiteral(resourceName: "User"))
        
        /// Sets the dataSource for pickerLevel to LevelViewController.
        pickerLanguage.dataSource = self
        
        /// Calls extension function configureButton() (see UIButton+Design.swift) to configure the overall design for buttonContinue.
        buttonContinue.configureButton(color1: "UP Purple", color2: "UP Blue")
        
        fieldLanguage.alpha = 0
        viewLoading.alpha = 0
        
    }
    
    // MARK: - Functions
    func updateSubjects() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        reference = Firestore.firestore().document("users/\(uid)/subjects/Mother Tongue")
        reference.updateData(["name": language2])
    }
    
    
    // MARK: - Picker View Overrides
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            UIView.animate(withDuration: 0.5) {
                self.fieldLanguage.alpha = 0
            }
            language2 = "Chinese"
        case 1:
            UIView.animate(withDuration: 0.5) {
                self.fieldLanguage.alpha = 0
            }
            language2 = "Malay"
        case 2:
            UIView.animate(withDuration: 0.5) {
                self.fieldLanguage.alpha = 0
            }
            language2 = "Hindi"
        case 3:
            UIView.animate(withDuration: 0.5) {
                self.fieldLanguage.alpha = 1
            }
            if let language = fieldLanguage.text {
                language2 = language
            }
        default:
            fatalError("Something went wrong.")
        }
    }
    
    // MARK: - Actions
    @IBAction func buttonContinue(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.viewLoading.alpha = 1
        }
        
        if language2 == "" {
            let languageAlert = UIAlertController(title: "No language is added.", message: "If you have no second language, you can choose to skip this choice here.", preferredStyle: .alert)
            languageAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            }))
            languageAlert.addAction(UIAlertAction(title: "Skip", style: .destructive, handler: { (_) in
                self.language2 = "Mother Tongue"
                self.updateSubjects()
            }))
        } else {
            updateSubjects()
        }
        
        self.performSegue(withIdentifier: "finish", sender: nil)
        
    }
    
}
