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
    let targetEntity: GKEntity
    let speed: CGFloat = 150.0
    let scene: SKScene
    var health: Int
    
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
            
            node.position = CGPoint(x: node.position.x + velocity.dx, y: node.position.y + velocity.dy)
        }
    }
    
    func takeDamage(amount: Int) {
        
        if health <= 0 {
            return
        }
        
        health -= amount
        print(health)
        
        if health <= 0 {
            dropItem()
        }
    }
    
    private func destroyEnemy() {
        // Implement enemy destruction logic here
        node.removeFromParent()
    }
    
    func dropItem(){
        let itemNode = SKSpriteNode(color: .green, size: CGSize(width: 30, height: 30))
        let itemEntity = GKEntity()
        let itemComponent = ItemComponent(node: itemNode)
        itemEntity.addComponent(itemComponent)
        scene.addChild(itemNode)
        
        itemNode.position = node.position
        
        destroyEnemy()
    }
}
