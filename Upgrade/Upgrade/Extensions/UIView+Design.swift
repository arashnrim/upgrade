import UIKit

extension UIView {
    
    /// Configures UIViewControlller to add a gradient layer with a variable gradient.
    func configureView(color1: String, color2: String) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor(named: color1)!.cgColor, UIColor(named: color2)!.cgColor]
        gradient.locations = [0, 0.75, 1]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
        
        self.layer.cornerRadius = 10
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 50
        self.layer.shadowOpacity = 0.2
        
    }
    
    /// Configures View to have a background shadow.
    func viewShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 25
        self.layer.shadowOpacity = 0.1
    }
    
}
