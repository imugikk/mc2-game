//
//  ContactDelegate.swift
//  mc2
//
//  Created by Ardli Fadhillah on 18/06/23.
//

import SpriteKit

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let bit1 = contact.bodyA.categoryBitMask
        let bit2 = contact.bodyB.categoryBitMask
        
        if (bit1 == BitMask.bullet && bit2 == BitMask.obstacle) ||
            (bit1 == BitMask.obstacle && bit2 == BitMask.bullet) {
            let (bulletCollider, obstacleCollider) = (bit1 == BitMask.bullet) ?
                (contact.bodyA, contact.bodyB) : (contact.bodyB, contact.bodyA)

            if let bulletNode = bulletCollider.node as? Bullet,
               let obstacleNode = obstacleCollider.node as? SKSpriteNode {
                bulletTouchesObstacle(bullet: bulletNode, obstacle: obstacleNode)
            }
        }
    }

    func bulletTouchesObstacle(bullet: Bullet, obstacle: SKSpriteNode) {
        bullet.destroy()
    }
}
