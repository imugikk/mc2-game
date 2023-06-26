//
//  EnemyComponent.swift
//  mc2
//
//  Created by Tiffany Angela Indryani on 13/06/23.
//

import SpriteKit

class ShootingEnemy: Enemy {
    let shootingRange = 300.0
    let bulletSpawnRate = 2.5
    let bulletSpeed = 300.0
    var canShoot = true
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(in scene: SKScene, playerNode: Player) {
        super.init(imageName: "Capsule", in: scene, playerNode: playerNode)
        
        enemyName = "shootingEnemy"
        spriteSize = (width: 56.1, height: 25.8)
        moveSpeed = 200.0
        health = 2
    }
    
    override func update(deltaTime: TimeInterval) {
        guard !self.destroyed else { return }
        guard let playerNode, !playerNode.destroyed else { return }
        
        let offset = playerNode.position - self.position
        let length = offset.length()
        
        if length > shootingRange {
            chasePlayer(offset, deltaTime)
        } else {
            stopAndShoot()
        }
    }
    
    func chasePlayer(_ offset: CGPoint, _ deltaTime: TimeInterval) {
        let direction = offset.normalized()
        let movement = moveSpeed * moveSpeedMultiplier * deltaTime * direction
        self.position += movement
    }
    
    private func stopAndShoot() {
        guard canShoot else { return }
        canShoot = false
        
        let bulletNode = EnemyBullet(in: scene!, playerNode: playerNode!)
        bulletNode.position = self.position
        bulletNode.setup()
        
        scene!.run(SKAction.wait(forDuration: bulletSpawnRate)) {
            self.canShoot = true
        }
    }
}
