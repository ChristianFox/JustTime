import XCTest
@testable import JustTime

final class TimeTests: XCTestCase {

	// ------------------------------------
	// MARK: Properties
	// ------------------------------------
	// # Public/Internal/Open

	// # Private/Fileprivate

	// =======================================
	// MARK: Setup / Teardown
	// =======================================
	override func setUpWithError() throws {
		try super.setUpWithError()
	}

	override func tearDownWithError() throws {
		try super.tearDownWithError()
	}

	// =======================================
	// MARK: Tests
	// =======================================
	// ------------------------------------
	// MARK: init(hour: minute: second:)
	// ------------------------------------
	func testInit_AllZero() {

		// GIVEN

		// WHEN
		let sut = Time(hour: 0, minute: 0)

		// THEN
		XCTAssertEqual(sut.hour, 0)
		XCTAssertEqual(sut.minute, 0)
		XCTAssertEqual(sut.second, 0)
	}

	func testInit_AllNonZeor() {

		// GIVEN

		// WHEN
		let sut = Time(hour: 10, minute: 20, second: 30)

		// THEN
		XCTAssertEqual(sut.hour, 10)
		XCTAssertEqual(sut.minute, 20)
		XCTAssertEqual(sut.second, 30)
	}

	func testInit_outsideClampRange_Clamps() {

		// GIVEN

		// WHEN
		let sut1 = Time(hour: 24, minute: 0)
		let sut2 = Time(hour: 0, minute: 60)
		let sut3 = Time(hour: 24, minute: 60)

		// THEN
		XCTAssertEqual(sut1.hour, 23)
		XCTAssertEqual(sut1.minute, 0)
		XCTAssertEqual(sut2.hour, 0)
		XCTAssertEqual(sut2.minute, 59)
		XCTAssertEqual(sut3.hour, 23)
		XCTAssertEqual(sut3.minute, 59)
	}

	// ------------------------------------
	// MARK: hour12
	// ------------------------------------
	func testHour12() {

		// GIVEN
		let a = Time(hour: 0)
		let b = Time(hour: 1)
		let c = Time(hour: 12)
		let d = Time(hour: 13)
		let e = Time(hour: 23)

		// WHEN
		let a12 = a.hour12
		let b12 = b.hour12
		let c12 = c.hour12
		let d12 = d.hour12
		let e12 = e.hour12

		// THEN
		XCTAssertTrue(a12 == (12, true))
		XCTAssertTrue(b12 == (1, true))
		XCTAssertTrue(c12 == (12, false))
		XCTAssertTrue(d12 == (1, false))
		XCTAssertTrue(e12 == (11, false))
	}

	// ------------------------------------
	// MARK: init(fromDate: calendar: zeroingSeconds:)
	// ------------------------------------
	func testInitFromDate() throws {

		// GIVEN
		let date: Date = Date()
		let calendar = Calendar.current
		let components = calendar.dateComponents([.hour, .minute, .second], from: date)

		// WHEN
		let sut = try Time(fromDate: date, calendar: calendar, discardSeconds: false)

		// THEN
		XCTAssertEqual(sut.hour, components.hour)
		XCTAssertEqual(sut.minute, components.minute)
		XCTAssertEqual(sut.second, components.second)
	}

	func testInitFromDate_ZeroingSeconds() throws {

		// GIVEN
		let date: Date = Date()
		let calendar = Calendar.current
		let components = calendar.dateComponents([.hour, .minute, .second], from: date)

		// WHEN
		let sut = try Time(fromDate: date, calendar: calendar, discardSeconds: true)

		// THEN
		XCTAssertEqual(sut.hour, components.hour)
		XCTAssertEqual(sut.minute, components.minute)
		XCTAssertEqual(sut.second, 0)
	}

	// ------------------------------------
	// MARK: date(fromDate: )
	// ------------------------------------
	func testDateFromDate() {

		// GIVEN
		let date: Date = Date()
		let calendar = Calendar.current
		let sut = Time(hour: 1, minute: 23, second: 44)

		// WHEN
		let newDate = sut.date(fromDate: date, calendar: calendar)

		// THEN
		let newComponents = calendar.dateComponents([.hour, .minute, .second], from: newDate!)
		XCTAssertEqual(newComponents.hour, 1)
		XCTAssertEqual(newComponents.minute, 23)
		XCTAssertEqual(newComponents.second, 44)
	}

	// ------------------------------------
	// MARK: roundToNearest(minutes: )
	// ------------------------------------
	func testRoundToNearestMinutes_RoundedTo15() {

		// GIVEN
		let a = Time(hour: 1, minute: 14, second: 44)
		let b = Time(hour: 12, minute: 52, second: 30)
		let c = Time(hour: 18, minute: 37, second: 29)
		let d = Time(hour: 18, minute: 37, second: 30)
		let e = Time(hour: 23, minute: 59, second: 59)
		let roundTo: UInt = 15

		// WHEN
		let aRounded = a.roundToNearest(minutes: roundTo)
		let bRounded = b.roundToNearest(minutes: roundTo)
		let cRounded = c.roundToNearest(minutes: roundTo)
		let dRounded = d.roundToNearest(minutes: roundTo)
		let eRounded = e.roundToNearest(minutes: roundTo)

		// THEN
		XCTAssertEqual(aRounded.hour, 1)
		XCTAssertEqual(bRounded.hour, 13)
		XCTAssertEqual(cRounded.hour, 18)
		XCTAssertEqual(dRounded.hour, 18)
		XCTAssertEqual(eRounded.hour, 0)
		XCTAssertEqual(aRounded.minute, 15)
		XCTAssertEqual(bRounded.minute, 0)
		XCTAssertEqual(cRounded.minute, 30)
		XCTAssertEqual(dRounded.minute, 45)
		XCTAssertEqual(eRounded.minute, 0)
	}

	func testRoundToNearestMinutes_RoundedTo60() {

		// GIVEN
		let a = Time(hour: 1, minute: 14, second: 44)
		let b = Time(hour: 12, minute: 58, second: 44)
		let c = Time(hour: 18, minute: 29, second: 59)
		let d = Time(hour: 18, minute: 30, second: 0)
		let roundTo: UInt = 60

		// WHEN
		let aRounded = a.roundToNearest(minutes: roundTo)
		let bRounded = b.roundToNearest(minutes: roundTo)
		let cRounded = c.roundToNearest(minutes: roundTo)
		let dRounded = d.roundToNearest(minutes: roundTo)

		// THEN
		XCTAssertEqual(aRounded.hour, 1)
		XCTAssertEqual(bRounded.hour, 13)
		XCTAssertEqual(cRounded.hour, 18)
		XCTAssertEqual(dRounded.hour, 19)
		XCTAssertEqual(aRounded.minute, 0)
		XCTAssertEqual(bRounded.minute, 0)
		XCTAssertEqual(cRounded.minute, 0)
		XCTAssertEqual(dRounded.minute, 0)
	}

	func testRoundToNearestMinutes_RoundedTo12Hours() {

		// GIVEN
		let a = Time(hour: 1, minute: 14, second: 44)
		let b = Time(hour: 12, minute: 58, second: 44)
		let c = Time(hour: 17, minute: 59, second: 59)
		let d = Time(hour: 18, minute: 30, second: 0)
		let roundTo: UInt = 12 * 60

		// WHEN
		let aRounded = a.roundToNearest(minutes: roundTo)
		let bRounded = b.roundToNearest(minutes: roundTo)
		let cRounded = c.roundToNearest(minutes: roundTo)
		let dRounded = d.roundToNearest(minutes: roundTo)

		// THEN
		XCTAssertEqual(aRounded.hour, 0)
		XCTAssertEqual(bRounded.hour, 12)
		XCTAssertEqual(cRounded.hour, 12)
		XCTAssertEqual(dRounded.hour, 0)
		XCTAssertEqual(aRounded.minute, 0)
		XCTAssertEqual(bRounded.minute, 0)
		XCTAssertEqual(cRounded.minute, 0)
		XCTAssertEqual(dRounded.minute, 0)
	}

	// ------------------------------------
	// MARK: duration(sinceEarlierTime: )
	// ------------------------------------
	func testDurationSinceEarlierTime_SameDay() {

		// GIVEN
		let sut = Time(hour: 10, minute: 20, second: 30)
		let other = Time(hour: 8, minute: 40, second: 50)

		// WHEN
		let duration = sut.duration(sinceEarlierTime: other)

		// THEN
		XCTAssertEqual(duration.hours, 1)
		XCTAssertEqual(duration.minutes, 39)
		XCTAssertEqual(duration.seconds, 40)
	}

	func testDurationSinceEarlierTime_PreviousDay() {

		// GIVEN
		let sut = Time(hour: 10, minute: 20, second: 30)
		let other = Time(hour: 10, minute: 21, second: 31)

		// WHEN
		let duration = sut.duration(sinceEarlierTime: other)

		// THEN
		XCTAssertEqual(duration.hours, 23)
		XCTAssertEqual(duration.minutes, 58)
		XCTAssertEqual(duration.seconds, 59)
	}

	// ------------------------------------
	// MARK: duration(tillLaterTime: )
	// ------------------------------------
	func testDurationTillLaterTime_SameDay_OtherValuesAllHigher() {

		// GIVEN
		let sut = Time(hour: 10, minute: 20, second: 30)
		let other = Time(hour: 12, minute: 21, second: 50)

		// WHEN
		let duration = sut.duration(tillLaterTime: other)

		// THEN
		XCTAssertEqual(duration.hours, 2)
		XCTAssertEqual(duration.minutes, 1)
		XCTAssertEqual(duration.seconds, 20)
	}

	func testDurationTillLaterTime_SameDay_SomeOtherValuesAreLower() {

		// GIVEN
		let sut = Time(hour: 10, minute: 20, second: 30)
		let other = Time(hour: 12, minute: 19, second: 29)

		// WHEN
		let duration = sut.duration(tillLaterTime: other)

		// THEN
		XCTAssertEqual(duration.hours, 1)
		XCTAssertEqual(duration.minutes, 58)
		XCTAssertEqual(duration.seconds, 59)
	}

	func testDurationTillLaterTime_NextDay() {

		// GIVEN
		let sut = Time(hour: 10, minute: 20, second: 30)
		let other = Time(hour: 6, minute: 10, second: 20)

		// WHEN
		let duration = sut.duration(tillLaterTime: other)

		// THEN
		XCTAssertEqual(duration.hours, 19)
		XCTAssertEqual(duration.minutes, 49)
		XCTAssertEqual(duration.seconds, 50)
	}

	// ------------------------------------
	// MARK: adding(_ timeInterval:)
	// ------------------------------------
	func testAddingTimeInterval() {

		// GIVEN
		let a = Time()
		let b = Time(hour: 1)
		let c = Time(hour: 23, minute: 59, second: 59)
		let d = Time(hour: 1, minute: 1, second: 1)
		let e = Time(hour: 0, minute: 0, second: 0)

		// WHEN
		let aNew = a.adding(3661)
		let bNew = b.adding(3661)
		let cNew = c.adding(1)
		let dNew = d.adding(3600 * 10 + 60 + 30)
		let eNew = e.adding(3600 * 48 + 1)

		// THEN
		XCTAssertEqual(aNew, Time(hour: 1, minute: 1, second: 1))
		XCTAssertEqual(bNew, Time(hour: 2, minute: 1, second: 1))
		XCTAssertEqual(cNew, Time(hour: 0, minute: 0, second: 0))
		XCTAssertEqual(dNew, Time(hour: 11, minute: 2, second: 31))
		XCTAssertEqual(eNew, Time(hour: 0, minute: 0, second: 1))
	}

	func testAddingTimeInterval_WithoutRollingOver() {

		// GIVEN
		let a = Time()
		let b = Time(hour: 1)
		let c = Time(hour: 23, minute: 59, second: 59)
		let d = Time(hour: 1, minute: 1, second: 1)
		let e = Time(hour: 0, minute: 0, second: 0)

		// WHEN
		let aNew = a.adding(3661, rollsOver: false)
		let bNew = b.adding(3661, rollsOver: false)
		let cNew = c.adding(1, rollsOver: false)
		let dNew = d.adding(3600 * 10 + 60 + 30, rollsOver: false)
		let eNew = e.adding(3600 * 48 + 1, rollsOver: false)

		// THEN
		XCTAssertEqual(aNew, Time(hour: 1, minute: 1, second: 1))
		XCTAssertEqual(bNew, Time(hour: 2, minute: 1, second: 1))
		XCTAssertEqual(cNew, Time(hour: 23, minute: 59, second: 59))
		XCTAssertEqual(dNew, Time(hour: 11, minute: 2, second: 31))
		XCTAssertEqual(eNew, Time(hour: 23, minute: 59, second: 59))
	}

	// ------------------------------------
	// MARK: subtracting(_ timeInterval:)
	// ------------------------------------
	func testSubtractingTimeInterval() {

		// GIVEN
		let a = Time(hour: 1, minute: 1, second: 1)
		let b = Time(hour: 10, minute: 10, second: 10)
		let c = Time(hour: 1, minute: 1, second: 1)
		let d = Time(hour: 0, minute: 0, second: 0)

		// WHEN
		let aNew = a.subtracting(3661)
		let bNew = b.subtracting(3661)
		let cNew = c.subtracting(3662)
		let dNew = d.subtracting(3600 * 24 + 61)

		// THEN
		XCTAssertEqual(aNew, Time(hour: 0, minute: 0, second: 0))
		XCTAssertEqual(bNew, Time(hour: 9, minute: 9, second: 9))
		XCTAssertEqual(cNew, Time(hour: 23, minute: 59, second: 59))
		XCTAssertEqual(dNew, Time(hour: 23, minute: 58, second: 59))
	}

	func testSubtractingTimeInterval_WithoutRollingOver() {

		// GIVEN
		let a = Time(hour: 1, minute: 1, second: 1)
		let b = Time(hour: 10, minute: 10, second: 10)
		let c = Time(hour: 1, minute: 1, second: 1)
		let d = Time(hour: 0, minute: 0, second: 0)

		// WHEN
		let aNew = a.subtracting(3662, rollsOver: false)
		let bNew = b.subtracting(3661, rollsOver: false)
		let cNew = c.subtracting(3662, rollsOver: false)
		let dNew = d.subtracting(3600 * 24 + 61, rollsOver: false)

		// THEN
		XCTAssertEqual(aNew, Time(hour: 0, minute: 0, second: 0))
		XCTAssertEqual(bNew, Time(hour: 9, minute: 9, second: 9))
		XCTAssertEqual(cNew, Time(hour: 0, minute: 0, second: 0))
		XCTAssertEqual(dNew, Time(hour: 0, minute: 0, second: 0))
	}

	// ------------------------------------
	// MARK: Equality
	// ------------------------------------
	func testEquality() {

		// GIVEN
		let a = Time(hour: 1, minute: 1, second: 1)
		let b = Time(hour: 10, minute: 10, second: 10)
		let c = Time(hour: 1, minute: 1, second: 1)

		// WHEN, THEN
		XCTAssertEqual(a, c)
		XCTAssertNotEqual(a, b)
	}

	// ------------------------------------
	// MARK: Comparable
	// ------------------------------------
	func testComparable() {

		// GIVEN
		let a = Time(hour: 1, minute: 1, second: 1)
		let b = Time(hour: 10, minute: 10, second: 10)
		let c = Time(hour: 1, minute: 1, second: 1)

		// WHEN, THEN
		XCTAssertGreaterThan(b, a)
		XCTAssertGreaterThanOrEqual(a, c)
		XCTAssertLessThan(c, b)
		XCTAssertLessThanOrEqual(c, a)
	}

	// ------------------------------------
	// MARK: Codable
	// ------------------------------------
	func testEncodingAndDecoding() throws {

		// GIVEN
		let sut = Time(hour: 1, minute: 23, second: 44)

		// WHEN
		let data = try JSONEncoder().encode(sut)
		let decoded = try JSONDecoder().decode(Time.self, from: data)

		// THEN
		XCTAssertEqual(decoded, sut)
	}

	// ------------------------------------
	// MARK: description
	// ------------------------------------
	func testDescription() {

		// GIVEN
		let a = Time(hour: 1, minute: 23, second: 04)
		let b = Time(hour: 23, minute: 0, second: 40)

		// WHEN, THEN
		XCTAssertEqual("01:23:04", a.description)
		XCTAssertEqual("23:00:40", b.description)
		XCTAssertEqual("01:23:04AM", a.description12HourClock)
		XCTAssertEqual("11:00:40PM", b.description12HourClock)
	}
}
