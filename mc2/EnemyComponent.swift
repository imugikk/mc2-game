//
//  EnemyComponent.swift
//  mc2
//
//  Created by Tiffany Angela Indryani on 13/06/23.
//

import Foundation
import GameplayKit

class EnemyComponent: GKComponent {
    let node: SKSpriteNode
    let scene: SKScene
    let targetEntity: GKEntity
    let speed: CGFloat = 200
    let shootingRange: CGFloat = 200.0
    var health: Int
    var isPaused: Bool = false
    private var canShoot: Bool = true
    private var bulletSpawnRate: TimeInterval = 1.0
    
    init(node: SKSpriteNode, targetEntity: GKEntity, scene: SKScene, health: Int) {
        self.node = node
        self.targetEntity = targetEntity
        self.scene = scene
        self.health = health
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime: TimeInterval) {
        if let targetNode = targetEntity.component(ofType: PlayerComponent.self)?.node {
            let direction = CGPoint(x: targetNode.position.x - node.position.x, y: targetNode.position.y - node.position.y)
            let length = sqrt(direction.x * direction.x + direction.y * direction.y)
            let normalizedDirection = CGPoint(x: direction.x / length, y: direction.y / length)

            let velocity = CGVector(dx: normalizedDirection.x * speed * CGFloat(deltaTime), dy: normalizedDirection.y * speed * CGFloat(deltaTime))

            if !isPaused {
                node.position = CGPoint(x: node.position.x + velocity.dx, y: node.position.y + velocity.dy)
            }
            
            // Check if the enemy is close enough to start shooting
            if length <= shootingRange {
                shoot()
                isPaused = true
            } else {
                isPaused = false
            }
        }
    }
    
    func takeDamage(amount: Int) {
        health -= amount
        print(health)
        
        if health <= 0 {
            dropItem()
        }
    }
    
    private func destroyEnemy() {
        isPaused = true
        node.removeFromParent()
    }
    
    func dropItem(){
        let itemNode = SKSpriteNode(color: .green, size: CGSize(width: 30, height: 30))
        let itemEntity = GKEntity()
        let itemComponent = ItemComponent(node: itemNode)
        itemEntity.addComponent(itemComponent)
        if let scene = node.scene {
            scene.addChild(itemNode)
        }
        
        itemNode.position = node.position
        
        destroyEnemy()
    }
    
    private func shoot() {
        if !canShoot {
            return
        }
        
        canShoot = false
        if health <= 0 {
            return
        }
        let bulletNode = SKSpriteNode(color: .yellow, size: CGSize(width: 10, height: 10))
        let bulletEntity = GKEntity()
        let bulletComponent = BulletComponent(node: bulletNode, speed: 300.0)
        bulletEntity.addComponent(bulletComponent)
        scene.addChild(bulletNode)
        
        bulletNode.position = node.position
        
        // Calculate the direction towards the player
        if let playerNode = targetEntity.component(ofType: PlayerComponent.self)?.node {
            let direction = CGPoint(x: playerNode.position.x - node.position.x, y: playerNode.position.y - node.position.y)
            let length = sqrt(direction.x * direction.x + direction.y * direction.y)
            let normalizedDirection = CGPoint(x: direction.x / length, y: direction.y / length)
            
            // Calculate the velocity of the bullet
            let velocity = CGVector(dx: normalizedDirection.x * bulletComponent.speed, dy: normalizedDirection.y * bulletComponent.speed)
            
            // Set the velocity for the bullet component
            let body = SKPhysicsBody(circleOfRadius: 10)
            body.affectedByGravity = false
            bulletComponent.node.physicsBody = body
            bulletComponent.node.physicsBody?.velocity = velocity
            bulletComponent.node.physicsBody?.categoryBitMask = 0x2
            bulletComponent.node.physicsBody?.collisionBitMask = 0
            bulletComponent.node.physicsBody?.contactTestBitMask = 0x1
            
            scene.run(SKAction.wait(forDuration: bulletSpawnRate)) {
                self.canShoot = true
            }
            
        }
    }
}
