import UIKit

class Scheduler {    
    init(){
        registerToSendTheUserNotifications()
    }
    
    func cancelAllPomodoriAndPauses(){
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    func schedulePomodoriAndPauses(){
        var date = 0
        var i = 0
        for interval in Intervals().reference {
            date += interval.duration * 60
            if i+1 < count(Intervals().reference) {
                let nextIntervalMessage = Intervals().reference[i+1].message
                scheduleNotificationWithAlertBody(nextIntervalMessage,AndFireDate: NSDate(timeIntervalSinceNow: NSTimeInterval(date)))
            }
            i++
        }
    }
    
    private func scheduleNotificationWithAlertBody(alertBody:String,AndFireDate fireDate:NSDate){
        var notification:UILocalNotification = UILocalNotification()
        notification.alertBody = alertBody
        notification.fireDate = fireDate
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    let needUIUserNotificationType:UIUserNotificationType = UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge
    private func registerToSendTheUserNotifications(){
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: needUIUserNotificationType, categories: nil))
    }
}