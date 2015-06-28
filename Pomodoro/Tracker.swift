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
    
    var description:IntervalType {
        return Intervals().intervalType(timeInterval)
    }
    
    var time:String{
        let intervalDurationInSeconds = Double(Intervals().intervalDurationInSeconds(timeInterval))
        let timeLeft = Int(intervalDurationInSeconds - timeInterval)
        let minutesLeft = timeLeft/60
        let secondsLeft = timeLeft%60
        return String.formatTimer(minutesLeft, seconds: secondsLeft)
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