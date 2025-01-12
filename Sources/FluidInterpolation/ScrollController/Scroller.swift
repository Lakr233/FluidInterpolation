//
//  Scroller.swift
//  FluidInterpolation
//
//  Created by 秋星桥 on 2025/1/12.
//

import Foundation

// Copyright 2023 ktiays
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Deceleration rates for the scroll animation.
//
// You can create a deceleration rate with the specified raw value.
// The raw value should be in the range of 0.0 to 1.0 (exclusive).

open class Scroller {
    public enum DecelerationRate: Float {
        case fast = 0.998
        case normal = 0.99
    }

    open var decelerationRate: Float = DecelerationRate.normal.rawValue
    open var initialVelocity: Float = 0

    public struct Value {
        let offset: Float
        let velocity: Float
    }

    public init() {}

    open func set(decelerationRate: DecelerationRate) {
        self.decelerationRate = decelerationRate.rawValue
    }

    open func value(at time: Float) -> Value? {
        let rate = decelerationRate
        let coefficient = powf(rate, time)
        let velocity = initialVelocity * coefficient
        let offset = initialVelocity * (1.0 / logf(rate)) * (coefficient - 1.0)

        if abs(velocity) < VELOCITY_THRESHOLD {
            return nil
        }

        return Value(offset: offset, velocity: velocity)
    }

    @discardableResult
    open func reset() -> Self {
        initialVelocity = 0
        decelerationRate = DecelerationRate.normal.rawValue
        return self
    }
}
