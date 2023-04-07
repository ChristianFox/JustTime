import Foundation

public enum TimeNormaliser {

	typealias TimeTuple = (hours: Int, minutes: Int, seconds: Int)

	static func normaliseTime(_ time: TimeTuple, clampHoursTo24: Bool) -> TimeTuple {

		var newSeconds = time.seconds
		var newMinutes = time.minutes
		var newHours = time.hours

		// Normalise seconds to 0-59 range and roll over any excess
		if newSeconds >= 60 {
			newMinutes += newSeconds / 60
			newSeconds %= 60
		} else if newSeconds < 0 {
			newMinutes -= abs(newSeconds) / 60 + 1
			newSeconds = 60 - abs(newSeconds) % 60
			if newMinutes < 0 {
				newHours -= 1
				newMinutes += 60
			}
		}

		// Normalise minutes to 0-59 range and roll over any excess
		if newMinutes >= 60 {
			newHours += newMinutes / 60
			newMinutes %= 60
		} else if newMinutes < 0 {
			newHours -= abs(newMinutes) / 60 + 1
			newMinutes = 60 - abs(newMinutes) % 60
			if newHours < 0 {
				newHours += 24
			}
		}

		if clampHoursTo24 {
			// Normalise hours to 0-23 range and roll over any excess
			if newHours >= 24 {
				newHours %= 24
			} else if newHours < 0 {
				newHours = 24 - abs(newHours) % 24
			}
		}

		return (newHours, newMinutes, newSeconds)
	}
}
