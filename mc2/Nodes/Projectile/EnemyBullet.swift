//
//  EnemyBullet.swift
//  mc2
//
//  Created by Ardli Fadhillah on 22/06/23.
//

import SpriteKit

class EnemyBullet: Projectile {
    var playerNode: Player? = nil
    
    override var moveDirection: CGPoint {
        if let playerNode {
            return (playerNode.position - self.position).normalized()
        }
        else {
            return CGPoint.zero
        }
    }
    
    override func spawn(in scene: SKScene) {
        self.playerNode = scene.childNode(withName: "player") as? Player
        self.moveSpeed = 600.0
        
        super.spawn(in: scene)
        
        self.name = "enemyBullet"
        self.size = CGSize(width: 15, height: 15)
        self.color = .purple        
        
        self.physicsBody?.categoryBitMask = PsxBitmask.enemyBullet
        self.physicsBody?.contactTestBitMask = PsxBitmask.player
    }
}
