//
//  Player.swift
//  mc2
//
//  Created by Ardli Fadhillah on 13/06/23.
//

import SpriteKit

class Player: SKSpriteNode {
    
    let moveSpeed = 200.0
    
    func movement(hInput: Double, vInput: Double, deltaTime: Double) {
        let direction = CGPoint(x: hInput, y: vInput).normalized()
        let movement = moveSpeed * deltaTime * direction
        self.position += movement
    }
}
