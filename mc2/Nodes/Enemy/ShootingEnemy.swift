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
    var canShoot = true
    
    override func spawn(in scene: SKScene) {
        super.spawn(in: scene)
        
        self.name = "shootingEnemy"
        self.size = CGSize(width: 56.1, height: 25.8)
        self.moveSpeed = 150.0
        self.health = 2
    }
    
    override func update(deltaTime: TimeInterval) {
        super.update(deltaTime: deltaTime)
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
        let movement = moveSpeed * deltaTime * direction
        self.position += movement
    }
    
    func stopAndShoot() {
        guard canShoot else { return }
        canShoot = false
        
        let bulletNode = EnemyBullet()
        bulletNode.position = self.position
        bulletNode.spawn(in: scene!)
        
        scene!.run(SKAction.wait(forDuration: bulletSpawnRate)) {
            self.canShoot = true
        }
    }
}
