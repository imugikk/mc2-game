//
//  EnemyBullet.swift
//  mc2
//
//  Created by Ardli Fadhillah on 22/06/23.
//

import SpriteKit

class EnemyBullet: SKSpriteNode, Processable {
    var screenHeight: Double { scene!.frame.size.height }
    var screenWidth: Double { scene!.frame.size.width }
    
    let bulletName = "enemyBullet"
    let bulletSize = (width: 15, height: 15)
    let moveSpeed = 300.0
    let bulletColor = NSColor.purple
    var destroyed = false
    let playerNode: Player?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    init(in scene: SKScene, playerNode: Player) {
        self.playerNode = playerNode
        
        let texture = SKTexture(imageNamed: "Circle")
        super.init(texture: texture, color: .white, size: texture.size())
        scene.addChild(self)
        
        self.name = bulletName
        self.size = CGSize(width: bulletSize.width, height: bulletSize.height)
        colorBlendFactor = 1
        color = bulletColor
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = CBitMask.enemyBullet
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = CBitMask.player
    }
    
    func setup() {
        if let playerNode {
            let direction = (playerNode.position - self.position).normalized()
            let velocity = direction * moveSpeed
            
            self.physicsBody?.velocity = CGVector(dx: velocity.x, dy: velocity.y)
        }
    }
    
    func update(deltaTime: Double) {
        if destroyed { return }

        if abs(self.position.y) >= screenHeight/2 + self.size.height ||
            abs(self.position.x) >= screenWidth/2 + self.size.width {
            destroy()
        }
    }
    
    func destroy() {
        destroyed = true
        self.removeFromParent()
    }
}