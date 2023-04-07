import Foundation

/// Represents a length of time in hours, minutes and seconds. `minutes` and `seconds` are clamped between 0 and 59, hours are unclamped.
public struct Duration {

	// ------------------------------------
	// MARK: Properties
	// ------------------------------------
	// # Public/Internal/Open
	/// The number of hours
	public let hours: Int

	/// The number of minutes
	public let minutes: Int

	/// The number of seconds
	public let seconds: Int

	/// Are all values zero
	public var isZero: Bool {
		hours == 0 && minutes == 0 && seconds == 0
	}

	/// The total number of seconds represented by the receiver
	public var totalSeconds: TimeInterval {
		TimeInterval(seconds + (minutes * 60) + (hours * 3600))
	}

	/// The total number of minutes represented by the receiver
	public var totalMinutes: Double {
		totalSeconds / 60
	}

	/// The total number of hours represented by the receiver
	public var totalHours: Double {
		totalSeconds / 3600
	}

	// # Private/Fileprivate

	// ------------------------------------
	// MARK: Init
	// ------------------------------------
	/// Initilialise an instance
	/// - Parameters:
	///   - hours: The number of hours
	///   - minutes: The number of minutes
	///   - seconds: The number of seconds
	public init(hours: Int = 0, minutes: Int = 0, seconds: Int = 0) {
		let normalised = TimeNormaliser.normaliseTime((hours, minutes, seconds), clampHoursTo24: false)
		self.hours = normalised.hours
		self.minutes = normalised.minutes
		self.seconds = normalised.seconds
	}

	// =======================================
	// MARK: Public Methods
	// =======================================
	// ------------------------------------
	// MARK: Arithmetic
	// ------------------------------------
	public static func + (lhs: Duration, rhs: Duration) -> Duration {
		let seconds = lhs.seconds + rhs.seconds
		let minutes = lhs.minutes + rhs.minutes
		let hours = lhs.hours + rhs.hours
		let normalised = TimeNormaliser.normaliseTime((hours, minutes, seconds), clampHoursTo24: false)
		return Duration(hours: normalised.hours, minutes: normalised.minutes, seconds: normalised.seconds)
	}

	public static func - (lhs: Duration, rhs: Duration) -> Duration {
		let seconds = lhs.seconds - rhs.seconds
		let minutes = lhs.minutes - rhs.minutes
		let hours = lhs.hours - rhs.hours
		let normalised = TimeNormaliser.normaliseTime((hours, minutes, seconds), clampHoursTo24: false)
		return Duration(hours: normalised.hours, minutes: normalised.minutes, seconds: normalised.seconds)
	}
}

// =======================================
// MARK: Protocol Methods
// =======================================
extension Duration: Equatable {}

extension Duration: Comparable {

	public static func < (lhs: Duration, rhs: Duration) -> Bool {
		if lhs.hours != rhs.hours {
			return lhs.hours < rhs.hours
		} else if lhs.minutes != rhs.minutes {
			return lhs.minutes < rhs.minutes
		} else {
			return lhs.seconds < rhs.seconds
		}
	}
}

extension Duration: Codable {}

extension Duration: CustomStringConvertible {

	public var description: String {
		String(format: "%02d:%02d:%02d", hours, minutes, seconds)
	}
}
