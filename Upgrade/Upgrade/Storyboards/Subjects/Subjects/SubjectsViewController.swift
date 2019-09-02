import UIKit
import Hero
import Firebase

class SubjectsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet var viewMain: UIView!
    @IBOutlet var viewLoading: UIView!
    @IBOutlet var tableSubjects: UITableView!
    
    // MARK: - Properties
    var reference: DocumentReference!
    var collectionReference: CollectionReference!
    var subjects = [String]()
    var subject = String()
    
    // MARK: - Overrides
    /// Overrides preferred status bar style (color) from black (default) to white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Prints out to command line for better debugging purposes.
        print("upgradeconsoleREDIRECT: Redirection to SubjectsViewController executed.")
        
        /// Assigns tableSubjects delegate and dataSource to manage table.
        tableSubjects.delegate = self
        tableSubjects.dataSource = self
        
        /// Calls extension function configureView() (see UIView+Design.swift) to configure background gradient color for SettingsViewController.
        self.view.configureView(color1: "UP Purple", color2: "UP Blue")
        
        /// Configures Views to have a cornerRadius of 20; some corners are then masked to retain the original rectangle shape.
        viewMain.layer.cornerRadius = 20
        viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewLoading.layer.cornerRadius = 20
        viewLoading.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableSubjects.layer.cornerRadius = 20
        tableSubjects.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Retrieves all subjects.
        /// Adds a fallback feature when the user account is not set up.
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        reference = Firestore.firestore().document("users/\(uid)")
        reference.getDocument { (docSnapshot, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            } else {
                let data = docSnapshot?.data()
                let level = data!["level"] as! Int
                
                if level == 0 {
                    self.viewLoading.alpha = 1
                    
                    let criticalAlert = UIAlertController(title: "Critical alert", message: "Your account has not been set up. Please proceed to set up your account now.", preferredStyle: .alert)
                    criticalAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        self.performSegue(withIdentifier: "setup", sender: nil)
                    }))
                    self.present(criticalAlert, animated: true)
                    
                } else {
                    self.collectionReference = Firestore.firestore().collection("users/\(uid)/subjects")
                    self.collectionReference.getDocuments { (docSnapshot, error) in
                        if let error = error {
                            fatalError("\(error.localizedDescription)")
                        } else {
                            for document in docSnapshot!.documents {
                                let data = document.data()
                                self.subjects.append(data["name"] as! String)
                                self.tableSubjects.reloadData()
                                
                                UIView.animate(withDuration: 0.25, animations: {
                                    self.viewLoading.alpha = 0
                                })
                                
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "menu" {
            let destination = segue.destination
            destination.hero.modalAnimationType = .selectBy(presenting: .cover(direction: .right), dismissing: .uncover(direction: .left))
        } else if segue.identifier == "detail" {
            let destination = segue.destination as! SubjectDetailViewController
            destination.hero.modalAnimationType = .selectBy(presenting: .cover(direction: .left), dismissing: .uncover(direction: .right))
            destination.subject = subject
        }
        
    }
    
    // MARK: - Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subject", for: indexPath)
        
        cell.layer.borderWidth = 0.1
        cell.layer.cornerRadius = 10
        cell.viewShadow()
        
        cell.textLabel?.text = subjects[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        subject = subjects[indexPath.row]
        performSegue(withIdentifier: "detail", sender: nil)
        
    }
    
}
