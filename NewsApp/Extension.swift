import UIKit

extension NSObject {
    static var identifier: String {
        String(describing: self)
    }
}

extension UIColor {
    static var whiteRGB : UIColor {
        UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    }
    
    static var greyRGB : UIColor {
        UIColor(red: 240/255, green: 244/255, blue: 247/255, alpha: 1.0)
    }
    
    static var cellColor : [UIColor] {
        [
            greyRGB,
            whiteRGB
        ]
    }
}
