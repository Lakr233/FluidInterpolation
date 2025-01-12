//
//  Result.swift
//  FluidInterpolation
//
//  Created by 秋星桥 on 2025/1/12.
//

import Foundation

extension Result where Failure == Error {
    @inline(__always)
    static func failure(_ text: String) -> Self {
        let error: Error = NSError(
            domain: "FluidInterpolation",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: text]
        )
        return .failure(error)
    }
}
