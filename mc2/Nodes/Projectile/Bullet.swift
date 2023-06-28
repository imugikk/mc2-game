//
//  Bullet.swift
//  mc2
//
//  Created by Ardli Fadhillah on 15/06/23.
//

import SpriteKit

class Bullet: Projectile, HandleContactEnter {
    
    override var moveDirection: CGPoint {
        CGPoint(x: cos(zRotation), y: sin(zRotation))
    }
    
    override func spawn(in scene: SKScene) {
        super.spawn(in: scene)
        
        self.name = "bullet"
        self.setScale(1.25)
        
        self.physicsBody?.categoryBitMask = PsxBitmask.bullet
        self.physicsBody?.contactTestBitMask |= PsxBitmask.enemy
        
        if PowerupManager.shared.damagePowerupActive {
            self.damage = 3
        }
    }
    
    func onContactEnter(with other: SKNode?) {
        if other is Obstacle {
            touchingObstacle()
        } else if other is Enemy {
            touchingEnemy(enemy: other as! Enemy)
        }
    }
    
    func touchingObstacle() {
        self.destroy()
    }
    func touchingEnemy(enemy: Enemy) {
        self.destroy()
        enemy.decreaseHealth(amount: self.damage)
    }
}
