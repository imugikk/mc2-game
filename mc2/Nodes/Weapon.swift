//
//  WeaponRotation.swift
//  mc2
//
//  Created by Ardli Fadhillah on 14/06/23.
//

import Foundation
import SpriteKit

class Weapon: SKSpriteNode {
    let minJoystickInputForRotation = 0.5
    
    func update(deltaTime: Double) {
        let offset = InputManager.shared.getRightJoystickInput(controllerIndex: 0)
        let angle = atan2(offset.y, offset.x)
        if offset.length() >= minJoystickInputForRotation {
            let degreesOffset: CGFloat = 90.0
            self.zRotation = angle - degreesOffset.toRadians()
        }
        
        if self.zRotation >= CGFloat(-90.0).toRadians() &&
            self.zRotation <= CGFloat(89.0).toRadians() {
            self.zPosition = -1
        }
        else {
            self.zPosition = 1
        }
    }
}
