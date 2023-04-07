import XCTest
@testable import JustTime

final class DurationTests: XCTestCase {

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
	// MARK: init
	// ------------------------------------
	func testInit() {

		// GIVEN

		// WHEN
		let a = Duration(hours: 0, minutes: 0, seconds: 0)
		let b = Duration(hours: 100, minutes: 10, seconds: 10)
		let c = Duration(hours: 70, minutes: 70, seconds: 70)
		let d = Duration(hours: 0, minutes: 130, seconds: 130)

		// THEN
		XCTAssertEqual(a.hours, 0)
		XCTAssertEqual(a.minutes, 0)
		XCTAssertEqual(a.seconds, 0)
		XCTAssertEqual(b.hours, 100)
		XCTAssertEqual(b.minutes, 10)
		XCTAssertEqual(b.seconds, 10)
		XCTAssertEqual(c.hours, 71)
		XCTAssertEqual(c.minutes, 11)
		XCTAssertEqual(c.seconds, 10)
		XCTAssertEqual(d.hours, 2)
		XCTAssertEqual(d.minutes, 12)
		XCTAssertEqual(d.seconds, 10)
	}

	// ------------------------------------
	// MARK: isZero
	// ------------------------------------
	func testIsZero() {

		// GIVEN
		let isZero = Duration(hours: 0, minutes: 0, seconds: 0)
		let isNotZero = Duration(hours: 0, minutes: 0, seconds: 1)

		// WHEN, THEN
		XCTAssertTrue(isZero.isZero)
		XCTAssertFalse(isNotZero.isZero)
	}

	// ------------------------------------
	// MARK: Totals
	// ------------------------------------
	func testTotals() {

		// GIVEN
		let a = Duration(hours: 1, minutes: 0, seconds: 0)
		let b = Duration(hours: 1, minutes: 30, seconds: 0)
		let c = Duration(hours: 1, minutes: 30, seconds: 30)

		// WHEN, THEN
		XCTAssertEqual(a.totalHours, 1.0)
		XCTAssertEqual(a.totalMinutes, 60)
		XCTAssertEqual(a.totalSeconds, 3600)
		XCTAssertEqual(b.totalHours, 1.5)
		XCTAssertEqual(b.totalMinutes, 90)
		XCTAssertEqual(b.totalSeconds, 5400)
		XCTAssertEqual(c.totalHours, 1.508, accuracy: 0.001)
		XCTAssertEqual(c.totalMinutes, 90.5)
		XCTAssertEqual(c.totalSeconds, 5430)
	}

	// ------------------------------------
	// MARK: +
	// ------------------------------------
	func testAddTwoDurations() {

		// GIVEN
		let a = Duration(hours: 10, minutes: 10, seconds: 10)
		let b = Duration(hours: 100, minutes: 9, seconds: 8)
		let c = Duration(hours: 20, minutes: 51, seconds: 51)

		// WHEN
		let ab = a + b
		let ac = a + c
		let bc = b + c

		// THEN
		XCTAssertEqual(ab.hours, 110)
		XCTAssertEqual(ab.minutes, 19)
		XCTAssertEqual(ab.seconds, 18)
		XCTAssertEqual(ac.hours, 31)
		XCTAssertEqual(ac.minutes, 2)
		XCTAssertEqual(ac.seconds, 1)
		XCTAssertEqual(bc.hours, 121)
		XCTAssertEqual(bc.minutes, 0)
		XCTAssertEqual(bc.seconds, 59)
	}

	func testSubtractOneDurationFromAnother() {

		// GIVEN
		let a = Duration(hours: 100, minutes: 10, seconds: 10)
		let b = Duration(hours: 10, minutes: 9, seconds: 8)
		let c = Duration(hours: 20, minutes: 51, seconds: 51)

		// WHEN
		let ab = a - b
		let ac = a - c
		let bc = b - c

		// THEN
		XCTAssertEqual(ab.hours, 90)
		XCTAssertEqual(ab.minutes, 1)
		XCTAssertEqual(ab.seconds, 2)
		XCTAssertEqual(ac.hours, 79)
		XCTAssertEqual(ac.minutes, 18)
		XCTAssertEqual(ac.seconds, 19)
		XCTAssertEqual(bc.hours, -11)
		XCTAssertEqual(bc.minutes, 17)
		XCTAssertEqual(bc.seconds, 17)
	}

	// ------------------------------------
	// MARK: Equality
	// ------------------------------------
	func testEquality() {

		// GIVEN
		let a = Duration(hours: 10, minutes: 10, seconds: 10)
		let b = Duration(hours: 10, minutes: 10, seconds: 10)
		let c = Duration(hours: 10, minutes: 10, seconds: 11)

		// WHEN, THEN
		XCTAssertEqual(a, b)
		XCTAssertNotEqual(a, c)
		XCTAssertNotEqual(b, c)
	}

	// ------------------------------------
	// MARK: Comparable
	// ------------------------------------
	func testComparable() {

		// GIVEN
		let a = Duration(hours: 10, minutes: 10, seconds: 10)
		let b = Duration(hours: 10, minutes: 10, seconds: 10)
		let c = Duration(hours: 10, minutes: 10, seconds: 11)
		let d = Duration(hours: 10, minutes: 9, seconds: 12)

		// WHEN, THEN
		XCTAssertTrue(d < c) // trying to boost code coverage
		XCTAssertTrue(c > a) // trying to boost code coverage
		XCTAssertTrue(b <= a && d <= c) // trying to boost code coverage
		XCTAssertGreaterThan(c, a)
		XCTAssertGreaterThanOrEqual(a, b)
		XCTAssertLessThan(d, c)
		XCTAssertLessThanOrEqual(b, a)
	}

	// ------------------------------------
	// MARK: Codable
	// ------------------------------------
	func testEncodingAndDecoding() throws {

		// GIVEN
		let sut = Duration(hours: 10, minutes: 10, seconds: 10)

		// WHEN
		let data = try JSONEncoder().encode(sut)
		let decoded = try JSONDecoder().decode(Duration.self, from: data)

		// THEN
		XCTAssertEqual(sut, decoded)
	}

	// ------------------------------------
	// MARK: description
	// ------------------------------------
	func testDescription() {

		// GIVEN
		let a = Duration(hours: 1, minutes: 23, seconds: 04)
		let b = Duration(hours: 44, minutes: 0, seconds: 40)

		// WHEN, THEN
		XCTAssertEqual("01:23:04", a.description)
		XCTAssertEqual("44:00:40", b.description)
	}
}
