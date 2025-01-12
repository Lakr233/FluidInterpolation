//
//  VelocityTracker.swift
//  FluidInterpolation
//
//  Created by 秋星桥 on 2025/1/12.
//

@testable import FluidInterpolation
import Testing

@Test func testVelocityTracker() async throws {
    let tracker = VelocityTracker()
    tracker.addDataPoint(timeMilliseconds: 1.53283, value: 0)
    tracker.addDataPoint(timeMilliseconds: 3.27537, value: 376)
    tracker.addDataPoint(timeMilliseconds: 5.27733, value: 276)
    tracker.addDataPoint(timeMilliseconds: 22.2795, value: 153.5)
    tracker.addDataPoint(timeMilliseconds: 58.22, value: 151.5)
    let velocity = tracker.calculate()
    #expect(abs(velocity + 23.23402596) < 0.001)
}
