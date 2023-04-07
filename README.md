[![Latest Version](https://img.shields.io/github/v/tag/ChristianFox/JustTime?sort=semver&label=Version&color=orange)](https://github.com/ChristianFox/JustTime/)
[![Swift](https://img.shields.io/badge/Swift-5.7-orange)](https://img.shields.io/badge/Swift-5.7-orange)
[![Platforms](https://img.shields.io/badge/Platforms-macOS_iOS_tvOS_watchOS_Linux_Windows-orange)](https://img.shields.io/badge/Platforms-macOS_iOS_tvOS_watchOS_Linux_Windows-orange)

[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-yes-green)](https://img.shields.io/badge/Swift_Package_Manager-yes-green)
[![Cocoapods](https://img.shields.io/badge/Cocoapods-no-red)](https://img.shields.io/badge/Cocoapods-no-red)
[![Cathage](https://img.shields.io/badge/Cathage-no-red)](https://img.shields.io/badge/Cathage-no-red)
[![Manually](https://img.shields.io/badge/Manual_Import-yes-green)](https://img.shields.io/badge/Manually_Added-sure-green)

[![CodeCoverage](https://img.shields.io/badge/Code%20Coverage-94.2%25-green)](https://img.shields.io/badge/Code%20Coverage-94.2%25-green)
[![License](https://img.shields.io/badge/license-mit-blue.svg)](https://github.com/ChristianFox/JustTime/blob/master/LICENSE)
[![Contribution](https://img.shields.io/badge/Contributions-Welcome-blue)](https://github.com/ChristianFox/JustTime/labels/contribute)
[![First Timers Friendly](https://img.shields.io/badge/First_Timers-Welcome-blue)](https://github.com/ChristianFox/JustTime/labels/contribute)

[![Size](https://img.shields.io/github/repo-size/ChristianFox/JustTime?color=orange)](https://img.shields.io/github/repo-size/ChristianFox/JustTime?color=orange)
[![Files](https://img.shields.io/github/directory-file-count/ChristianFox/JustTime?color=orange)](https://img.shields.io/github/directory-file-count/ChristianFox/JustTime?color=orange)


# JustTime

JustTime is a lightweight Swift library that provides types for working with time and duration independently of dates. 

## Use Cases
- **Scheduling and planning**: JustTime can be used to manage scheduling for events, appointments, or meetings by checking for time overlaps, containment within specific time ranges, or splitting time ranges into smaller slots.
- **Resource allocation**: JustTime can help allocate resources based on time, such as booking systems for rooms, equipment, or services.
- **Time-based calculations**: JustTime makes it easy to perform time-based calculations for tasks like measuring the duration of activities, determining time intervals between events, or calculating overtime hours.
- **Time formatting**: JustTime provides convenient ways to format time values on both 12-hour and 24-hour clocks, making it easy to display and manipulate time values according to user preferences.

## Types

The library consists of three main types: Time, TimeRange and Duration. 

- **Time**: This struct represents a single point in a 24-hour day
- **TimeRange**: This struct represents a range between two points in time
- **Duration**: This struct represents a length of time unconstrained by a 24 hour clock.

## Features

- Time representation on a 24-hour clock
- Time representation on a 12-hour clock with AM/PM symbols
- Initialisation from Date objects
- Arithmetic operations (addition and subtraction) with TimeInterval
- Duration calculations between two Time instances
- Time rounding to the nearest specified minutes
- TimeRange support with containment and overlap checks
- A TimeRange can be split into smaller ranges by a set number of minutes
- Time conforms to Equatable, Comparable, Codable and CustomStringConvertible
- TimeRange conforms to Equatable, Codable and CustomStringConvertible
- Duration conforms to Equatable, Comparable, Codable and CustomStringConvertible
- Swift Package Manager support

## Tests

The library is almost fully tested with 94.2% code coverage

## Installation

### Swift Package Manager
To add JustTime to your project using Swift Package Manager, add the following dependency in your Package.swift file:

```swift
dependencies: [
    .package(url: "https://github.com/ChristianFox/JustTime.git", from: "1.0.0")
]
```

Don't forget to add JustTime to your target dependencies:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["JustTime"]),
]
```

## Usage

### Time

Create a new Time instance:

```swift
let time = Time(hour: 14, minute: 30, second: 45) // 14:30:45
let midnight = Time() // 00:00:00

```

Create a Time instance from a Date:

```swift
let now = Date()
let currentTime = try Time(fromDate: now)
```

Round a Time instance to a number of minutes:

```swift
let time = Time(hour: 14, minute: 20)
let newTime = time.roundedToNearest(minutes: 30) // 14:30
```

Add a TimeInterval to a Time instance:

```swift
let time = Time(hour: 14, minute: 30)
let newTime = time.adding(3600) // Adds 1 hour, 15:30
```

Subtract a TimeInterval from a Time instance:

```swift
let time = Time(hour: 14, minute: 30)
let newTime = time.subtracting(3600) // Subtracts 1 hour, 13:30
```

Calculate the duration between a Time instance and a later time:

```swift
let startTime = Time(hour: 9, minute: 0)
let endTime = Time(hour: 17, minute: 0)
let duration = startTime.duration(tillLaterTime: endTime) // Duration of 8 hours
```

If we call the function with a "later time" which has a lower value than the receiver, the declaration that the argument is later than the receiver is considered to be the truth and therefore `timeB` must represent a time on the previous day, the result is then 16 hours.

```swift
let timeA = Time(hour: 9, minute: 0)
let timeB = Time(hour: 17, minute: 0)
let duration = timeB(tillLaterTime: timeA) // Duration of 16 hours
```

### TimeRange

Create a new TimeRange instance:

```swift
let workHours = TimeRange(start: Time(hour: 9), end: Time(hour: 17))
```

Check if a Time instance is contained within a TimeRange:

```swift
let time = Time(hour: 12)
let isWithinRange = workHours.contains(time) // true
```

Check if two TimeRange instances overlap:

```swift
let lunchBreak = TimeRange(start: Time(hour: 12), end: Time(hour: 13))
let meeting = TimeRange(start: Time(hour: 11, minute: 30), end: Time(hour: 12, minute: 30))
let hasOverlap = lunchBreak.overlaps(meeting) // true
```

Split a TimeRange into smaller TimeRanges:

```swift
let workHours = TimeRange(start: Time(hour: 9), end: Time(hour: 17))
let hourlySlots = workHour.split(by: 60) // An array of 8 TimeRanges
```

### Duration

Create a new Duration:

```swift
let duration = Duration(hours: 1, minutes: 1, seconds: 1) // 01:01:01
let zero = Duration() // 00:00:00
let normalised = Duration(hours: 0, minutes: 175, seconds: 300) // 03:00:00
```

Add a Duration to another:

```swift
let a = Duration(hours: 1, minutes: 1, seconds: 1)
let b = Duration(hours: 10, minutes: 10, seconds: 10)
let c = a + b // 11:11:11
```

Subtract a Duration from another:

```swift
let a = Duration(hours: 100, minutes: 30, seconds: 20)
let b = Duration(hours: 10, minutes: 10, seconds: 10)
let c = b - a // 90:20:10
```

## Contributing

Pull requests are welcome. I welcome developers of all skill levels to help improve the library, fix bugs, or add new features. 

For major changes, please open an issue first to discuss what you would like to change.

Before submitting a pull request, please ensure that your code adheres to the existing code style and conventions, and that all tests pass. Additionally, if you're adding new functionality, please make sure to include unit tests to verify the behavior.

If you have any questions or need assistance, feel free to open an issue, and I'll do my best to help you out. 

## License

JustTime is released under the MIT License.


