//
//  VelocityTracker.swift
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

open class VelocityTracker {
    open var samples: [DataPoint?]
    open var index: Int
    open var cache: Cache

    public struct DataPoint {
        public var time: Float
        public var value: Float

        public init(time: Float = 0, value: Float = 0) {
            self.time = time
            self.value = value
        }
    }

    public struct Cache {
        public var reusable_values: [Float]
        public var reusable_time: [Float]

        public init(size: Int = HISTORY_SIZE) {
            reusable_values = Array(repeating: 0, count: size)
            reusable_time = Array(repeating: 0, count: size)
        }
    }

    public required init() {
        samples = .init(repeating: nil, count: HISTORY_SIZE)
        index = 0
        cache = Cache()
    }

    /// Adds a data point for velocity calculation at a given time.
    open func addDataPoint(timeMilliseconds: Float, value: Float) {
        let dataPoint = DataPoint(time: timeMilliseconds, value: value)
        index = (index + 1) % HISTORY_SIZE
        samples[index] = dataPoint
    }

    /// Computes the estimated velocity at the time of the last provided data point.
    open func calculate() -> Float {
        assert(samples.count == HISTORY_SIZE)
        assert(cache.reusable_time.count == HISTORY_SIZE)
        assert(cache.reusable_values.count == HISTORY_SIZE)

        var index = index
        var sample_count = 0

        // The sample at index is our newest sample.  If it is null, we have no samples so return.
        guard let newest = samples[index] else { return 0 }
        var cache = cache

        repeat {
            guard let sample = samples[index] else { break }
            let age = newest.time - sample.time
            cache.reusable_values[sample_count] = sample.value
            cache.reusable_time[sample_count] = -age

            // rotate
            index = if index == 0 { HISTORY_SIZE } else { index - 1 }
            sample_count += 1
            if sample_count > HISTORY_SIZE { break }
        } while true

        guard sample_count >= 2 else {
            return 0
        }

        let result = calculateRecurrenceRelationVelocity(
            times: cache.reusable_time.prefix(min(4, sample_count)).reversed(),
            values: cache.reusable_values.prefix(min(4, sample_count)).reversed()
        )
        switch result {
        case let .success(success):
            return success
        case .failure:
//            assertionFailure(failure.localizedDescription)
            return 0
        }
    }

    open func approachingHalt(horizontalVelocity: Float, verticalVelocity: Float) -> Bool {
        horizontalVelocity * horizontalVelocity + verticalVelocity * verticalVelocity < 0.0625
    }

    @discardableResult
    open func reset() -> Self {
        for i in 0 ..< HISTORY_SIZE {
            samples[i] = nil
            cache.reusable_time[i] = 0
            cache.reusable_values[i] = 0
        }
        index = 0
        return self
    }

    open func calculateRecurrenceRelationVelocity(
        times: [Float],
        values: [Float]
    ) -> Result<Float, Error> {
        guard times.count == values.count else {
            return .failure("The number of times and values must be equal")
        }
        guard times.count >= 2 else {
            return .failure("At least two points must be provided")
        }
        let points = Array(zip(values, times))
        var samples: [Float] = []
        for i in 0 ..< (points.count - 1) {
            let currentPoint = points[i]
            let nextPoint = points[i + 1]
            let deltaTime = nextPoint.1 - currentPoint.1
            // if two points are at the same time, so we can't calculate a velocity.
            // discard this sample.
            guard deltaTime != 0 else { continue }
            let velocity = (nextPoint.0 - currentPoint.0) / deltaTime
            samples.append(velocity)
        }

        guard !samples.isEmpty else {
            return .failure("No valid velocity samples could be calculated")
        }

        if samples.count == 1 { return .success(samples[0]) }

        var previousVelocity: Float?
        var currentVelocity: Float?

        for i in 0 ..< (samples.count - 1) {
            let velocity = samples[i] * 0.4 + samples[i + 1] * 0.6
            if let current = currentVelocity {
                previousVelocity = current
                // weighted average of the velocity with a ratio of 8:2
                // compared to the previous time.
                currentVelocity = current * 0.8 + velocity * 0.2
            } else {
                currentVelocity = velocity
            }
        }

        guard let current = currentVelocity else {
            return .failure("At least one velocity sampling is required")
        }

        if let previousVelocity {
            return .success(previousVelocity * 0.75 + current * 0.25)
        } else {
            return .success(current)
        }
    }
}
