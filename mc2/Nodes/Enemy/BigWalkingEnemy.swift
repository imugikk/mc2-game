//
//  EnemyComponent.swift
//  mc2
//
//  Created by Tiffany Angela Indryani on 13/06/23.
//

import SpriteKit

class BigWalkingEnemy: Enemy {
    
    override func spawn(in scene: SKScene) {
        super.spawn(in: scene)
        
        self.name = "walkingEnemy"
        let textures = [
            SKTexture(imageNamed: "Enemy_G"),
            SKTexture(imageNamed: "Enemy_G1"),
            SKTexture(imageNamed: "Enemy_G2"),
            SKTexture(imageNamed: "Enemy_G3")
        ]
        self.texture = textures.first
        self.run(SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.1)))
        
        self.texture = SKTexture(imageNamed: "Enemy_G")
        self.color = .white
        self.size = CGSize(width: 56, height: 96.5)
        self.moveSpeed = 50.0
        self.health = 5
        self.ingredientType = .yellow
    }
    
    override func update(deltaTime: TimeInterval) {
        super.update(deltaTime: deltaTime)
        guard let playerNode, !playerNode.destroyed else { return }
        
        let direction = (playerNode.position - self.position).normalized()
        let movement = moveSpeed * deltaTime * direction * moveSpeedMultiplier
        self.position += movement
        
        if direction.x < 0 {
            self.xScale = -1
        } else {
            self.xScale = 1
        }
    }
}
