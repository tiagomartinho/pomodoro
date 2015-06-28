import Foundation

struct Intervals{

    static let pomodoro = Interval(type:.Pomodoro,duration: 25)
    static let pause = Interval(type:.Pause,duration: 5)
    static let longPause = Interval(type:.LongPause,duration: 15)
    
    static let intervals:[Interval] = [pomodoro,pause,pomodoro,pause,pomodoro,pause,pomodoro,longPause] 
}

struct Interval {
    let type:IntervalType
    let duration:Int
    var durationInSeconds:Int{
        return duration*60
    }
}

enum IntervalType{
    case Pomodoro,Pause,LongPause
}