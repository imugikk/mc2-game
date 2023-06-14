//
//  WeaponRotation.swift
//  mc2
//
//  Created by Ardli Fadhillah on 14/06/23.
//

import SpriteKit

class Weapon: SKSpriteNode {
    func rotate(followPos: CGPoint) {
        let offset = followPos - position
        let angle = atan2(offset.y, offset.x)
        if followPos.length() >= 0.5 {
            self.zRotation = angle
        }
        
        if self.zRotation >= 0 && self.zRotation <= 179 {
            self.zPosition = -1
        }
        else {
            self.zPosition = 1
        }
    }
}
