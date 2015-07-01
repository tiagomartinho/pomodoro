import Foundation

class Tracker{
    
    var isRunning:Bool{
        return defaults.objectForKey(kUD_isTimerRunning) as? Bool ?? false
    }
    
    var description:IntervalType {
        return Intervals().intervalType(self.timeInterval)
    }
    
    var time:String{
        let timeLeft = Int(self.timeLeft)
        if timeLeft >= 0 {
            return timeFormatted(timeLeft)
        }
        return "25:00"
    }
    
    var pomodoros:Int{
        if let intervalNumber = Intervals().intervalNumberAtTimeInterval(self.timeInterval) {
            return (intervalNumber+1)/2
        }
        return 0
    }
    
    private func timeFormatted(timeInSeconds:Int)->String{
        let minutesLeft = timeInSeconds/60
        let secondsLeft = timeInSeconds%60
        return String.formatTimer(minutesLeft, seconds: secondsLeft)
    }
    
    var progress:Float{
        if timeLeft >= 0 && currentIntervalDuration > 0{
            return Float(timeLeft/currentIntervalDuration)
        }
        return 1.0
    }
    
    private var timeInterval:NSTimeInterval{
        if let backgroundDate = defaults.objectForKey(kUD_StartDate) as? NSDate {
            return abs(backgroundDate.timeIntervalSinceNow)
        }
        return 0
    }
    
    private var currentIntervalDuration:Double{
        return Double(Intervals().intervalDurationInSeconds(timeInterval))
    }
    
    private var timeLeft:Double {
        let previousIntervals = Double(Intervals().cumulativeIntervalDurationInSeconds(timeInterval)) - currentIntervalDuration
        let timePassed = timeInterval-previousIntervals
        return currentIntervalDuration - timePassed
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