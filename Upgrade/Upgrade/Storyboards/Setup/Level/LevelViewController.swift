import UIKit
import Firebase

class LevelViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet var pickerLevel: UIPickerView!
    @IBOutlet var buttonContinue: UIButton!
    @IBOutlet var viewLoading: UIView!
    
    // MARK: - Properties
    let data = ["Secondary 1", "Secondary 2"]
    var level = Int()
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
        print("upgradeconsoleREDIRECT: Redirection to SignInViewController executed.")// Do any additional setup after loading the view.
        
        /// Assigns the delegates to pickerLevel to manage data.
        pickerLevel.delegate = self
        
        /// Sets the dataSource for pickerLevel to LevelViewController.
        pickerLevel.dataSource = self
        
        /// Calls extension function configureButton() (see UIButton+Design.swift) to configure the overall design for buttonContinue.
        buttonContinue.configureButton(color1: "UP Purple", color2: "UP Blue")
        
        viewLoading.alpha = 0
        
    }
    
    // MARK: - Functions
    func setLevel(level: Int) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let data: [String: Any] = ["level": level]
        
        reference = Firestore.firestore().document("users/\(uid)")
        reference.updateData(data)
    }
    
    func setSubjects(level: Int) {
        switch level {
        case 1:
            configureSubject(subject: "Language Arts", CA1: 10, SA1: 0, CA2: 10, SA2: 50, PT1: 30, PT2: 0)
            configureSubject(subject: "Mother Tongue", CA1: 15, SA1: 0, CA2: 15, SA2: 50, PT1: 20, PT2: 0)
            configureSubject(subject: "Science", CA1: 15, SA1: 0, CA2: 15, SA2: 50, PT1: 20, PT2: 0)
            configureSubject(subject: "Integrated Humanities", CA1: 15, SA1: 0, CA2: 15, SA2: 0, PT1: 20, PT2: 0)
            configureSubject(subject: "Mathematics", CA1: 12.5, SA1: 0, CA2: 12.5, SA2: 50, PT1: 25, PT2: 0)
            deleteSubject(subject: "Applied Subject")
        case 2:
            configureSubject(subject: "Language Arts", CA1: 10, SA1: 0, CA2: 10, SA2: 50, PT1: 30, PT2: 0)
            configureSubject(subject: "Mother Tongue", CA1: 15, SA1: 0, CA2: 15, SA2: 50, PT1: 20, PT2: 0)
            configureSubject(subject: "Science", CA1: 15, SA1: 0, CA2: 0, SA2: 50, PT1: 17.5, PT2: 17.5)
            configureSubject(subject: "Integrated Humanities", CA1: 15, SA1: 0, CA2: 15, SA2: 0, PT1: 20, PT2: 0)
            configureSubject(subject: "Mathematics", CA1: 12.5, SA1: 0, CA2: 12.5, SA2: 50, PT1: 25, PT2: 0)
            deleteSubject(subject: "Applied Subject")
        default:
            print("Something went wrong,")
        }
    }
    
    func deleteSubject(subject: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        reference = Firestore.firestore().document("users/\(uid)/subjects/\(subject)")
        reference.delete()
    }
    
    func updateSubject(subject: String, data: [String: Any]) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        reference = Firestore.firestore().document("users/\(uid)/subjects/\(subject)")
        reference.setData(data)
    }
    
    func configureSubject(subject: String, CA1: Float, SA1: Float, CA2: Float, SA2: Float, PT1: Float, PT2: Float) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let data: [String: Any] = ["CA1": CA1, "SA1": SA1, "CA2": CA2, "SA2": SA2, "PT1": PT1, "PT2": PT2, "CA1Score": Int(), "SA1Score": Int(), "CA2Score": Int(), "SA2Score": Int(), "PT1Score": Int(), "PT2Score": Int()]
        
        reference = Firestore.firestore().document("users/\(uid)/subjects/\(subject)")
        reference.updateData(data)
        
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
            level = 1
        case 1:
            level = 2
        default:
            fatalError("Something went wrong.")
        }
    }
    
    // MARK: - Actions
    @IBAction func buttonContinue(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.viewLoading.alpha = 1
        }
        
        switch level {
        case 1:
            setLevel(level: 1)
            setSubjects(level: 1)
        case 2:
            setLevel(level: 2)
            setSubjects(level: 2)
        default:
            fatalError("Something went wrong.")
        }
        
        self.performSegue(withIdentifier: "language", sender: nil)
        
    }
    
}
