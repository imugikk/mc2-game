//
//  EnemyComponent.swift
//  mc2
//
//  Created by Tiffany Angela Indryani on 13/06/23.
//

import SpriteKit

class WalkingEnemy: SKSpriteNode {
    var screenHeight: Double { scene!.frame.size.height }
    var screenWidth: Double { scene!.frame.size.width }
    
    let enemyName = "walkingEnemy"
    let spriteSize = (width: 56.1, height: 25.8)
    let moveSpeed = 100.0
    var health: Int = 3
    let playerNode: Player?
    var destroyed = false
    static var killedAction = Event()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(imageName: String, in scene: SKScene, playerNode: Player) {
        self.playerNode = playerNode
        
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: .brown, size: texture.size())
        
        self.name = enemyName
        self.size = CGSize(width: spriteSize.width, height: spriteSize.height)
        self.colorBlendFactor = 1
        self.zPosition = -3
        self.zRotation = CGFloat(90).toRadians()
        
        self.physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.1, size: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = CBitMask.enemy
        self.physicsBody?.collisionBitMask = CBitMask.obstacle | CBitMask.enemy
        self.physicsBody?.contactTestBitMask = CBitMask.bullet | CBitMask.player
        
        scene.addChild(self)
        randomizePosition()
    }
    
    private func randomizePosition() {
        let playableRect = frame.insetBy(dx: -screenWidth/2, dy: -screenHeight/2)
        let randomEdge = Int.random(in: 1...4)
        var randomX: CGFloat = 0.0
        var randomY: CGFloat = 0.0
        
        switch randomEdge {
        case 1: // Top edge
            randomX = CGFloat.random(in: playableRect.minX...playableRect.maxX)
            randomY = playableRect.maxY
        case 2: // Bottom edge
            randomX = CGFloat.random(in: playableRect.minX...playableRect.maxX)
            randomY = playableRect.minY
        case 3: // Left edge
            randomX = playableRect.minX
            randomY = CGFloat.random(in: playableRect.minY...playableRect.maxY)
        case 4: // Right edge
            randomX = playableRect.maxX
            randomY = CGFloat.random(in: playableRect.minY...playableRect.maxY)
        default:
            break
        }
        
        self.position = CGPoint(x: randomX, y: randomY)
    }
    
    func update(deltaTime: Double) {
        if destroyed { return }
        guard let playerNode, !playerNode.destroyed else { return }
        
        let direction = (playerNode.position - self.position).normalized()
        let movement = moveSpeed * deltaTime * direction
        self.position += movement
    }

    func decreaseHealth(amount: Int) {
        guard health > 0 else { return }

        health -= amount
        if health <= 0 {
            dropItem()
            destroyEnemy()
        }
    }

    private func dropItem(){
        let itemNode = Ingredient(imageName: "Star", in: scene!)
        itemNode.position = position
    }
    
    private func destroyEnemy() {
        WalkingEnemy.killedAction.invoke()
        destroyed = true
        self.removeFromParent()
    }
}
