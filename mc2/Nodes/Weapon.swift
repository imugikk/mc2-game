//
//  WeaponRotation.swift
//  mc2
//
//  Created by Ardli Fadhillah on 14/06/23.
//

import Foundation
import SpriteKit

class Weapon: SKSpriteNode, Processable, PreSpawned {
    var inputIndex = 0
    let minJoystickInputForRotation = 0.5
    
    func setup() {
        self.inputIndex = getUserData(key: "inputIndex")
        
        InputManager.buttonXPressed.subscribe(node: self, closure: {
            self.inputIndex = 1 - self.inputIndex
        })
    }
    
    func update(deltaTime: TimeInterval) {
        handleRotationInput()
        handleZPosBasedOnRotation()
    }
    
    func handleRotationInput() {
        let input = InputManager.shared.getRightJoystickInput(controllerIndex: inputIndex)
        let angle = atan2(input.y, input.x)
        
        if input.length() >= minJoystickInputForRotation {
            self.zRotation = angle
        }
    }
    
    func handleZPosBasedOnRotation() {
        let minRotation = 1.0
        let maxRotation = 179.0
        
        if self.zRotationInDegrees >= minRotation &&
            self.zRotationInDegrees <= maxRotation {
            self.zPosition = -1
        } else {
            self.zPosition = 1
        }
    }
}
