import UIKit
import AudioToolbox

class TimerViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerProgress: UIProgressView!
    @IBOutlet weak var toggleTimerButton: UIButton!
    
    var timer = Timer(minutes: 1, seconds: 0)
    
    var mainNSTimer:NSTimer?
    
    var timerIsRunning:Bool{
        return mainNSTimer != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserverToForegroundAndBackgroundChanges()
        updateUI()
    }
    
    func addObserverToForegroundAndBackgroundChanges(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillEnterForeground:", name: UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidEnterBackground:", name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    func applicationWillEnterForeground(notification: NSNotification){
        if let backgroundDate = defaults.objectForKey(kUD_EnterBackgroundDate) as? NSDate {
            println("timeIntervalSinceNow: \(abs(backgroundDate.timeIntervalSinceNow))")
        }
    }
    
    func applicationDidEnterBackground(notification: NSNotification){
        defaults.setObject(NSDate(), forKey:kUD_EnterBackgroundDate)
    }
    
    func updateUI(){
        timerLabel.text = "\(timer)"
        timerLabel.textColor = UIColor.blackColor()
        timerProgress.progress = 1-timer.progress
        toggleTimerButton.setTitle(timerIsRunning ? "Stop" : "Start", forState: UIControlState.Normal)
    }
    
    @IBAction func toggleTimer() {
        timerIsRunning ? stopAndResetTimer() : startTimer()
//        timerIsRunning ? Scheduler().schedulePomodoriAndPauses() : Scheduler().cancelAllPomodoriAndPauses()
        updateUI()
    }
    
    func startTimer(){
        mainNSTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "tick:", userInfo: nil, repeats: true)
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
            vibratePhone()
        }
        
        updateUI()
    }
    
    func vibratePhone(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}