import UIKit

class ZoneIdToColorTransformer {
    static func transformToColor(zoneId: Int) -> UIColor {
        
        
        let redComponent:CGFloat = CGFloat(zoneId % 15)/15.0
        let greenComponent:CGFloat = CGFloat(zoneId % 7)/7.0
        let blueComponent:CGFloat = CGFloat(zoneId % 8)/8.0
        
        return UIColor(red: redComponent, green: greenComponent, blue: blueComponent, alpha: 1.0)
    }
}
