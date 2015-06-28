import UIKit
import AudioToolbox

class TimerViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerProgress: UIProgressView!
    @IBOutlet weak var toggleTimerButton: UIButton!
    
    var timer = Timer(minutes: 5, seconds: 0)
    
    var mainNSTimer:NSTimer?
    
    var timerIsRunning:Bool{
        return defaults.objectForKey(kUD_isTimerRunning) as? Bool ?? false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserverToForegroundAndBackgroundChanges()
        updateState()
    }
    
    func addObserverToForegroundAndBackgroundChanges(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillEnterForeground:", name: UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidEnterBackground:", name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    func applicationWillEnterForeground(notification: NSNotification){
        updateState()
    }
    
    func applicationDidEnterBackground(notification: NSNotification){
        stopAndResetTimer()
    }
    
    func updateState(){
        if let isTimerRunning = defaults.objectForKey(kUD_isTimerRunning) as? Bool, let backgroundDate = defaults.objectForKey(kUD_StartDate) as? NSDate {
            if(isTimerRunning){
                println("timeIntervalSinceNow: \(abs(backgroundDate.timeIntervalSinceNow))")
                startTimer()
            }
        }
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
        defaults.setObject(true, forKey:kUD_isTimerRunning)
        defaults.setObject(NSDate(), forKey:kUD_StartDate)
        mainNSTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "tick:", userInfo: nil, repeats: true)
    }
    
    func stopAndResetTimer(){
        stopTimer()
        mainNSTimer = nil
        timer.reset()
    }
    
    func stopTimer(){
        mainNSTimer?.invalidate()
        defaults.setObject(false, forKey:kUD_isTimerRunning)
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