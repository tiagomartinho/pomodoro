import UIKit
import AudioToolbox

class TrackerViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerProgress: UIProgressView!
    @IBOutlet weak var toggleTimerButton: UIButton!
    
    let tracker = Tracker()
    let scheduler = Scheduler()
    
    var mainNSTimer:NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserverToForegroundAndBackgroundChanges()
        updateUI()
        startTimer()
    }
    
    func addObserverToForegroundAndBackgroundChanges(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillEnterForeground:", name: UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidEnterBackground:", name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    func applicationWillEnterForeground(notification: NSNotification){
        updateUI()
        startTimer()
    }
    
    func applicationDidEnterBackground(notification: NSNotification){
        stopTimer()
    }
    
    func updateUI() {
        timerLabel.text = tracker.time
        timerLabel.textColor = UIColor.blackColor()
        timerProgress.progress = tracker.progress
        toggleTimerButton.setTitle(tracker.isRunning ? "Stop" : "Start", forState: UIControlState.Normal)
    }
    
    @IBAction func toggleTimer() {
        if tracker.isRunning {
            tracker.stop()
            scheduler.cancelAllPomodoriAndPauses()
        }
        else {
            tracker.start()
            scheduler.schedulePomodoriAndPauses()
        }
        updateUI()
    }
    
    func startTimer(){
        mainNSTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "tick:", userInfo: nil, repeats: true)
    }
    
    func tick(nsTimer: NSTimer) {
        updateUI()
        if tracker.time == "00:00" {
            vibratePhone()
        }
    }
    
    func stopTimer(){
        mainNSTimer?.invalidate()
        mainNSTimer = nil
    }
    
    func vibratePhone(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}