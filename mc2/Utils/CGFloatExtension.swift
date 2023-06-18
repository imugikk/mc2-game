//
//  CGFloatExtension.swift
//  mc2
//
//  Created by Ardli Fadhillah on 17/06/23.
//

import Foundation

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * .pi / 180.0
    }
}
