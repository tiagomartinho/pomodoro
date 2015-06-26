import XCTest

class TimerTests: XCTestCase {
    
    var timer = Timer(minutes: 12, seconds: 34)
    
    func assertTimer(#minutes:Int,seconds:Int,progress:Float,finished:Bool){
        XCTAssertEqual(minutes, timer.minutes)
        XCTAssertEqual(seconds, timer.seconds)
        XCTAssertEqualWithAccuracy(progress, timer.progress, 0.1)
        XCTAssertEqual(finished,timer.finished)
    }
    
    func testNewTimerInitalizesWithRightValues() {
        assertTimer(minutes:12,seconds:34,progress:0.0,finished:false)
    }
    
    func testDecreaseReducesOneSecond() {
        timer.decrease()
        assertTimer(minutes:12,seconds:33,progress:1.0 - 0.9986,finished:false)
    }
    
    func testDecreaseReducesOneMinuteIfSecondsAreZero() {
        timer = Timer(minutes: 12, seconds: 00)
        timer.decrease()
        assertTimer(minutes:11,seconds:59,progress:1.0 - 0.9986,finished:false)
    }
    
    func testTimerConformsToPrintableProtocol() {
        XCTAssertEqual("\(timer)", "12:34")
    }
    
    func testTimerPrintsSymmetricDescription() {
        timer = Timer(minutes: 1, seconds: 2)
        XCTAssertEqual("\(timer)", "01:02")
    }
    
    func testTimerTracksProgressInPercent(){
        for _ in 0...10 {
            timer.decrease()
        }
        assertTimer(minutes:12,seconds:23,progress:1.0 - 0.9854,finished:false)
    }
    
    func testTimerDoesntDecreaseAfterZeroAndFinishes(){
        timer = Timer(minutes: 0, seconds: 5)
        for _ in 0...10 {
            timer.decrease()
        }
        assertTimer(minutes:0,seconds:0,progress:1.0,finished:true)
    }
    
    func testTimerResetsToInitalValue(){
        for _ in 0...10 {
            timer.decrease()
        }
        assertTimer(minutes:12,seconds:23,progress:1.0 - 0.9854,finished:false)
        timer.reset()
        assertTimer(minutes:12,seconds:34,progress:0.0,finished:false)
    }
    
    func testTimerSetsToValueLessThanInitialValue(){
        assertTimer(minutes:12,seconds:34,progress:0.0,finished:false)
        timer.set(minutes: 6, seconds: 17)
        assertTimer(minutes:6,seconds:17,progress:0.5,finished:false)
    }
}
