//
//  Constant.swift
//  FluidInterpolation
//
//  Created by 秋星桥 on 2025/1/12.
//

import Foundation

@inline(__always) @usableFromInline
let VELOCITY_THRESHOLD: Float = 1e-2

@inline(__always) @usableFromInline
let VALUE_THRESHOLD: Float = 0.1

@inline(__always) @usableFromInline
let RUBBER_BAND_COEFFICIENT: Float = 0.55

@inline(__always) @usableFromInline
let DEFAULT_RESPONSE: Float = 0.575

@inline(__always) @usableFromInline
let HISTORY_SIZE: Int = 20
