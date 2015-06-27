import Foundation

extension NSDate
{
    var second:Int{
        return getComponents().second
    }
    
    var minute:Int{
        return getComponents().minute
    }
    
    var hour:Int{
        return getComponents().hour
    }
    
    var day:Int{
        return getComponents().day
    }
    
    var month:Int{
        return getComponents().month
    }
    
    var year:Int{
        return getComponents().year
    }
    
    private func getComponents()->NSDateComponents{
        let flags: NSCalendarUnit = .CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond
        let calendar = NSCalendar.currentCalendar()
        return calendar.components(flags, fromDate: self)
    }
}