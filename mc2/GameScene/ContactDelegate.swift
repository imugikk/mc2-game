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
        
        if (bit1 == CBitMask.bullet && bit2 == CBitMask.obstacle) ||
            (bit1 == CBitMask.obstacle && bit2 == CBitMask.bullet) {
            let (bulletCollider, obstacleCollider) = (bit1 == CBitMask.bullet) ?
                (contact.bodyA, contact.bodyB) : (contact.bodyB, contact.bodyA)

            if let bulletNode = bulletCollider.node as? Bullet,
               let obstacleNode = obstacleCollider.node as? SKSpriteNode {
                bulletTouchesObstacle(bullet: bulletNode, obstacle: obstacleNode)
            }
        }
        
        if (bit1 == CBitMask.bullet && bit2 == CBitMask.enemy) ||
            (bit1 == CBitMask.enemy && bit2 == CBitMask.bullet) {
            let (bulletCollider, enemyCollider) = (bit1 == CBitMask.bullet) ?
                (contact.bodyA, contact.bodyB) : (contact.bodyB, contact.bodyA)

            if let bulletNode = bulletCollider.node as? Bullet,
               let enemyNode = enemyCollider.node as? WalkingEnemy {
                bulletTouchesEnemy(bullet: bulletNode, enemy: enemyNode)
            }
        }
        
        if (bit1 == CBitMask.player && bit2 == CBitMask.enemy) ||
            (bit1 == CBitMask.enemy && bit2 == CBitMask.player) {
            let (playerCollider, enemyCollider) = (bit1 == CBitMask.player) ?
                (contact.bodyA, contact.bodyB) : (contact.bodyB, contact.bodyA)

            if let playerNode = playerCollider.node as? Player,
               let enemyNode = enemyCollider.node as? WalkingEnemy {
                playerTouchesEnemy(player: playerNode, enemy: enemyNode)
            }
        }
    }

    func bulletTouchesObstacle(bullet: Bullet, obstacle: SKSpriteNode) {
        bullet.destroy()
    }
    func bulletTouchesEnemy(bullet: Bullet, enemy: WalkingEnemy) {
        bullet.destroy()
        enemy.decreaseHealth(amount: 1)
    }
    func playerTouchesEnemy(player: Player, enemy: WalkingEnemy) {
        player.decreaseHealth(amount: 1)
    }
}
