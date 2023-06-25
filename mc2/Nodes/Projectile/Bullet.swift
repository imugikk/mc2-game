//
//  Bullet.swift
//  mc2
//
//  Created by Ardli Fadhillah on 15/06/23.
//

import SpriteKit

class Bullet: SKSpriteNode, Processable {    
    let bulletName = "bullet"
    let bulletSize = (width: 25, height: 25)
    let spriteScale = 1.25
    let moveSpeed = 1800.0
    var damage = 1
    let bulletColor = NSColor.systemPink
    
    init() {
        let texture = SKTexture(imageNamed: "Circle")
        super.init(texture: texture, color: .white, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    func spawn(in scene: SKScene) {
        scene.addChild(self)
        
        self.name = bulletName
        self.size = CGSize(width: bulletSize.width, height: bulletSize.height)
        colorBlendFactor = 1
        color = bulletColor
        setScale(spriteScale)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = CBitMask.bullet
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = CBitMask.obstacle | CBitMask.enemy
        
        let direction = CGPoint(x: cos(zRotation), y: sin(zRotation))
        let velocity = direction * moveSpeed
        self.physicsBody?.velocity = CGVector(dx: velocity.x, dy: velocity.y)
    }
    
    func update(deltaTime: TimeInterval) {
        if abs(self.position.y) >= screenHeight/2 + self.size.height ||
            abs(self.position.x) >= screenWidth/2 + self.size.width {
            destroy()
        }
    }
    
    func destroy() {
        self.removeFromParent()
    }
}
