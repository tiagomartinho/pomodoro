import Foundation

class Intervals{
    
    static let pomodoro = Interval(type:.Pomodoro,duration: 25,message:"WORK",cumulativeDuration:0)
    static let pause = Interval(type:.Pause,duration: 5,message:"PAUSE",cumulativeDuration:0)
    static let longPause = Interval(type:.LongPause,duration: 15,message:"LONG PAUSE",cumulativeDuration:0)
    
    let reference = [pomodoro,pause,pomodoro,pause,pomodoro,pause,pomodoro,longPause]
    private var intervals=[Interval]()
    
    init(){
        var cumulativeDuration = 0
        for interval in reference {
            var intervalWithCumulativeDuration = interval
            intervalWithCumulativeDuration.cumulativeDuration = cumulativeDuration + interval.durationInSeconds
            intervals.append(intervalWithCumulativeDuration)
            cumulativeDuration += interval.durationInSeconds
        }
    }
    
    func intervalType(timeInterval:NSTimeInterval)->IntervalType{
        if let interval = intervalAtTimeInterval(timeInterval){
            return interval.type
        }
        else {
            return .Pomodoro
        }
    }
    
    func intervalDurationInSeconds(timeInterval:NSTimeInterval)->Int{
        if let interval = intervalAtTimeInterval(timeInterval){
            return interval.durationInSeconds
        }
        else {
            return 25
        }
    }
    
    private func intervalAtTimeInterval(timeInterval:NSTimeInterval)->Interval?{
        var i = 0
        for interval in intervals {
            if timeInterval < Double(interval.cumulativeDuration) {
                return intervals[i]
            }
            i++
        }
        return nil
    }
    
    struct Interval {
        let type:IntervalType
        let duration:Int
        var durationInSeconds:Int{
            return duration*60
        }
        let message:String
        var cumulativeDuration:Int
    }
}

enum IntervalType{
    case Pomodoro,Pause,LongPause
}