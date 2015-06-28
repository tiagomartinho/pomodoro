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
    
    var cumulativeDurationsInSeconds:[NSTimeInterval]{
        var cumulativeDuration = 0
        var durations = [NSTimeInterval]()
        for interval in Intervals.intervals {
            durations.append(NSTimeInterval(cumulativeDuration + interval.durationInSeconds))
            cumulativeDuration += interval.durationInSeconds
        }
        return durations
    }
    
    var isRunning:Bool{
        return defaults.objectForKey(kUD_isTimerRunning) as? Bool ?? false
    }
    
    var time:String{
        if isRunning {
            if description == .Pause {
                return "5:00"
            }
            return "24:59"
        }
        else{
            return "25:00"
        }
    }
    
    var description:IntervalType {
        if(timeInterval>25*60){
            return .Pause
        }
        
        if(timeInterval>25*60*2){
            return .LongPause
        }
        
        return .Pomodoro
    }
    
    var progress:Double{
        if isRunning {
            if description == .Pause {
                return 100
            }
            return 99.93
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