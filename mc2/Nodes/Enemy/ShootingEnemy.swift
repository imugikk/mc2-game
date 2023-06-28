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
        let textures = [
            SKTexture(imageNamed: "Enemy_Skool_1"),
            SKTexture(imageNamed: "Enemy_Skool_2"),
            SKTexture(imageNamed: "Enemy_Skool_3")
        ]
        self.texture = textures.first
        self.run(SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.1)))
        
        self.size = CGSize(width: 69, height: 33.5)
        self.color = .white
        self.moveSpeed = 150.0
        self.health = 2
    }
    
    override func update(deltaTime: TimeInterval) {
        super.update(deltaTime: deltaTime)
        guard let playerNode, !playerNode.destroyed else { return }
        
        let offset = playerNode.position - self.position
        let length = offset.length()
        let isInside = insideScreen()
        
        if length > shootingRange || !isInside{
            chasePlayer(offset, deltaTime)
        } else {
            stopAndShoot()
        }
        
        if offset.normalized().x < 0 {
            self.xScale = -1
        } else {
            self.xScale = 1
        }
    }
    
    func insideScreen() -> Bool {
        let objectHalfWidth = size.width / 2
        let objectHalfHeight = size.height / 2
        
        let minX = -screenWidth / 2 + objectHalfWidth
        let maxX = screenWidth / 2 - objectHalfWidth
        let minY = -screenHeight / 2 + objectHalfHeight
        let maxY = screenHeight / 2 - objectHalfHeight
        
        if position.x > minX && position.x < maxX && position.y > minY && position.y < maxY {
            return true
        }
        
        return false
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
