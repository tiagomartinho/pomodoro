import XCTest

class TrackerTests: XCTestCase {
    
    let tracker = Tracker()
    
    let pomodoro = Double(Intervals.pomodoro.durationInSeconds)
    let halfPomodoro = Double(Intervals.pomodoro.durationInSeconds)/2
    let pause = Double(Intervals.pause.durationInSeconds)
    let longPause = Double(Intervals.longPause.durationInSeconds)
    
    override func setUp() {
        defaults.setObject(nil, forKey:kUD_isTimerRunning)
        defaults.setObject(nil, forKey:kUD_StartDate)
    }

    func testNewTrackerInitalizesWithRightValues() {
        XCTAssertEqual(tracker.isRunning, false)
        XCTAssertEqual(tracker.description,.Pomodoro)
        XCTAssertEqual(tracker.time,"25:00")
        XCTAssertEqual(tracker.progress,1.00)
    }
    
    func testStartStopChangesStateCorretly() {
        XCTAssertEqual(tracker.isRunning, false)
        tracker.start()
        XCTAssertEqual(tracker.isRunning, true)
        tracker.stop()
        XCTAssertEqual(tracker.isRunning, false)
    }
    
    func assertDescription(description:IntervalType, AtDate date:NSDate){
        tracker.start(date)
        XCTAssertEqual(tracker.description,description)
    }
    
    func assertTime(time:String, AtDate date:NSDate){
        tracker.start(date)
        XCTAssertEqual(tracker.time,time)
    }
    
    func assertProgress(progress:Float, AtDate date:NSDate){
        tracker.start(date)
        XCTAssertEqualWithAccuracy(tracker.progress, progress, 0.001)
    }
    
    func assertPomodoros(pomodoros:Int, AtDate date:NSDate){
        tracker.start(date)
        XCTAssertEqual(tracker.pomodoros,pomodoros)
    }
    
    func testStateAfterOneSecond() {
        let date = NSDate()
        assertTime("24:59",AtDate:date)
        assertDescription(.Pomodoro,AtDate:date)
        assertProgress(0.9993, AtDate:date)
        assertPomodoros(0,AtDate:date)
    }
    
    func testStateAfterHalfPomdoro() {
        let date = NSDate(timeIntervalSinceNow: -halfPomodoro)
        assertTime("12:29",AtDate:date)
        assertDescription(.Pomodoro,AtDate:date)
        assertProgress(0.4993, AtDate:date)
        assertPomodoros(0,AtDate:date)
    }
    
    func testStateAfterFirstPomdoro() {
        let date = NSDate(timeIntervalSinceNow: -pomodoro)
        assertTime("04:59",AtDate:date)
        assertDescription(.Pause,AtDate:date)
        assertProgress(0.9993, AtDate:date)
        assertPomodoros(1,AtDate:date)
    }
    
    func testStateAfterFirstPomdoroAndFirstPause() {
        let date = NSDate(timeIntervalSinceNow: -(pomodoro+pause))
        assertTime("24:59",AtDate:date)
        assertDescription(.Pomodoro,AtDate:date)
        assertProgress(0.9993, AtDate:date)
        assertPomodoros(1,AtDate:date)
    }
    
    func testStateAtLongPause() {
        let date = NSDate(timeIntervalSinceNow: -(4*pomodoro+3*pause))
        assertTime("14:59",AtDate:date)
        assertDescription(.LongPause,AtDate:date)
        assertProgress(0.9993, AtDate:date)
        assertPomodoros(4,AtDate:date)
    }
    
    func testStateWayAfterTimerIsOver() {
        let date = NSDate(timeIntervalSinceNow: -(45*pomodoro+32*pause+10*longPause))
        assertTime("25:00",AtDate:date)
        assertDescription(.Pomodoro,AtDate:date)
        assertProgress(1.0000, AtDate:date)
        assertPomodoros(0,AtDate:date)
    }
    
    func testStateWayBeforeTimer() {
        let date = NSDate(timeIntervalSinceNow: 45*pomodoro+32*pause+10*longPause)
        assertTime("25:00",AtDate:date)
        assertDescription(.Pomodoro,AtDate:date)
        assertProgress(1.0000, AtDate:date)
        assertPomodoros(0,AtDate:date)
    }
    
    func testStateRightBeforeTimerEnds() {
        let date = NSDate(timeIntervalSinceNow: -(4*pomodoro+3*pause+longPause-1))
        assertTime("00:00",AtDate:date)
        assertDescription(.LongPause,AtDate:date)
        assertProgress(0.0010, AtDate:date)
        assertPomodoros(4,AtDate:date)
    }
}