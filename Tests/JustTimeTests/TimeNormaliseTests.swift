import XCTest
@testable import JustTime

final class TimeNormaliseTests: XCTestCase {

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
	// MARK: normaliseTime()
	// ------------------------------------
	func testNormaliseTime() {

		XCTAssertTrue(TimeNormaliser.normaliseTime((0,0,0), clampHoursTo24: false) == (0,0,0))
		XCTAssertTrue(TimeNormaliser.normaliseTime((0,60,60), clampHoursTo24: false) == (1,1,0))
		XCTAssertTrue(TimeNormaliser.normaliseTime((10,70,0), clampHoursTo24: false) == (11,10,0))
		XCTAssertTrue(TimeNormaliser.normaliseTime((180,180,180), clampHoursTo24: false) == (183,3,0))
		
		XCTAssertTrue(TimeNormaliser.normaliseTime((24,60,60), clampHoursTo24: true) == (1,1,0))
		XCTAssertTrue(TimeNormaliser.normaliseTime((75,1,1), clampHoursTo24: true) == (3,1,1))
	}
}
