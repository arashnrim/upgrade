import UIKit

extension UITextField {
    
    /// Uses an image to set it as the icon of the textField.
    /// This improves user understanding of the textFields and provides better design for the application.
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame:
            CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
        
    }
    
    /// Configures UITextField to
    /// a. maintain regular bordered rectangle shape.
    /// b. add a shadow.
    func configureTextField() {
        self.borderStyle = UITextField.BorderStyle.roundedRect
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 50
        self.layer.shadowOpacity = 0.2
    }
    
}
