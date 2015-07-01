import Foundation

extension String
{
    static func formatTimer(minutes:Int,seconds:Int)->String{
        return String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds)
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
}