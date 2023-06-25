//
//  CGFloatExtension.swift
//  mc2
//
//  Created by Ardli Fadhillah on 17/06/23.
//

import Foundation

extension CGFloat {
    func toDegrees() -> Double {
        return self / .pi * 180.0
    }
    func toRadians() -> Double {
        return self * .pi / 180.0
    }
}

extension Double {
    func toRadians() -> Double {
        return self * .pi / 180.0
    }
}
