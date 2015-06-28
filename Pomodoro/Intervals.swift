import Foundation

struct Intervals{

    static let pomodoro = Interval(type:.Pomodoro,duration: 25,message:"WORK")
    static let pause = Interval(type:.Pause,duration: 5,message:"PAUSE")
    static let longPause = Interval(type:.LongPause,duration: 15,message:"LONG PAUSE")
    
    let intervals:[Interval] = [pomodoro,pause,pomodoro,pause,pomodoro,pause,pomodoro,longPause]
    
    var cumulativeDurationsInSeconds:[Int]{
        var cumulativeDuration = 0
        var durations = [Int]()
        for interval in intervals {
            durations.append(cumulativeDuration + interval.durationInSeconds)
            cumulativeDuration += interval.durationInSeconds
        }
        return durations
    }
    
    func intervalType(timeInterval:NSTimeInterval)->IntervalType{
        var i = 0
        for duration in cumulativeDurationsInSeconds {
            if timeInterval < Double(duration) {
                return intervals[i].type
            }
            i++
        }
        return .Pomodoro
    }
}

struct Interval {
    let type:IntervalType
    let duration:Int
    var durationInSeconds:Int{
        return duration*60
    }
    let message:String
}

enum IntervalType{
    case Pomodoro,Pause,LongPause
}