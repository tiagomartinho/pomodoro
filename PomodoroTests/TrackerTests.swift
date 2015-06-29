import XCTest

class TrackerTests: XCTestCase {
    
    let tracker = Tracker()
    
    let pomodoro = Double(Intervals.pomodoro.durationInSeconds)
    let halfPomodoro = Double(Intervals.pomodoro.durationInSeconds)/2
    let pause = Double(Intervals.pause.durationInSeconds)

    func assertDescription(description:IntervalType, AtDate date:NSDate){
        tracker.start(date)
        XCTAssertEqual(tracker.description,description)
    }
    
    func assertTime(time:String, AtDate date:NSDate){
        tracker.start(date)
        XCTAssertEqual(tracker.time,time)
    }
    
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
        let date = NSDate(timeIntervalSinceNow: -pomodoro)
        assertDescription(.Pause,AtDate:date)
    }
    
    func testDescriptionChangesCorretlyAfterFirstPomdoroAndFirstPause() {
        let date = NSDate(timeIntervalSinceNow: -(pomodoro+pause))
        assertDescription(.Pomodoro,AtDate:date)
    }
    
    func testDescriptionChangesCorretlyToLongPause() {
        let date = NSDate(timeIntervalSinceNow: -(4*pomodoro+3*pause))
        assertDescription(.LongPause,AtDate:date)
    }
    
    func testDurationChangesCorretlyAfterOneSecond() {
        assertTime("24:59",AtDate:NSDate())
    }
    
    func testDurationChangesCorretlyAtFirstPomodoro() {
        let date = NSDate(timeIntervalSinceNow: -halfPomodoro)
        assertTime("12:29",AtDate:date)
    }
    
    func testDurationChangesCorretlyAtFirstPause() {
        let date = NSDate(timeIntervalSinceNow: -pomodoro)
        assertTime("04:59",AtDate:date)
    }
    
    func testDurationChangesCorretlyAtLongPause() {
        let date = NSDate(timeIntervalSinceNow: -(4*pomodoro+3*pause))
        assertTime("14:59",AtDate:date)
    }
}