import XCTest
@testable import JustTime

final class TimeRangeTests: XCTestCase {

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
	// MARK: init(start: end:)
	// ------------------------------------
	func testInitWithStartAndEndTime() {

		// GIVEN
		let start = Time(hour: 9, minute: 0)
		let end = Time(hour: 17, minute: 30)

		// WHEN
		let sut = TimeRange(start: start, end: end)

		// THEN
		XCTAssertEqual(sut.start, start)
		XCTAssertEqual(sut.end, end)
	}

	func testInitWithEndTimeBeforeStartTime_IsValid() {

		// GIVEN
		let start = Time(hour: 9, minute: 0)
		let end = Time(hour: 17, minute: 30)

		// WHEN
		let sut = TimeRange(start: start, end: end)

		// THEN
		XCTAssertEqual(sut.start, start)
		XCTAssertEqual(sut.end, end)
	}

	// ------------------------------------
	// MARK: isEmpty
	// ------------------------------------
	func testIsEmpty() {

		// GIVEN
		let a = TimeRange(start: Time(hour: 1), end: Time(hour: 2))
		let b = TimeRange(start: Time(hour: 2), end: Time(hour: 1))
		let c = TimeRange(start: Time(hour: 3), end: Time(hour: 3))

		// WHEN
		let aIsEmpty = a.isEmpty
		let bIsEmpty = b.isEmpty
		let cIsEmpty = c.isEmpty

		// THEN
		XCTAssertFalse(aIsEmpty)
		XCTAssertFalse(bIsEmpty)
		XCTAssertTrue(cIsEmpty)
	}

	// ------------------------------------
	// MARK: duration
	// ------------------------------------
	func testDuration() {

		// GIVEN
		let a = TimeRange(start: Time(hour: 1), end: Time(hour: 2))
		let b = TimeRange(start: Time(hour: 2), end: Time(hour: 1))
		let c = TimeRange(start: Time(hour: 3), end: Time(hour: 3))

		// WHEN
		let aDuration = a.duration
		let bDuration = b.duration
		let cDuration = c.duration

		// THEN
		XCTAssertEqual(aDuration.hours, 1)
		XCTAssertEqual(bDuration.hours, 23)
		XCTAssertEqual(cDuration.hours, 0)
	}

	// ------------------------------------
	// MARK: contains(time: )
	// ------------------------------------
	func testContainsTime_StartTimePrecedesEndTime() {

		// GIVEN
		let start = Time(hour: 9, minute: 0)
		let end = Time(hour: 17, minute: 30)
		let sut = TimeRange(start: start, end: end)
		let earlierTime = Time(hour: 6, minute: 30)
		let inbetweenTime = Time(hour: 12, minute: 0)
		let laterTime = Time(hour: 21, minute: 00)

		// WHEN
		let containsEarlier = sut.contains(earlierTime)
		let containsInbetween = sut.contains(inbetweenTime)
		let containsLater = sut.contains(laterTime)

		// THEN
		XCTAssertFalse(containsEarlier)
		XCTAssertTrue(containsInbetween)
		XCTAssertFalse(containsLater)
	}

	func testContainsTime_RangeSpansTwoDays() {

		// GIVEN
		let start = Time(hour: 21, minute: 0)
		let end = Time(hour: 6, minute: 30)
		let sut = TimeRange(start: start, end: end)
		let earlierTime = Time(hour: 20, minute: 30)
		let inbetweenTime1 = Time(hour: 23, minute: 59)
		let inbetweenTime2 = Time(hour: 0, minute: 01)
		let laterTime = Time(hour: 7, minute: 00)

		// WHEN
		let containsEarlier = sut.contains(earlierTime)
		let containsInbetween1 = sut.contains(inbetweenTime1)
		let containsInbetween2 = sut.contains(inbetweenTime2)
		let containsLater = sut.contains(laterTime)

		// THEN
		XCTAssertFalse(containsEarlier)
		XCTAssertTrue(containsInbetween1)
		XCTAssertTrue(containsInbetween2)
		XCTAssertFalse(containsLater)
	}

	// ------------------------------------
	// MARK: overlaps(other: )
	// ------------------------------------
	func testOverlapsOther_OverlapsStart() {

		// GIVEN
		let start = Time(hour: 9, minute: 0)
		let end = Time(hour: 17, minute: 30)
		let sut = TimeRange(start: start, end: end)
		let other = TimeRange(start: Time(hour: 8, minute: 0),
								 end: Time(hour: 10, minute: 0))

		// WHEN
		let overlaps = sut.overlaps(other)

		// THEN
		XCTAssertTrue(overlaps)
	}

	func testOverlapsOther_OverlapsEnd() {

		// GIVEN
		let start = Time(hour: 9, minute: 0)
		let end = Time(hour: 17, minute: 30)
		let sut = TimeRange(start: start, end: end)
		let other = TimeRange(start: Time(hour: 16, minute: 0),
								 end: Time(hour: 18, minute: 0))

		// WHEN
		let overlaps = sut.overlaps(other)

		// THEN
		XCTAssertTrue(overlaps)
	}

	func testOverlapsOther_OverlapsCompletely() {

		// GIVEN
		let start = Time(hour: 9, minute: 0)
		let end = Time(hour: 17, minute: 30)
		let sut = TimeRange(start: start, end: end)
		let other = TimeRange(start: Time(hour: 8, minute: 0),
								 end: Time(hour: 18, minute: 0))

		// WHEN
		let overlaps = sut.overlaps(other)

		// THEN
		XCTAssertTrue(overlaps)
	}

	func testOverlapsOther_Underlaps() {

		// GIVEN
		let start = Time(hour: 9, minute: 0)
		let end = Time(hour: 17, minute: 30)
		let sut = TimeRange(start: start, end: end)
		let other = TimeRange(start: Time(hour: 12, minute: 0),
								 end: Time(hour: 13, minute: 0))

		// WHEN
		let overlaps = sut.overlaps(other)

		// THEN
		XCTAssertTrue(overlaps)
	}

	func testOverlapsOther_DoesNotOverlap() {

		// GIVEN
		let start = Time(hour: 9, minute: 0)
		let end = Time(hour: 17, minute: 30)
		let sut = TimeRange(start: start, end: end)
		let other = TimeRange(start: Time(hour: 6, minute: 0),
								 end: Time(hour: 7, minute: 0))

		// WHEN
		let overlaps = sut.overlaps(other)

		// THEN
		XCTAssertFalse(overlaps)
	}

	// ------------------------------------
	// MARK: split(by minutes:)
	// ------------------------------------
	func testSplitByMinutes_60() {

		// GIVEN
		let start = Time(hour: 9, minute: 0)
		let end = Time(hour: 17, minute: 0)
		let sut = TimeRange(start: start, end: end)
		let minutes: UInt = 60

		// WHEN
		let result = sut.split(by: minutes)

		// THEN
		XCTAssertEqual(result.count, 8)
		result.enumerated().forEach { item in
			XCTAssertEqual(item.element.start.hour, start.hour + item.offset)
			XCTAssertEqual(item.element.end.hour, start.hour + item.offset + 1)
			XCTAssertEqual(item.element.start.minute, 0)
			XCTAssertEqual(item.element.end.minute, 0)
		}
	}

	func testSplitByMinutes_30() {

		// GIVEN
		let start = Time(hour: 9, minute: 0)
		let end = Time(hour: 17, minute: 0)
		let sut = TimeRange(start: start, end: end)
		let minutes: UInt = 30

		// WHEN
		let result = sut.split(by: minutes)

		// THEN
		XCTAssertEqual(result.count, 16)
		result.enumerated().forEach { item in
			XCTAssertEqual(item.element.start.hour, start.hour + item.offset / 2)
			XCTAssertEqual(item.element.end.hour, start.hour + (item.offset + 1) / 2)
			XCTAssertEqual(item.element.start.minute, item.offset.isMultiple(of: 2) ? 0 : 30)
			XCTAssertEqual(item.element.end.minute, item.offset.isMultiple(of: 2) ? 30 : 0)
		}
	}

	// ------------------------------------
	// MARK: Equality
	// ------------------------------------
	func testEquality() {

		// GIVEN
		let a = TimeRange(start: Time(hour: 6, minute: 0),
							 end: Time(hour: 7, minute: 0))
		let b = TimeRange(start: Time(hour: 6, minute: 0),
							 end: Time(hour: 7, minute: 0))
		let c = TimeRange(start: Time(hour: 8, minute: 0),
							 end: Time(hour: 9, minute: 0))

		// WHEN, THEN
		XCTAssertEqual(a, b)
		XCTAssertNotEqual(a, c)
		XCTAssertNotEqual(b, c)
	}

	// ------------------------------------
	// MARK: Codable
	// ------------------------------------
	func testEncodingAndDecoding() throws {

		// GIVEN
		let sut = TimeRange(start: Time(hour: 8, minute: 0),
							   end: Time(hour: 9, minute: 0))

		// WHEN
		let data = try JSONEncoder().encode(sut)
		let decoded = try JSONDecoder().decode(TimeRange.self, from: data)

		// THEN
		XCTAssertEqual(decoded, sut)
	}

	// ------------------------------------
	// MARK: description
	// ------------------------------------
	func testDescription() {

		// GIVEN
		let sut = TimeRange(start: Time(hour: 1, minute: 23, second: 04),
							   end: Time(hour: 23, minute: 0, second: 40))

		// WHEN, THEN
		XCTAssertEqual("01:23:04 - 23:00:40", sut.description)
		XCTAssertEqual("01:23:04AM - 11:00:40PM", sut.description12HourClock)
	}

}
