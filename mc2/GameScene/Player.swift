//
//  Player.swift
//  mc2
//
//  Created by Ardli Fadhillah on 13/06/23.
//

import SpriteKit

class Player: SKSpriteNode {
    private let moveSpeed = 200.0
    private var health = 3 {
        didSet {
            healthText.text = "HP: \(health)"
        }
    }
    private var healthText: SKLabelNode!
    private var killedAction: (() -> Void)!
    
    func setup(killedAction: @escaping () -> Void) {
        healthText = scene?.childNode(withName: "healthText") as? SKLabelNode
        health = 3
        healthText.text = "HP: \(health)"
        self.killedAction = killedAction
    }
    
    func movement(hInput: Double, vInput: Double, deltaTime: Double) {
        let direction = CGPoint(x: hInput, y: vInput).normalized()
        let movement = moveSpeed * deltaTime * direction
        self.position += movement
    }
    
    func decreaseHealth(damage: Int) {
        guard health > 0 else { return }
        
        health -= damage
        health = max(0, health)
        
        if health == 0 {
            destroy()
        }
    }
    
    func destroy() {
        killedAction()
        removeFromParent()
    }
}
