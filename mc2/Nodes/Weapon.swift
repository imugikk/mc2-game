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
        handleRotationInput()
        handleZPosBasedOnRotation()
    }
    
    func handleRotationInput() {
        let input = InputManager.shared.getRightJoystickInput(controllerIndex: 0)
        let angle = atan2(input.y, input.x)
        
        if input.length() >= minJoystickInputForRotation {
            let rotationOffset = CGFloat(90.0).toRadians()
            self.zRotation = angle - rotationOffset
        }
    }
    
    func handleZPosBasedOnRotation() {
        let minRotation = CGFloat(-90.0).toRadians()
        let maxRotation = CGFloat(89.0).toRadians()
        
        if self.zRotation >= minRotation && self.zRotation <= maxRotation {
            self.zPosition = -1
        } else {
            self.zPosition = 1
        }
    }
    
}
