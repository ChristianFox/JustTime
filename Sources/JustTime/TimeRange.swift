import Foundation

/// Represents a range between two points in time
public struct TimeRange {

	// ------------------------------------
	// MARK: Properties
	// ------------------------------------
	// # Public/Internal/Open
	/// The start time of the range
	public var start: Time

	/// The end time of the range
	public var end: Time

	/// The distance between the `start` and `end` Times
	public var duration: Duration {
		start.duration(tillLaterTime: end)
	}

	/// A Boolean value indicating whether the range contains no elements.
	///
	/// An empty `TimeRange` instance has equal start and end times.
	@inlinable public var isEmpty: Bool {
		start == end
	}

	// ------------------------------------
	// MARK: Init
	// ------------------------------------
	/// Initialise a TimeRange instance describing the range from the `start` to `end`.
	///
	/// The start time can be lower or higher than the end time. If start time is higher than end time the will be treated as spanning across two different days with the end time occuring the day after the day of the start time.
	///
	/// - Parameters:
	///   - start: The start Time
	///   - end: The end Time
	public init(start: Time, end: Time) {
		self.start = start
		self.end = end
	}

	// =======================================
	// MARK: Public Methods
	// =======================================
	/// Returns a Boolean value indicating whether the given time is contained
	/// within the range.
	///
	/// Because `TimeRange` represents a half-open range, a `Range` instance does not
	/// contain its upper bound. `time` is contained in the range if it is
	/// greater than or equal to the lower bound and less than the upper bound.
	///
	/// - Parameter time: The time to check for containment.
	/// - Returns: `true` if `element` is contained in the range; otherwise,
	///   `false`.
	@inlinable public func contains(_ time: Time) -> Bool {
		if start < end {
			return time >= start && time < end
		} else {
			return time >= start || time < end
		}
	}

	/// Returns a Boolean value indicating whether this range and the given range
	/// contain an element in common.
	///
	/// - Parameter other: A range to check for time elements in common.
	/// - Returns: `true` if this range and `other` have at least one element in
	///   common; otherwise, `false`.
	@inlinable public func overlaps(_ other: TimeRange) -> Bool {
		contains(other.start) || contains(other.end)
		|| other.contains(start) || other.contains(end)
	}

	public func split(by minutes: UInt) -> [TimeRange] {

		let intervalInSeconds = Int(minutes) * 60

		var startTime = start
		var endTime = startTime.adding(TimeInterval(intervalInSeconds))
		var ranges = [TimeRange(start: startTime, end: endTime)]

		while endTime < end {
			startTime = endTime
			endTime = startTime.adding(TimeInterval(intervalInSeconds))
			let range = TimeRange(start: startTime, end: endTime)
			ranges.append(range)
		}

		// adjust the last range's end time to match the original end time
		if let lastRange = ranges.last {
			ranges[ranges.count - 1] = TimeRange(start: lastRange.start, end: end)
		}

		return ranges
	}
}

extension TimeRange: Equatable {

	public static func == (lhs: TimeRange, rhs: TimeRange) -> Bool {
		lhs.start == rhs.start && lhs.end == rhs.end
	}
}

extension TimeRange: Codable { }

extension TimeRange: CustomStringConvertible {

	public var description: String {
		"\(start.description) - \(end.description)"
	}

	public var description12HourClock: String {
		"\(start.description12HourClock) - \(end.description12HourClock)"
	}
}
