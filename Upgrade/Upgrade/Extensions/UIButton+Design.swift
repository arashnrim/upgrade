import UIKit

extension UIButton {
    
    /// Configures UIButton to
    /// a. add a gradient layer with a preset gradient.
    /// b. set the cornerRadius to 10, to have a rectangle with rounded corners.
    /// c. add a shadow.
    func configureButton(color1: String, color2: String) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.cornerRadius = 10
        gradient.colors = [UIColor(named: color1)!.cgColor, UIColor(named: color2)!.cgColor]
        gradient.locations = [0, 0.75, 1]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
        
        self.layer.cornerRadius = 10
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 50
        self.layer.shadowOpacity = 0.2
        
    }
    
}
