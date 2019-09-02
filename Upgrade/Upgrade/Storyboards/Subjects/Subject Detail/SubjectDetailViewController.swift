import UIKit
import Charts
import Firebase
import Hero

class SubjectDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var viewMain: UIView!
    @IBOutlet var viewOverall: UIView!
    @IBOutlet var labelOverall: UILabel!
    @IBOutlet var chartLine: LineChartView!
    @IBOutlet var buttonGetFeedback: UIButton!
    
    // MARK: - Properties
    var subject = String()
    var scores = [Double]()
    var percentages = [Double]()
    var overall = Double()
    
    let xAxisTitles = ["CA1", "SA1", "CA2", "SA2", "PT1", "PT2"]
    
    var reference: DocumentReference!

    // MARK: - Overrides
    /// Overrides preferred status bar style (color) from black (default) to white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Prints out to command line for better debugging purposes.
        print("upgradeconsoleREDIRECT: Redirection to SubjectDetailViewController executed.")
        
        /// Calls extension function configureView() (see UIView+Design.swift) to configure background gradient color for SubjectDetailViewController.
        self.view.configureView(color1: "UP Purple", color2: "UP Blue")
        
        /// Configures viewMain to have a cornerRadius of 20; some corners are then masked to retain the original rectangle shape.
        viewMain.layer.cornerRadius = 20
        viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewOverall.layer.cornerRadius = 20
        
        buttonGetFeedback.configureButton(color1: "UP Purple", color2: "UP Blue")
        
        /// Attemps to retrieve all the scores from the user's account.
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if subject == "Integrated Humanities" || subject == "Language Arts" || subject == "Mathematics" || subject == "Science" {
            reference = Firestore.firestore().document("users/\(uid)/subjects/\(subject)")
            
            reference.getDocument { (docSnapshot, error) in
                if let docSnapshot = docSnapshot, docSnapshot.exists {
                    let data = docSnapshot.data()!
                    
                    let ca1Score = data["CA1Score"] as! Double
                    self.scores.append(ca1Score)
                    let sa1Score = data["SA1Score"] as! Double
                    self.scores.append(sa1Score)
                    let ca2Score = data["CA2Score"] as! Double
                    self.scores.append(ca2Score)
                    let sa2Score = data["SA2Score"] as! Double
                    self.scores.append(sa2Score)
                    
                    let pt1Score = data["PT1Score"] as! Double
                    self.scores.append(pt1Score)
                    let pt2Score = data["PT2Score"] as! Double
                    self.scores.append(pt2Score)
                    
                    let ca1 = data["CA1"] as! Double
                    self.percentages.append(ca1)
                    let sa1 = data["SA1"] as! Double
                    self.percentages.append(sa1)
                    let ca2 = data["CA2"] as! Double
                    self.percentages.append(ca2)
                    let sa2 = data["SA2"] as! Double
                    self.percentages.append(sa2)
                    
                    let pt1 = data["PT1"] as! Double
                    self.percentages.append(pt1)
                    let pt2 = data["PT2"] as! Double
                    self.percentages.append(pt2)
                    
                    if self.scores.contains(0.0) {
                        self.updateGraph()
                    } else {
                        self.updateGraph()
                        self.updateOverall()
                    }
                }
            }
        } else {
            reference = Firestore.firestore().document("users/\(uid)/subjects/Mother Tongue")
            
            reference.getDocument { (docSnapshot, error) in
                if let docSnapshot = docSnapshot, docSnapshot.exists {
                    let data = docSnapshot.data()!
                    
                    let ca1Score = data["CA1Score"] as! Double
                    self.scores.append(ca1Score)
                    let sa1Score = data["SA1Score"] as! Double
                    self.scores.append(sa1Score)
                    let ca2Score = data["CA2Score"] as! Double
                    self.scores.append(ca2Score)
                    let sa2Score = data["SA2Score"] as! Double
                    self.scores.append(sa2Score)
                    
                    let pt1Score = data["PT1Score"] as! Double
                    self.scores.append(pt1Score)
                    let pt2Score = data["PT2Score"] as! Double
                    self.scores.append(pt2Score)
                    
                    let ca1 = data["CA1"] as! Double
                    self.percentages.append(ca1)
                    let sa1 = data["SA1"] as! Double
                    self.percentages.append(sa1)
                    let ca2 = data["CA2"] as! Double
                    self.percentages.append(ca2)
                    let sa2 = data["SA2"] as! Double
                    self.percentages.append(sa2)
                    
                    let pt1 = data["PT1"] as! Double
                    self.percentages.append(pt1)
                    let pt2 = data["PT2"] as! Double
                    self.percentages.append(pt2)
                    
                    if self.scores.contains(0.0) {
                        self.updateGraph()
                    } else {
                        self.updateGraph()
                        self.updateOverall()
                    }
                }
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add" {
            let destination = segue.destination as! AddViewController
            destination.subject = subject
        } else if segue.identifier == "detail" {
            let destination = segue.destination as! DetailViewController
            destination.subject = subject
            destination.hero.modalAnimationType = .selectBy(presenting: .cover(direction: .left), dismissing: .uncover(direction: .right))
        }
    }
    
    // MARK: - Functions
    func updateGraph() {
        var lineGraphEntry = [ChartDataEntry]()
        
        // Retrieves individual values from the array using a for loop to be represented on the graph.
        for i in 0 ..< scores.count {
            let value = ChartDataEntry(x: Double(i), y: scores[i])
            
            lineGraphEntry.append(value)
        }
        
        let line = LineChartDataSet(entries: lineGraphEntry, label: "Scores")
        let gradientColors = [UIColor(named: "UP Purple")!.cgColor, UIColor(named: "UP Blue")!.cgColor] as CFArray
        let gradientLocation: [CGFloat] = [0.0, 1.0]
        let lineGradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: gradientLocation)
        line.colors = [NSUIColor.blue]
        line.fill = Fill.fillWithLinearGradient(lineGradient!, angle: 90.0)
        line.drawFilledEnabled = true
        line.mode = .horizontalBezier
        line.drawCirclesEnabled = false
        line.drawValuesEnabled = false
        
        let data = LineChartData()
        data.addDataSet(line)
        
        chartLine.data = data
        chartLine.chartDescription?.text = "Overall percentage"
        chartLine.chartAnimator.animate(xAxisDuration: 0.5, yAxisDuration: 0.25)
        
        chartLine.leftAxis.drawGridLinesEnabled = false
        chartLine.leftAxis.labelFont = UIFont(name: "Metropolis", size: 9.0)!
        chartLine.leftAxis.gridColor = .clear
        chartLine.xAxis.gridColor = .clear
        
        chartLine.rightAxis.drawGridLinesEnabled = false
        chartLine.rightAxis.labelFont = UIFont(name: "Metropolis", size: 9.0)!
        chartLine.rightAxis.gridColor = .clear
        
        chartLine.gridBackgroundColor = UIColor(red: 249, green: 249, blue: 249, alpha: 1)
        chartLine.legend.enabled = false
        chartLine.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisTitles)
        chartLine.xAxis.granularity = 1
        
    }
    
    func updateOverall() {
        /// Finds the average percentage scored.
        let total = scores.reduce(0, +)
        let overall = total / 6.0

        if overall < 40.0 {
            labelOverall.text = "F9"
        } else if overall >= 40.0 && overall < 45.0 {
            labelOverall.text = "E8"
        } else if overall >= 45.0 && overall < 50.0 {
            labelOverall.text = "D7"
        } else if overall >= 50.0 && overall < 55.0 {
            labelOverall.text = "C6"
        } else if overall >= 55.0 && overall < 60.0 {
            labelOverall.text = "C5"
        } else if overall >= 60.0 && overall < 65.0 {
            labelOverall.text = "B4"
        } else if overall >= 65.0 && overall < 70.0 {
            labelOverall.text = "B3"
        } else if overall >= 70.0 && overall < 75.0 {
            labelOverall.text = "A2"
        } else if overall >= 75.0 {
            labelOverall.text = "A1"
        } else {
            labelOverall.text = "Z0"
        }
        
    }
    
    // MARK: - Actions
    @IBAction func buttonBack(_ sender: UIButton) {
        self.hero.dismissViewController()
    }
    
    @IBAction func tapReload(_ sender: UITapGestureRecognizer) {
        chartLine.reloadInputViews()
    }
    
    @IBAction func buttonDetails(_ sender: UIButton) {
        if scores == [0.0, 0.0, 0.0, 0.0, 0.0, 0.0] {
            let warningError = UIAlertController(title: "Not enough info", message: "There is not enough information to suggest. Please add some scores above and try again.", preferredStyle: .alert)
            warningError.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            }))
            present(warningError, animated: true)
        } else {
            performSegue(withIdentifier: "detail", sender: nil)
        }
    }
    
}
