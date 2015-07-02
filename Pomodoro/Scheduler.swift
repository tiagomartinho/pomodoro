import UIKit

class Scheduler {
    private let neededUIUserNotifications:UIUserNotificationType = UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge
    
    func schedulePomodoriAndPauses(){
        registerToSendTheUserNotifications()
        
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
    
    func cancelAllPomodoriAndPauses(){
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    private func scheduleNotificationWithAlertBody(alertBody:String,AndFireDate fireDate:NSDate){
        var notification:UILocalNotification = UILocalNotification()
        notification.alertBody = alertBody
        notification.fireDate = fireDate
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    private func registerToSendTheUserNotifications(){
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: neededUIUserNotifications, categories: nil))
    }
}