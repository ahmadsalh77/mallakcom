import UIKit


class MallakcomView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clipsToBounds = true
        layer.cornerRadius = 25
        layer.maskedCorners = [.layerMaxXMaxYCorner , .layerMaxXMinYCorner , .layerMinXMaxYCorner , .layerMinXMinYCorner]
        layer.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        
//        if UIDevice.current.userInterfaceIdiom == .pad {
//
//            for constraint in superview!.constraints {
//                if constraint.identifier == "ipad" {
//                    constraint.constant = 100
//                }
//                if constraint.identifier == "logo" {
//                    constraint.constant = 150
//                }
//                if constraint.identifier == "top" {
//                    constraint.constant = 100
//                }
//
//
//            }
//
//
//            layoutIfNeeded()
//
//        }
        
        
    }
    
}
