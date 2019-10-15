
import UIKit

class MallakButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        layer.cornerRadius = 10
        clipsToBounds = true
        setTitleColor(.black, for: .normal)
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
     }
    
}


class MallakButton2: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        layer.cornerRadius = 10
        clipsToBounds = true
        setTitleColor(.white, for: .normal)
        layer.borderWidth = 1
        layer.backgroundColor = #colorLiteral(red: 0.09482503164, green: 0.1120610535, blue: 0.3486851641, alpha: 1)
    }
    
}
