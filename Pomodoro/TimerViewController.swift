import UIKit
import AudioToolbox

class TimerViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerProgress: UIProgressView!
    @IBOutlet weak var toggleTimerButton: UIButton!
    
    var timer = Timer(minutes: 25, seconds: 0)
    
    var mainNSTimer:NSTimer?
    
    var timerIsRunning:Bool{
        return mainNSTimer != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let backgroundTime = defaults.objectForKey(kUD_EnterBackgroundTime) as? NSTimeInterval {
            let timeInBackground = NSDate().timeIntervalSince1970 - backgroundTime
            println(timeInBackground)
        }
        
        scheduleNotification()
    }
    
    func scheduleNotification(){
        var localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "alertAction"
        localNotification.alertBody = "alertBody"
        localNotification.alertTitle = "alertTitle"
        localNotification.userInfo = ["userInfoKey":"userInfoValue"]
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 5)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func cancelAllNotifications(){
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    func updateUI(){
        timerLabel.text = "\(timer)"
        timerLabel.textColor = UIColor.blackColor()
        timerProgress.progress = 1-timer.progress
        toggleTimerButton.setTitle(timerIsRunning ? "Stop" : "Start", forState: UIControlState.Normal)
    }
    
    @IBAction func toggleTimer() {
        timerIsRunning ? stopAndResetTimer() : startTimer()
        updateUI()
    }
    
    func startTimer(){
        UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
        }
        
        mainNSTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "tick:", userInfo: nil, repeats: true)
        
        NSRunLoop.currentRunLoop().addTimer(mainNSTimer!, forMode: NSRunLoopCommonModes)
    }
    
    func stopAndResetTimer(){
        stopTimer()
        mainNSTimer = nil
        timer.reset()
    }
    
    func stopTimer(){
        mainNSTimer?.invalidate()
    }
    
    func tick(nsTimer: NSTimer) {
        timer.decrease()
        
        if(timer.finished){
            stopTimer()
            flashTimer(1)
        }
        
        updateUI()
    }
    
    func flashTimer(count:Int){
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "flashTimerLabelAndVibrate:", userInfo: count, repeats: false)
    }
    
    func flashTimerLabelAndVibrate(nsTimer: NSTimer) {
        if let count = nsTimer.userInfo as? Int{
            if timer.finished && count<3{
                toggleTimerLabelBetweenRedAndBlack()
                vibratePhone()
                flashTimer(count+1)
            }
        }
    }
    
    func toggleTimerLabelBetweenRedAndBlack(){
        timerLabel.textColor = (timerLabel.textColor == UIColor.redColor()) ? UIColor.blackColor() : UIColor.redColor()
    }
    
    func vibratePhone(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}