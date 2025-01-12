//
//  RubberBand.swift
//  FluidInterpolation
//
//  Created by 秋星桥 on 2025/1/12.
//

import Foundation

func calculateOffset(offset: Float, range: Float) -> Float {
    if offset < 0 || range <= 0 {
        return 0
    }
    return (1 - (1 / (offset / range * RUBBER_BAND_COEFFICIENT + 1))) * range
}

func calculateOffsetInv(offset: Float, range: Float) -> Float {
    if offset < 0 || range < 0 {
        return 0
    }
    // The offset and range cannot be equal.
    // Offset only approaches range infinitely.
    //
    // To ensure valid calculation, we set the maximum value of offset slightly smaller than range.
    let offset = min(offset, range - 1e-5)
    return range * offset / (range - offset) / RUBBER_BAND_COEFFICIENT
}
