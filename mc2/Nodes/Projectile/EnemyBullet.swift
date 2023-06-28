//
//  EnemyBullet.swift
//  mc2
//
//  Created by Ardli Fadhillah on 22/06/23.
//

import SpriteKit

class EnemyBullet: Projectile, HandleContactEnter {
    var playerNode: Player? = nil
    var slowDownMoveSpeedMultiplier = 0.25
    var normalMoveSpeedMultiplier = 1.0
    
    override var moveDirection: CGPoint {
        if let playerNode {
            return (playerNode.position - self.position).normalized()
        }
        else {
            return CGPoint.zero
        }
    }
    
    override func spawn(in scene: SKScene) {
        self.playerNode = scene.childNode(withName: "hunter") as? Player
        self.moveSpeed = 600.0
        if PowerupManager.shared.slowMoPowerupActive {
            self.moveSpeedMultiplier = slowDownMoveSpeedMultiplier
        }
        
        super.spawn(in: scene)
        
        self.name = "enemyBullet"
        self.size = CGSize(width: 15, height: 15)
        self.color = .purple        
        
        self.physicsBody?.categoryBitMask = PsxBitmask.enemyBullet
        self.physicsBody?.contactTestBitMask |= PsxBitmask.player
        
        PowerupManager.shared.slowMoPowerupStarted.subscribe(node: self, closure: slowDownMoveSpeed)
        PowerupManager.shared.slowMoPowerupStopped.subscribe(node: self, closure: normalizeMoveSpeed)
    }
    
    func slowDownMoveSpeed(){
        moveSpeedMultiplier = slowDownMoveSpeedMultiplier
        updateVelocity()
    }
    
    func normalizeMoveSpeed(){
        moveSpeedMultiplier = normalMoveSpeedMultiplier
        updateVelocity()
    }
    
    func onContactEnter(with other: SKNode?) {
        if other is Obstacle {
            touchingObstacle()
        } else if other is Player {
            touchingPlayer(player: other as! Player)
        }
    }
    func touchingObstacle() {
        self.destroy()
    }
    func touchingPlayer(player: Player) {
        player.decreaseHealth(amount: self.damage)
        self.destroy()
    }
    
    override func destroy() {
        PowerupManager.shared.slowMoPowerupStarted.unsubscribe(node: self)
        PowerupManager.shared.slowMoPowerupStopped.unsubscribe(node: self)
        
        super.destroy()
    }
}
