import UIKit
import AudioToolbox
import Crashlytics

class TrackerViewController: UIViewController {
    
    @IBOutlet weak var rightTimerProgress: UIProgressView!
    @IBOutlet weak var leftTimerProgress: UIProgressView!
    @IBOutlet weak var toggleTimerButton: UIButton!
    @IBOutlet weak var pomodorosLabel: UILabel!
    
    let tracker = Tracker()
    let scheduler = Scheduler()
    
    var mainNSTimer:NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rotateLeftProgressBar()
        addObserverToForegroundAndBackgroundChanges()
        updateUI()
        startTimer()
    }
    
    func rotateLeftProgressBar(){
        leftTimerProgress.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
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
        updateLabel()
        updateProgressView()
        updateButton()
    }
    
    func updateLabel(){
        var pomodoros = ""
        for _ in 0..<tracker.pomodoros {
            pomodoros += "."
        }
        pomodorosLabel.text = pomodoros
    }
    
    func updateProgressView(){
        for progressBar in [leftTimerProgress,rightTimerProgress] {
            if tracker.isRunning {
                progressBar.hidden = false
                progressBar.progress = tracker.progress
                if tracker.description == IntervalType.Pomodoro {
                    progressBar.tintColor = UIColor.redColor()
                }
                else{
                    progressBar.tintColor = UIColor.blueColor()
                }
            }
            else {
                progressBar.hidden = true
            }
        }
    }
    
    func updateButton(){
        toggleTimerButton.setTitle(tracker.isRunning ? "stop".localized : "start".localized, forState: UIControlState.Normal)
    }
    
    @IBAction func toggleTimer() {
        let event:String
        if tracker.isRunning {
            tracker.stop()
            scheduler.cancelAllPomodoriAndPauses()
            event = "Stop"
        }
        else {
            tracker.start()
            scheduler.schedulePomodoriAndPauses()
            event = "Start"
        }
        Crashlytics.sharedInstance().logEvent(event)
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