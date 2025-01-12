//
//  RubberBand.swift
//  FluidInterpolation
//
//  Created by 秋星桥 on 2025/1/12.
//

@testable import FluidInterpolation
import Testing

@Test func testRubberBand() async throws {
    let origin: Float = 201
    let range: Float = 600
    let offset: Float = calculateOffset(offset: origin, range: range)
    let inv = calculateOffsetInv(offset: offset, range: range)
    #expect(abs(origin - inv) < 1e-2)
}
