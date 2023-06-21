//
//  Bullet.swift
//  mc2
//
//  Created by Ardli Fadhillah on 15/06/23.
//

import SpriteKit

class Bullet: SKSpriteNode {
    var screenHeight: Double { scene!.frame.size.height }
    var screenWidth: Double { scene!.frame.size.width }
    
    let bulletName = "bullet"
    let bulletSize = (width: 25, height: 25)
    let moveSpeed = 400.0
    var destroyed = false
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    init(imageNamed name: String, in scene: SKScene) {
        let texture = SKTexture(imageNamed: name)
        super.init(texture: texture, color: .white, size: texture.size())
        scene.addChild(self)
        
        self.name = bulletName
        self.size = CGSize(width: bulletSize.width, height: bulletSize.height)
        colorBlendFactor = 1
        color = .systemPink
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = CBitMask.bullet
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = CBitMask.obstacle | CBitMask.enemy
    }
    
    func update(deltaTime: Double) {
        if destroyed { return }
        
        let direction = CGPoint(x: cos(zRotation), y: sin(zRotation))
        let movement = moveSpeed * deltaTime * direction
        self.position += movement
        
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
