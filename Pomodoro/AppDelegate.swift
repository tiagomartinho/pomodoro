import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        if let backgroundDate = defaults.objectForKey(kUD_EnterBackgroundDate) as? NSDate {
            println("timeIntervalSinceNow: \(backgroundDate.timeIntervalSinceNow)")
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        defaults.setObject(NSDate(), forKey:kUD_EnterBackgroundDate)
    }
}