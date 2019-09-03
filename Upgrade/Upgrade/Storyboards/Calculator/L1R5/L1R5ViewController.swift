import UIKit
import Hero

class L1R5ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet var viewMain: UIView!
    @IBOutlet var viewGrade: UIView!
    @IBOutlet var fieldLanguage: UITextField!
    @IBOutlet var fieldR1: UITextField!
    @IBOutlet var fieldR2: UITextField!
    @IBOutlet var fieldR3: UITextField!
    @IBOutlet var fieldR4: UITextField!
    @IBOutlet var fieldR5: UITextField!
    @IBOutlet var labelOutput: UILabel!
    @IBOutlet var buttonToggle: UIButton!
    
    // MARK: - Properties
    var currentTextField = UITextField()
    var totalGrade = Int()
    var calculated = false
    
    // MARK: - Overrides
    /// Overrides preferred status bar style (color) from black (default) to white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /// Prints out to command line for better debugging purposes.
        print("upgradeconsoleREDIRECT: Redirection to SignInViewController executed.")
        
        /// Calls extension function configureView() (see UIView+Design.swift) to configure the background gradient color for GradeViewController.
        self.view.configureView(color1: "UP Purple", color2: "UP Blue")
        
        /// Configures viewMain to have a cornerRadius of 20; some corners are then masked to retain the original rectangle shape.
        viewMain.layer.cornerRadius = 20
        viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        /// Assigns the delegates to the textFields to manage keyboard first responders.
        fieldLanguage.delegate = self
        fieldR1.delegate = self
        fieldR2.delegate = self
        fieldR3.delegate = self
        fieldR4.delegate = self
        fieldR5.delegate = self
        
        /// Calls extension function configureTextField() (see UITextField+Design.swift) to configure the overall design for the textFields.
        fieldLanguage.configureTextField()
        fieldR1.configureTextField()
        fieldR2.configureTextField()
        fieldR3.configureTextField()
        fieldR4.configureTextField()
        fieldR5.configureTextField()
        
        /// Calls extension function configureButton() (see UIButton+Design.swift) to configure the overall design for buttonToggle.
        buttonToggle.configureButton(color1: "UP Purple", color2: "UP Blue")
        
        /// Calls extension function viewShadow() (see UIView+Design.swift) to place a shadow on viewGrade.
        viewGrade.viewShadow()
        viewGrade.layer.cornerRadius = 10
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        if segue.identifier == "menu" {
            destination.hero.modalAnimationType = .selectBy(presenting: .cover(direction: .right), dismissing: .uncover(direction: .left))
        } else if segue.identifier == "help" {
            destination.hero.modalAnimationType = .selectBy(presenting: .cover(direction: .left), dismissing: .uncover(direction: .right))
        }
    }
    
    // MARK: - Functions
    func checkGrades(grades: [Int]) {
        for grade in 0...grades.count - 1 {
            totalGrade += grades[grade]
        }
        
        if totalGrade >= 54 {
            let gradeAlert = UIAlertController(title: "Huh?", message: "Your subject score cannot exceed 9.", preferredStyle: .alert)
            gradeAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                self.fieldLanguage.text = ""
                self.fieldR1.text = ""
                self.fieldR2.text = ""
                self.fieldR3.text = ""
                self.fieldR4.text = ""
                self.fieldR5.text = ""
                self.labelOutput.text = "00"
                self.totalGrade = 0
            }))
            present(gradeAlert, animated: true)
            self.labelOutput.text = "??"
        } else {
            labelOutput.text = "\(totalGrade)"
        }
    }
    
    // This function is a protocol for UITextFieldDelegate; it is executed when the textField is being interacted with and highlighted.
    /// Retrieves the current, highlighted textField (that is being interacted with) and brings it to the front in viewCredentials.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
        viewMain.bringSubviewToFront(currentTextField)
    }
    
    // This function is a protocol for UITextFieldDelegate; it is executed when the return key of the keyboard is pressed.
    /// Evaluates the current active text field.
    /* If the current textField is fieldEmail, the keyboard will be resigned and the focus is switched over to fieldPassword.
     Else, if the current textField is fieldPassword, the keyboard will be resigned.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case fieldLanguage:
            fieldLanguage.resignFirstResponder()
            fieldR1.becomeFirstResponder()
        case fieldR1:
            fieldR1.resignFirstResponder()
            fieldR2.becomeFirstResponder()
        case fieldR2:
            fieldR2.resignFirstResponder()
            fieldR3.becomeFirstResponder()
        case fieldR3:
            fieldR3.resignFirstResponder()
            fieldR4.becomeFirstResponder()
        case fieldR4:
            fieldR4.resignFirstResponder()
            fieldR5.becomeFirstResponder()
        default:
            fieldR5.resignFirstResponder()
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
    
    // MARK: - Actions
    @IBAction func tapDismiss(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        
        guard let language = fieldLanguage.text else { return }
        guard let r1 = fieldR1.text else { return }
        guard let r2 = fieldR2.text else { return }
        guard let r3 = fieldR3.text else { return }
        guard let r4 = fieldR4.text else { return }
        guard let r5 = fieldR5.text else { return }
        
        if language != "" && r1 != "" && r2 != "" && r3 != "" && r4 != "" && r5 != "" && calculated == false {
            checkGrades(grades: [Int(language) ?? 0, Int(r1) ?? 0, Int(r2) ?? 0, Int(r3) ?? 0, Int(r4) ?? 0, Int(r5) ?? 0])
            calculated = true
        }
        
    }
    
    @IBAction func buttonToggle(_ sender: UIButton) {
        let toggle = UIAlertController(title: "Calculator", message: "Choose one of the types below.", preferredStyle: .actionSheet)
        toggle.addAction(UIAlertAction(title: "Grade Checker", style: .default, handler: { (_) in
            self.performSegue(withIdentifier: "grade", sender: nil)
        }))
        toggle.addAction(UIAlertAction(title: "ELR2B2", style: .default, handler: { (_) in
            self.performSegue(withIdentifier: "elr2b2", sender: nil)
        }))
        toggle.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            toggle.dismiss(animated: true, completion: nil)
        }))
        present(toggle, animated: true)
    }
    
}
