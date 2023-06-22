//
//  Obstacle.swift
//  mc2
//
//  Created by Ardli Fadhillah on 22/06/23.
//

import SpriteKit

class Obstacle: SKSpriteNode {
    func setup() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = CBitMask.obstacle
        self.physicsBody?.collisionBitMask = CBitMask.player
        self.physicsBody?.contactTestBitMask = CBitMask.bullet
    }
}
