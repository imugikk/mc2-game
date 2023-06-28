//
//  Obstacle.swift
//  mc2
//
//  Created by Ardli Fadhillah on 22/06/23.
//

import SpriteKit

class Obstacle: SKSpriteNode, PreSpawned {
    func setup() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PsxBitmask.obstacle
        self.physicsBody?.collisionBitMask = PsxBitmask.player | PsxBitmask.enemy
        self.physicsBody?.contactTestBitMask = PsxBitmask.bullet | PsxBitmask.enemyBullet
    }
}
