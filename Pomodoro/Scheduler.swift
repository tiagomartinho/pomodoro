import UIKit

struct Interval {
    var name:String
    var length:Int
}

class Scheduler {
    let pomodoro = Interval(name: "WORK", length: 25)
    let pause = Interval(name: "PAUSE", length: 5)
    let longPause = Interval(name: "LONG PAUSE", length: 15)
    
    func cancelAllPomodoriAndPauses(){
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    func schedulePomodoriAndPauses(){
        let intervals = [pomodoro,pause,pomodoro,pause,pomodoro,pause,pomodoro,longPause]
        var date = 0
        for interval in intervals {
            date += interval.length
            scheduleNotificationWithAlertBody(interval.name,AndFireDate: NSDate(timeIntervalSinceNow: NSTimeInterval(date)))
        }
    }
    
    private func scheduleNotificationWithAlertBody(alertBody:String,AndFireDate fireDate:NSDate){
        var notification:UILocalNotification = UILocalNotification()
        notification.alertBody = alertBody
        notification.userInfo = ["userInfoKey":"userInfoValue"]
        notification.fireDate = fireDate
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
}