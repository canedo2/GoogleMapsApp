import UIKit

class ZoneIdToColorTransformer {
    static func transformToColor(zoneId: Int) -> UIColor {
        
        let redComponent:CGFloat = CGFloat(zoneId % 49)/49.0
        let greenComponent:CGFloat = CGFloat(zoneId % 43)/43.0
        let blueComponent:CGFloat = CGFloat(zoneId % 37)/37.0
        
        return UIColor(red: redComponent, green: greenComponent, blue: blueComponent, alpha: 1.0)
    }
}
