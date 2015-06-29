import XCTest

class TrackerTests: XCTestCase {
    
    let tracker = Tracker()
    
    let pomodoroTime = Double(Intervals.pomodoro.durationInSeconds)
    let pauseTime = Double(Intervals.pause.durationInSeconds)

    override func setUp() {
        defaults.setObject(nil, forKey:kUD_isTimerRunning)
        defaults.setObject(nil, forKey:kUD_StartDate)
    }

    func testNewTrackerInitalizesWithRightValues() {
        XCTAssertEqual(tracker.isRunning, false)
        XCTAssertEqual(tracker.description,.Pomodoro)
        XCTAssertEqual(tracker.time,"25:00")
        XCTAssertEqual(tracker.progress,100)
    }
    
    func testStartStopChangesStateCorretly() {
        XCTAssertEqual(tracker.isRunning, false)
        tracker.start()
        XCTAssertEqual(tracker.isRunning, true)
        tracker.stop()
        XCTAssertEqual(tracker.isRunning, false)
    }
    
    func testDescriptionChangesCorretlyAfterFirstPomdoro() {
        let date = NSDate(timeIntervalSinceNow: -pomodoroTime)
        tracker.start(date)
        XCTAssertEqual(tracker.description,.Pause)
    }
    
    func testDescriptionChangesCorretlyAfterFirstPomdoroAndFirstPause() {
        let date = NSDate(timeIntervalSinceNow: -(pomodoroTime+pauseTime))
        tracker.start(date)
        XCTAssertEqual(tracker.description,.Pomodoro)
    }
    
    func testDescriptionChangesCorretlyToLongPause() {
        let date = NSDate(timeIntervalSinceNow: -(4*pomodoroTime+3*pauseTime))
        tracker.start(date)
        XCTAssertEqual(tracker.description,.LongPause)
    }
    
    func testDurationChangesCorretlyAfterOneSecond() {
        let date = NSDate()
        tracker.start(date)
        XCTAssertEqual(tracker.time,"24:59")
    }
    
    func testDurationChangesCorretlyAtFirstPomodoro() {
        let halfPomodoro = pomodoroTime/2
        let date = NSDate(timeIntervalSinceNow: -halfPomodoro)
        tracker.start(date)
        XCTAssertEqual(tracker.time,"12:29")
    }
    
    func testDurationChangesCorretlyAtFirstPause() {
        let pomodoro = pomodoroTime
        let date = NSDate(timeIntervalSinceNow: -pomodoro)
        tracker.start(date)
        XCTAssertEqual(tracker.time,"04:59")
    }
}