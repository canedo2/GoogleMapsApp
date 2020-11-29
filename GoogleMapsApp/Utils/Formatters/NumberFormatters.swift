import Foundation
class Formatters {
    static let latLongFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 6
        formatter.decimalSeparator = "."
        return formatter
    }()
}
