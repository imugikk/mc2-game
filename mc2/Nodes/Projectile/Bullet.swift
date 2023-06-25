//
//  Bullet.swift
//  mc2
//
//  Created by Ardli Fadhillah on 15/06/23.
//

import SpriteKit

class Bullet: Projectile {
    
    override var moveDirection: CGPoint {
        CGPoint(x: cos(zRotation), y: sin(zRotation))
    }
    
    override func spawn(in scene: SKScene) {
        super.spawn(in: scene)
        
        self.name = "bullet"
        self.setScale(1.25)
        
        self.physicsBody?.categoryBitMask = PsxBitmask.bullet
        self.physicsBody?.contactTestBitMask = PsxBitmask.obstacle | PsxBitmask.enemy
    }
}
