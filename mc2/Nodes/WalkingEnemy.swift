//
//  EnemyComponent.swift
//  mc2
//
//  Created by Tiffany Angela Indryani on 13/06/23.
//

import SpriteKit

class WalkingEnemy: Enemy {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(in scene: SKScene, playerNode: Player) {
        super.init(imageName: "Capsule", in: scene, playerNode: playerNode)
        
        enemyName = "walkingEnemy"
        spriteSize = (width: 56.1, height: 25.8)
        moveSpeed = 100.0
        health = 3
    }
    
    override func update(deltaTime: Double) {
        if destroyed { return }
        guard let playerNode, !playerNode.destroyed else { return }
        
        let direction = (playerNode.position - self.position).normalized()
        let movement = moveSpeed * deltaTime * direction
        self.position += movement
    }
}
