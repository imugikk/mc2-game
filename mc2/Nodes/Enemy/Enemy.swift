//
//  Enemy.swift
//  mc2
//
//  Created by Ardli Fadhillah on 22/06/23.
//

import SpriteKit

class Enemy: SKSpriteNode, Processable {
    var moveSpeed = 100.0
    var health: Int = 3
    var playerNode: Player? = nil
    static let killedAction = Event()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
//        let texture = SKTexture(imageNamed: "Capsule")
        let textures = [
            SKTexture(imageNamed: "Capsule"),
        ]
        let color: NSColor = .brown
        let size = CGSize(width: 50.0, height: 50.0)
        
//        super.init(texture: texture, color: color, size: size)
        super.init(texture: textures.first, color: color, size: size)
    }
    
    func spawn(in scene: SKScene) {
        scene.addChild(self)
        self.playerNode = scene.childNode(withName: "player") as? Player
        
        self.name = "enemy"
        self.colorBlendFactor = 1
        self.zPosition = -3
        self.zRotationInDegrees = 0.0
        
        self.physicsBody = SKPhysicsBody(texture: texture!, alphaThreshold: 0.1, size: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PsxBitmask.enemy
        self.physicsBody?.collisionBitMask = PsxBitmask.obstacle | PsxBitmask.enemy
        self.physicsBody?.contactTestBitMask = PsxBitmask.bullet | PsxBitmask.player
        
        randomizePosition()
    }
    
    func update(deltaTime: TimeInterval) {}
    
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

    func decreaseHealth(amount: Int) {
        guard health > 0 else { return }

        health -= amount
        
        //if hp > 0
        //play sfx enemy hit
        if health > 0{
            SoundManager.shared.playSoundEffect(in: scene!, audioFileName: "Enemy Hit.wav", volume: 1.0, randomizePitch: true)
        }
        
        
        if health <= 0 {
            dropItem()
            destroy()
        }
    }

    func dropItem() {
        let dropProbability: CGFloat = 2.5
        let random = CGFloat.random(in: 0...5)
//        let randomIndex = CGFloat.random(in: 0...5)

        if random <= dropProbability {
            var customTexture = SKTexture(imageNamed: "POTIONY")
            if self.name == "walkingEnemy" {
                var imageName: String
                if random <= 1.25 {
                    imageName = "POTIONG"
                } else {
                    imageName = "POTIONY"
                }
                customTexture = SKTexture(imageNamed: imageName)
            } else if self.name == "shootingEnemy" {
                customTexture = SKTexture(imageNamed: "POTIONR")
            }
            let itemNode = Ingredient(texture: customTexture)
            itemNode.position = position
            itemNode.spawn(in: self.scene!)
        }
    }
    
    func destroy() {
        // play sfx enemy die
       SoundManager.shared.playSoundEffect(in: scene!, audioFileName: "Enemy Die.wav", volume: 3.0, randomizePitch: true)
        
        Enemy.killedAction.invoke()
        self.removeFromParent()
    }
}
