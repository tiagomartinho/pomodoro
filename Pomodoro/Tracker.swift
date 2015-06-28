import Foundation

class Tracker{

    private var timeInterval:NSTimeInterval{
        if let backgroundDate = defaults.objectForKey(kUD_StartDate) as? NSDate {
            return abs(backgroundDate.timeIntervalSinceNow)
        }
        else{
            return 0
        }
    }
    
    var isRunning:Bool{
        return defaults.objectForKey(kUD_isTimerRunning) as? Bool ?? false
    }
    
    var time:String{
        if isRunning {
            switch description {
            case .Pause:
                return "5:00"
            case .LongPause:
                return "15:00"
            case .Pomodoro:
                return "24:59"
            }
        }
        else{
            return "25:00"
        }
    }
    
    var description:IntervalType {
        return Intervals().intervalType(timeInterval)
    }
    
    var progress:Double{
        if isRunning {
            switch description {
            case .Pause:
                return 100
            case .LongPause:
                return 100
            case .Pomodoro:
                return 99.93
            }
        }
        else{
            return 100
        }
    }
    
    func start(){
        start(NSDate())
    }
    
    func start(date:NSDate){
        defaults.setObject(true, forKey:kUD_isTimerRunning)
        defaults.setObject(date, forKey:kUD_StartDate)
    }
    
    func stop(){
        defaults.setObject(false, forKey:kUD_isTimerRunning)
        defaults.setObject(nil, forKey:kUD_StartDate)
    }
}