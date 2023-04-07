//
//  Clamping.swift
//
//
//  Created by Guillermo Muntaner Perelló on 25/06/2019.
//
/*
 Copyright 2019 Guillermo Muntaner

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

/// A property wrapper that automatically clamps its wrapped value in a range.
///
/// ```
/// @Clamping(range: 0...1)
/// var alpha: Double = 0.0
///
/// alpha = 2.5
/// print(alpha) // 1.0
///
/// alpha = -1.0
/// print(alpha) // 0.0
/// ```
///
/// - Note: Using a Type whose capacity fits your range should always be prefered to using this wrapper; e.g. you can use an UInt8 for 0-255 values.
///
/// [Swift Evolution Proposal example](https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md#clamping-a-value-within-bounds)
/// [NSHisper article](https://nshipster.com/propertywrapper/)
@propertyWrapper
public struct Clamping<Value: Comparable> {
	var value: Value
	let range: ClosedRange<Value>

	public init(wrappedValue: Value, range: ClosedRange<Value>) {
		self.range = range
		self.value = range.clamp(wrappedValue)
	}

	public var wrappedValue: Value {
		get { value }
		set { value = range.clamp(newValue) }
	}
}

fileprivate extension ClosedRange {
	func clamp(_ value : Bound) -> Bound {
		return self.lowerBound > value ? self.lowerBound
			: self.upperBound < value ? self.upperBound
			: value
	}
}
