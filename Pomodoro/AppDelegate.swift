import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        if let notification = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
            println("didFinishLaunchingWithOptions \(notification.userInfo)")
        }
        
        registerToSendTheUserNotifications(application)
        return true
    }
    
    let needUIUserNotificationType:UIUserNotificationType = UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge
    
    func registerToSendTheUserNotifications(application: UIApplication){
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: needUIUserNotificationType, categories: nil))
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        println("handleActionWithIdentifier \(notification.userInfo)")
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        println("didReceiveLocalNotification \(notification.userInfo)")
    }
    
    func applicationWillResignActive(application: UIApplication) {
        defaults.setObject(NSDate().timeIntervalSince1970, forKey:kUD_EnterBackgroundTime)
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        defaults.setObject(NSDate().timeIntervalSince1970, forKey:kUD_EnterBackgroundTime)
    }
}