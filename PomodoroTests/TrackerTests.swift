import XCTest

class TrackerTests: XCTestCase {
    
    override func setUp() {
        defaults.setObject(nil, forKey:kUD_isTimerRunning)
        defaults.setObject(nil, forKey:kUD_StartDate)
    }

    func testNewTrackerInitalizesWithRightValues() {
        let tracker = Tracker()
        XCTAssertEqual(tracker.isRunning, false)
        XCTAssertEqual(tracker.description,.Pomodoro)
        XCTAssertEqual(tracker.time,"25:00")
        XCTAssertEqual(tracker.progress,100)
    }
    
    func testAfterStartStateChangesCorretly() {
        let tracker = Tracker()
        let date = NSDate(timeIntervalSinceNow: -1)
        tracker.start(date)
        XCTAssertEqual(tracker.isRunning, true)
        XCTAssertEqual(tracker.description,.Pomodoro)
        XCTAssertEqual(tracker.time,"24:59")
        XCTAssertEqualWithAccuracy(tracker.progress, 99.93, 0.01)
    }
    
    func testStateChangesCorretlyAfterFirstPomdoro() {
        let tracker = Tracker()
        let date = NSDate(timeIntervalSinceNow: -(25*60+1))
        tracker.start(date)
        XCTAssertEqual(tracker.isRunning, true)
        XCTAssertEqual(tracker.description,.Pause)
        XCTAssertEqual(tracker.time,"5:00")
        XCTAssertEqualWithAccuracy(tracker.progress, 100, 0.01)
    }
    
    func testStateGoesToLongPause() {
        let tracker = Tracker()
        let date = NSDate(timeIntervalSinceNow: -(120*60+1))
        tracker.start(date)
        XCTAssertEqual(tracker.isRunning, true)
        XCTAssertEqual(tracker.description,.LongPause)
        XCTAssertEqual(tracker.time,"15:00")
        XCTAssertEqualWithAccuracy(tracker.progress, 100, 0.01)
    }
}