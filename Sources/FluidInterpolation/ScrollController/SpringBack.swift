//
//  SpringBack.swift
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

open class SpringBack {
    open var lambda: Float = 0
    open var c1: Float = 0
    open var c2: Float = 0

    public required init() {}

    @discardableResult open func set(lambda: Float) -> Self {
        self.lambda = lambda
        return self
    }

    @discardableResult open func set(c1: Float) -> Self {
        self.c1 = c1
        return self
    }

    @discardableResult open func set(c2: Float) -> Self {
        self.c2 = c2
        return self
    }

    open func absorb(velocity: Float, distance: Float) {
        absorbWithResponse(velocity: velocity, distance: distance, response: DEFAULT_RESPONSE)
    }

    open func absorbWithResponse(velocity: Float, distance: Float, response: Float) {
        lambda = 2 * Float.pi / response
        c1 = distance
        // The formula needs to be calculated in units of points per second.
        c2 = velocity * 1e3 + lambda * distance
    }

    open func value(time: Float) -> Float? {
        // Convert time from milliseconds to seconds.
        let time = time / 1e3
        let offset = (c1 + c2 * time) * exp(-lambda * time)

        let velocity = velocityAt(time: time)
        // The velocity threshold is in units of points per millisecond.
        // We need to convert velocity to match the unit.
        if abs(offset) < VALUE_THRESHOLD, abs(velocity) / 1e3 < VELOCITY_THRESHOLD {
            return nil
        } else {
            return offset
        }
    }

    open func velocityAt(time: Float) -> Float {
        (c2 - lambda * (c1 + c2 * time)) * exp(-lambda * time)
    }

    @discardableResult
    open func reset() -> Self {
        lambda = 0
        c1 = 0
        c2 = 0
        return self
    }
}
