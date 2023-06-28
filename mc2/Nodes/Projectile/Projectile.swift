//
//  Bullet.swift
//  mc2
//
//  Created by Ardli Fadhillah on 15/06/23.
//

import SpriteKit

class Projectile: SKSpriteNode, Processable {
    var moveSpeed = 1800.0
    var damage = 1
    
    var moveDirection: CGPoint {
        CGPoint.zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    init() {
        let texture = SKTexture(imageNamed: "Circle")
        let color: NSColor = .white
        let size = CGSize(width: 25.0, height: 25.0)
        
        super.init(texture: texture, color: color, size: size)
    }
    
    func spawn(in scene: SKScene) {
        scene.addChild(self)
        
        self.name = "projectile"
        self.colorBlendFactor = 1
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.collisionBitMask = 0
        
        let velocity = moveDirection * moveSpeed
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
