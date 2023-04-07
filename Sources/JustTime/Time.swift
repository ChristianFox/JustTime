import Foundation

/// Represents a single point in time in a 24 hour day
public struct Time {

	// ------------------------------------
	// MARK: Error
	// ------------------------------------
	public enum Error: LocalizedError {
		case unableToInitialiseTimeInstanceDueToInvalidDateComponents

		public var errorDescription: String? {
			String(describing: self)
		}
	}

	// ------------------------------------
	// MARK: Properties
	// ------------------------------------
	// # Public/Internal/Open
	/// The hour value on a 24 hour clock, clamped between 0 and 23
	@Clamping(wrappedValue: 0, range: (0...23))
	public private(set) var hour: Int

	/// The minute value, clamped between 0 and 59
	@Clamping(wrappedValue: 0, range: (0...59))
	public private(set) var minute: Int

	/// The second value, clamped between 0 and 59
	@Clamping(wrappedValue: 0, range: (0...59))
	public private(set) var second: Int

	/// The hour value on a 12 hour clock and a flag stating if it is AM or PM
	public var hour12: (hour: Int, isAM: Bool) {
		if hour < 12 {
			return hour == 0 ? (12, true) : (hour, true)
		} else {
			return hour == 12 ? (12, false) : (hour - 12, false)
		}
	}

	/// The total number of seconds represented by the receiver
	public var totalSeconds: TimeInterval {
		TimeInterval(second + (minute * 60) + (hour * 3600))
	}

	/// Symbol for AM on a 12-hour clock, defaults to "AM"
	public var amSymbol: String = "AM"

	/// Symbol for PM on a 12-hour clock, defaults to "PM"
	public var pmSymbol: String = "PM"

	// ------------------------------------
	// MARK: Init
	// ------------------------------------
	/// Initializes a new instance of `Time` with the specified hour, minute, and second values.
	///
	/// - Parameters:
	///   - hour: An `Int` representing the hour value on a 24-hour clock, with a default value of 0. Will be clamped to (0...23).
	///   - minute: An `Int` representing the minute value, with a default value of 0. Will be clamped to (0...59).
	///   - second: An  `Int` representing the second value, with a default value of 0. Will be clamped to (0...59).
	public init(hour: Int = 0, minute: Int = 0, second: Int = 0) {
		self._hour = Clamping(wrappedValue: hour, range: (0...23))
		self._minute = Clamping(wrappedValue: minute, range: (0...59))
		self._second = Clamping(wrappedValue: second, range: (0...59))
	}

	/// Initializes a new instance of `Time` with the specified date.
	///
	/// - Parameters:
	///   - date: A `Date` object to create the new instance from. Hour, Minute and Second will be read from the date, all other values will be ignored.
	///   - calendar: A `Calendar` object specifying the calendar to use when retrieving date components, with a default value of the current calendar.
	///   - discardSeconds: A `Boolean` indicating whether to zero out the seconds value when initializing from a date, with a default value of `false`. If set to `true`, the seconds value will be set to 0. If set to `false`, the seconds value will be retrieved from the provided date.
	/// - Throws: An error of type `Time.Error` if the date components retrieved from the provided date are invalid and a new instance of `Time` cannot be created.
	public init(fromDate date: Date, calendar: Calendar = .current, discardSeconds: Bool = false) throws {

		let components = calendar.dateComponents([.hour, .minute, .second], from: date)
		guard let hour = components.hour,
			let minute = components.minute,
			let second = components.second else {
			throw Self.Error.unableToInitialiseTimeInstanceDueToInvalidDateComponents
		}
		self.init(hour: hour, minute: minute, second: discardSeconds ? 0 : second)
	}

	// =======================================
	// MARK: Public Methods
	// =======================================
	/// Returns either the `amSymbol` or `pmSymbol`
	public func symbol(isAM: Bool) -> String {
		isAM ? amSymbol : pmSymbol
	}

	/// Creates a new `Date` instance by combining the time represented by this `Time` instance with the calendar date provided as a parameter.
	/// - Parameters:
	///   - date: The calendar date to which the time represented by this instance will be combined.
	///   - calendar: A `Calendar` object specifying the calendar to use when retrieving date components and creating the final `Date`, with a default value of the current calendar.
	/// - Returns: A new `Date` instance representing the combined date and time, or `nil` if the provided calendar date is invalid.
	public func date(fromDate date: Date, calendar: Calendar = .current) -> Date? {

		var components = calendar.dateComponents([.hour, .minute, .second, .day, .month, .year], from: date)
		components.hour = hour
		components.minute = minute
		components.second = second
		return calendar.date(from: components)
	}

	/// Rounds the time to the nearest specified minutes
	public func roundToNearest(minutes: UInt) -> Time {
		let timeInSeconds = hour * 3600 + minute * 60 + second
		let roundedTimeInSeconds = round(Double(timeInSeconds) / (Double(minutes) * 60)) * Double(minutes) * 60
		let roundedHour = Int(roundedTimeInSeconds / 3600) % 24
		let roundedMinute = Int(roundedTimeInSeconds / 60) % 60
		return Time(hour: roundedHour, minute: roundedMinute, second: 0)
	}

	// ------------------------------------
	// MARK: Duration between two Time instances
	// ------------------------------------
	/*
	 These two methods calculate the duration between two time instances by comparing their individual components (hours, minutes, and seconds). However, as these time objects have no concept of days, if the two time instances are on different days, the calculated duration may not accurately reflect the actual time difference between them. To handle this scenario, the `duration(sinceEarlierTime:)` and `duration(tillLaterTime:)` methods have been implemented to handle cases where the earlier or later time may be on a different day than the receiver time. This ensures that the duration is correctly calculated even when spanning over multiple days.
	 */

	/// Calculates the duration between the receiver and an earlier time.
	///
	/// If `other` has a higher value than the receiver eg. h:10, m:0, s:0 > h8, m:0, s:0, then `other` is considered to be a time of the previous day so in the preceding example the duration returned will be h:22, m:0, s:0, as in there are 22 hours since 10:00 yesterday till 8:00 today
	///
	/// - Parameter other: The earlier `Time` to compare with.
	/// - Returns: The `Duration` representing the duration between the receiver and the earlier time.
	public func duration(sinceEarlierTime other: Time) -> Duration {

		let diffHours = self.hour - other.hour
		let diffMinutes = self.minute - other.minute
		let diffSeconds = self.second - other.second
		let normalised = TimeNormaliser.normaliseTime((diffHours, diffMinutes, diffSeconds), clampHoursTo24: true)
		return Duration(hours: normalised.hours, minutes: normalised.minutes, seconds: normalised.seconds)
	}

	///  Calculates the duration between the receiver and a later time.
	///
	/// If `other` has a lower value than the receiver eg. h:8, m:0, s:0 is less than h10, m:0, s:0, then `other` is considered to be a time of the next day so in that example the duration returned will be h:22, m:0, s:0, as in there are 22 hours from 10:00 today until 8:00 tomorrow.
	///
	/// - Parameter other: The later `Time` to compare with.
	/// - Returns: The `Duration` representing the duration between the receiver and the later time.
	public func duration(tillLaterTime other: Time) -> Duration {

		let diffHours = other.hour - self.hour
		let diffMinutes = other.minute - self.minute
		let diffSeconds = other.second - self.second
		let normalised = TimeNormaliser.normaliseTime((diffHours, diffMinutes, diffSeconds), clampHoursTo24: true)
		return Duration(hours: normalised.hours, minutes: normalised.minutes, seconds: normalised.seconds)
	}

	// ------------------------------------
	// MARK: Arithmetic
	// ------------------------------------
	/// Returns a new `Time` instance by adding the given time interval to the receiver.
	///
	/// - Parameter timeInterval: The time interval to add.
	/// - Parameter rollsOver: Indicates whether the addition operation can roll over to a next day if `timeInterval > (secondsInADay - self.totalSeconds)`or whether the result should be fixed at 23:59:59 in that situtation
	/// - Returns: A new `Time` instance by adding the given time interval to the receiver.
	public func adding(_ timeInterval: TimeInterval, rollsOver: Bool = true) -> Time {

		var newTotalSeconds = totalSeconds + timeInterval
		let secondsInADay: TimeInterval = 86400
		if rollsOver {
			// Roll over to the next day if newTotalSeconds is greater than the number of seconds in a day
			newTotalSeconds = newTotalSeconds.truncatingRemainder(dividingBy: secondsInADay)
			if newTotalSeconds < 0 {
				newTotalSeconds += secondsInADay
			}
		} else {
			
			// Fix result at 23:59:59 if newTotalSeconds is greater than the number of seconds in a day
			if newTotalSeconds >= secondsInADay {
				newTotalSeconds = secondsInADay - 1
			}
		}

		let newHour = Int(newTotalSeconds / 3600)
		let newMinute = Int(newTotalSeconds / 60) % 60
		let newSecond = Int(newTotalSeconds.truncatingRemainder(dividingBy: 60))
		return Time(hour: newHour, minute: newMinute, second: newSecond)
	}

	/// Returns a new `Time` instance by subtracting the given time interval to the receiver.
	///
	/// - Parameter timeInterval: The time interval to subtract.
	/// - Parameter rollsOver: Indicates whether the subtraction operation can roll over to a previous day if `timeInterval > self.totalSeconds`or whether the result should be fixed at 00:00:00 in that situtation
	/// - Returns: A new `Time` instance by subtracting the given time interval to the receiver.
	public func subtracting(_ timeInterval: TimeInterval, rollsOver: Bool = true) -> Time {
		let newTimeInSeconds = Double((hour * 3600) + (minute * 60) + second) - timeInterval
		var hours = Int(newTimeInSeconds / 3600)
		var minutes = Int((newTimeInSeconds / 60).truncatingRemainder(dividingBy: 60))
		var seconds = Int(newTimeInSeconds.truncatingRemainder(dividingBy: 60))

		if rollsOver {

			let normalised = TimeNormaliser.normaliseTime((hours, minutes, seconds), clampHoursTo24: true)
			hours = normalised.hours
			minutes = normalised.minutes
			seconds = normalised.seconds
		}

		return Time(hour: hours, minute: minutes, second: seconds)
	}
}

// =======================================
// MARK: Protocol Conformance
// =======================================
extension Time: Equatable {

	public static func == (lhs: Time, rhs: Time) -> Bool {
		lhs.hour == rhs.hour && lhs.minute == rhs.minute && lhs.second == rhs.second
	}
}

extension Time: Comparable {

	public static func < (lhs: Time, rhs: Time) -> Bool {
		if lhs.hour != rhs.hour {
			return lhs.hour < rhs.hour
		} else if lhs.minute != rhs.minute {
			return lhs.minute < rhs.minute
		} else {
			return lhs.second < rhs.second
		}
	}
}

extension Time: Codable {

	private enum CodingKeys: String, CodingKey {
		case hour
		case minute
		case second
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		let hour = try values.decode(Int.self, forKey: .hour)
		let minute = try values.decode(Int.self, forKey: .minute)
		let second = try values.decode(Int.self, forKey: .second)
		self.init(hour: hour, minute: minute, second: second)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(hour, forKey: .hour)
		try container.encode(minute, forKey: .minute)
		try container.encode(second, forKey: .second)
	}
}

extension Time: CustomStringConvertible {

	public var description: String {
		String(format: "%02d:%02d:%02d", hour, minute, second)
	}

	public var description12HourClock: String {
		let (hour12, isAM) = self.hour12
		return String(format: "%02d:%02d:%02d\(symbol(isAM: isAM))", hour12, minute, second)
	}
}
