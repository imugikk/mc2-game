//
//  EnemyComponent.swift
//  mc2
//
//  Created by Tiffany Angela Indryani on 13/06/23.
//

import SpriteKit

class WalkingEnemy: Enemy {
    
    override func spawn(in scene: SKScene) {
        super.spawn(in: scene)
        
        self.name = "walkingEnemy"
        self.size = CGSize(width: 56.1, height: 25.8)
        self.moveSpeed = 100.0
        self.health = 3
    }
    
    override func update(deltaTime: TimeInterval) {
        super.update(deltaTime: deltaTime)
        guard let playerNode, !playerNode.destroyed else { return }
        
        let direction = (playerNode.position - self.position).normalized()
        let movement = moveSpeed * deltaTime * direction
        self.position += movement
    }
    
    
}
