import UIKit
import Firebase
import Charts

class DetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var viewMain: UIView!
    @IBOutlet var viewDisplay: UIView!
    @IBOutlet var viewSummary: UIView!
    @IBOutlet var viewScroll: UIScrollView!
    
    @IBOutlet var labelGreeting1: UILabel!
    @IBOutlet var labelGreeting2: UILabel!
    
    @IBOutlet var labelGoal: UILabel!
    @IBOutlet var chartLine: LineChartView!
    
    // MARK: - Properties
    var subject = String()
    var scores = [Double]()
    var retrievedScores = [Double]()
    var retrievedCount = [Double]()
    
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
        print("upgradeconsoleREDIRECT: Redirection to DetailViewController executed.")
        
        /// Calls extension function configureView() (see UIView+Design.swift) to configure background gradient color for DetailViewController.
        self.view.configureView(color1: "UP Purple", color2: "UP Blue")
        
        /// Configures viewMain to have a cornerRadius of 20; some corners are then masked to retain the original rectangle shape.
        viewMain.layer.cornerRadius = 20
        viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewDisplay.layer.cornerRadius = 20
        viewDisplay.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewSummary.layer.cornerRadius = 20
        viewScroll.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewScroll.layer.cornerRadius = 20
        
        /// Attemps to retrieve all the scores from the user's account.
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if subject == "Integrated Humanities" || subject == "Language Arts" || subject == "Mathematics" || subject == "Science" {
            reference = Firestore.firestore().document("users/\(uid)/subjects/\(subject)")
            
            reference.getDocument { (docSnapshot, error) in
                if let docSnapshot = docSnapshot, docSnapshot.exists {
                    let data = docSnapshot.data()!
                    
                    let ca1Score = data["CA1Score"] as! Double
                    self.scores.append(ca1Score)
                    
                    if ca1Score != 0.0 {
                        self.retrievedScores.append(ca1Score)
                        self.retrievedCount.append(1.0)
                    }
                    
                    let sa1Score = data["SA1Score"] as! Double
                    self.scores.append(sa1Score)
                    
                    if sa1Score != 0.0 {
                        self.retrievedScores.append(sa1Score)
                        self.retrievedCount.append(1.0)
                    }
                    
                    let ca2Score = data["CA2Score"] as! Double
                    self.scores.append(ca2Score)
                    
                    if ca2Score != 0.0 {
                        self.retrievedScores.append(ca2Score)
                        self.retrievedCount.append(1.0)
                    }
                    
                    let sa2Score = data["SA2Score"] as! Double
                    self.scores.append(sa2Score)

                    if sa2Score != 0.0 {
                        self.retrievedScores.append(sa2Score)
                        self.retrievedCount.append(1.0)
                    }
                    
                    let pt1Score = data["PT1Score"] as! Double
                    self.scores.append(pt1Score)

                    if pt1Score != 0.0 {
                        self.retrievedScores.append(pt1Score)
                        self.retrievedCount.append(1.0)
                    }
                    
                    let pt2Score = data["PT2Score"] as! Double
                    self.scores.append(pt2Score)

                    if pt2Score != 0.0 {
                        self.retrievedScores.append(pt2Score)
                        self.retrievedCount.append(1.0)
                    }
                    
                    self.configureMessage()
                    self.setGoals()
                }
            }
        } else {
            reference = Firestore.firestore().document("users/\(uid)/subjects/Mother Tongue")
            
            reference.getDocument { (docSnapshot, error) in
                if let docSnapshot = docSnapshot, docSnapshot.exists {
                    let data = docSnapshot.data()!
                    
                    let ca1Score = data["CA1Score"] as! Double
                    self.scores.append(ca1Score)

                    if ca1Score != 0.0 {
                        self.retrievedScores.append(ca1Score)
                        self.retrievedCount.append(1.0)
                    }
                    
                    let sa1Score = data["SA1Score"] as! Double
                    self.scores.append(sa1Score)

                    if sa1Score != 0.0 {
                        self.retrievedScores.append(sa1Score)
                        self.retrievedCount.append(1.0)
                    }
                    
                    let ca2Score = data["CA2Score"] as! Double
                    self.scores.append(ca2Score)

                    if ca2Score != 0.0 {
                        self.retrievedScores.append(ca2Score)
                        self.retrievedCount.append(1.0)
                    }
                    
                    let sa2Score = data["SA2Score"] as! Double
                    self.scores.append(sa2Score)

                    if sa2Score != 0.0 {
                        self.retrievedScores.append(sa2Score)
                        self.retrievedCount.append(1.0)
                    }
                    
                    let pt1Score = data["PT1Score"] as! Double
                    self.scores.append(pt1Score)

                    if pt1Score != 0.0 {
                        self.retrievedScores.append(pt1Score)
                        self.retrievedCount.append(1.0)
                    }
                    
                    let pt2Score = data["PT2Score"] as! Double
                    self.scores.append(pt2Score)

                    if pt2Score != 0.0 {
                        self.retrievedScores.append(pt2Score)
                        self.retrievedCount.append(1.0)
                    }
                    
                    self.configureMessage()
                    self.setGoals()
                }
            }
        }
        
    }
    
    // MARK: - Functions
    func configureMessage() {
        let totalScore = retrievedScores.reduce(0, +)
        let totalCount = retrievedCount.reduce(0, +)
        
        let average = Int(totalScore / totalCount)
        
        if average < 40 {
            self.labelGreeting1.text = "Don't worry,"
            self.labelGreeting2.text = "let's get to improving!"
        } else if average >= 40 && average < 45 {
            self.labelGreeting1.text = "Don't worry,"
            self.labelGreeting2.text = "let's get to improving!"
        } else if average >= 45 && average < 50 {
            self.labelGreeting1.text = "Don't worry,"
            self.labelGreeting2.text = "let's get to improving!"
        } else if average >= 50 && average < 55 {
            self.labelGreeting1.text = "Nice save,"
            self.labelGreeting2.text = "let's get to improving!"
        } else if average >= 55 && average < 60 {
            self.labelGreeting1.text = "Nice save,"
            self.labelGreeting2.text = "let's get to improving!"
        } else if average >= 60 && average < 65 {
            self.labelGreeting1.text = "Good job,"
            self.labelGreeting2.text = "let's get to improving!"
        } else if average >= 65 && average < 70 {
            self.labelGreeting1.text = "Great job,"
            self.labelGreeting2.text = "let's get to improving!"
        } else if average >= 70 && average < 75 {
            self.labelGreeting1.text = "Great job,"
            self.labelGreeting2.text = "you're doing well!"
        } else if average >= 75 && average <= 100 {
            self.labelGreeting1.text = "Great job,"
            self.labelGreeting2.text = "you're doing well!"
        }
        
    }
    
    func setGoals() {
        let totalScore = retrievedScores.reduce(0, +)
        let totalCount = retrievedCount.reduce(0, +)
        
        let goal = totalScore / totalCount
        labelGoal.text = "\(String(Int(goal)))%"
        
        var graphScores = [Double]()
        for i in 0 ..< retrievedScores.count {
            graphScores.append(retrievedScores[i])
        }
        graphScores.append(goal)
        
        var lineGraphEntry = [ChartDataEntry]()
        
        // Retrieves individual values from the array using a for loop to be represented on the graph.
        for i in 0 ..< graphScores.count {
            let value = ChartDataEntry(x: Double(i), y: graphScores[i])
            
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
        chartLine.chartDescription?.text = "Projection of grades"
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
    
    // MARK: - Actions
    @IBAction func buttonBack(_ sender: UIButton) {
        self.hero.dismissViewController()
    }
    
}
