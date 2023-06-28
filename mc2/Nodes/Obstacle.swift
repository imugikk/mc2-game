//
//  Obstacle.swift
//  mc2
//
//  Created by Ardli Fadhillah on 22/06/23.
//

import SpriteKit

class Obstacle: SKSpriteNode, PreSpawned {
    func setup() {
        self.physicsBody?.categoryBitMask = PsxBitmask.obstacle
        self.physicsBody?.collisionBitMask = PsxBitmask.player
        self.physicsBody?.contactTestBitMask = PsxBitmask.bullet
    }
}
