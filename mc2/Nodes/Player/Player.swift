//
//  Player.swift
//  mc2
//
//  Created by Ardli Fadhillah on 13/06/23.
//

import SpriteKit

class Player: SKSpriteNode, Processable, PreSpawned {
    var inputIndex = 0
    var moveSpeed = 425.0
    
    static var maxHealth = 6
    static var health = 0
    static var healthText: SKLabelNode!
    
    private let iFrameDuration = 1.0
    private var iFrameActive = false
    static var killed = false
    static var killedAction = Event()
    
    var twinkleActionKey = "twinkleAction"
    
    let textureFill = SKTexture(imageNamed: "HealthFill")
    let texturePlaceholder = SKTexture(imageNamed: "HealthPlaceholder")
    let scaleHealth: CGFloat = 0.06
    let zPositionFill: CGFloat = 11
    let zPositionPlaceholder: CGFloat = 12
    let gap: CGFloat = 10 // Adjust the gap size as needed
    static var healthBar: [SKSpriteNode] = []
    
    var cameraNode: SKNode!
    
    func setup() {
        self.inputIndex = getUserData(key: "inputIndex")
        
        self.physicsBody = SKPhysicsBody(texture: texture!, alphaThreshold: 0.1, size: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PsxBitmask.player
        self.physicsBody?.collisionBitMask = PsxBitmask.obstacle | PsxBitmask.tree | PsxBitmask.player
        self.physicsBody?.contactTestBitMask = PsxBitmask.enemy | PsxBitmask.enemyBullet

        Player.healthText = scene?.childNode(withName: "healthText") as? SKLabelNode
        Player.health = Player.maxHealth
        Player.killed = false
        
        if Player.healthBar.count <= Player.health/2 {
            for i in 1...Player.health {
                let heartFill = SKSpriteNode(texture: textureFill)
                heartFill.setScale(scaleHealth)
                heartFill.zPosition = zPositionFill
                let fillXPosition = heartFill.size.width * CGFloat(i) + (CGFloat(i) - 1) * gap
                heartFill.position = CGPoint(x: fillXPosition - scene!.size.width/2 + 100, y: scene!.size.height / 2 - 80)
                scene?.addChild(heartFill)
                Player.healthBar.append(heartFill)

                let heartPlaceholder = SKSpriteNode(texture: texturePlaceholder)
                heartPlaceholder.setScale(scaleHealth)
                heartPlaceholder.zPosition = zPositionPlaceholder
                let placeholderXPosition = heartFill.size.width * CGFloat(i) + (CGFloat(i) - 1) * gap
                heartPlaceholder.position = CGPoint(x: placeholderXPosition - scene!.size.width/2 + 100, y: scene!.size.height / 2 - 80)
                scene?.addChild(heartPlaceholder)
            }
        }
        
        cameraNode = scene?.childNode(withName: "CameraNode")
    
    }
    
    func update(deltaTime: TimeInterval) {
        let input = InputManager.shared.getLeftJoystickInput(controllerIndex: inputIndex)
        let direction = CGPoint(x: input.x, y: input.y).normalized()
        let movement = moveSpeed * deltaTime * direction
        self.position += movement
        self.position = constrainedPosition()
        
        if Player.killed && !destroyed {
            self.destroy()
        }
    }
    
    func constrainedPosition() -> CGPoint {
        let objectHalfWidth = size.width / 2
        let objectHalfHeight = size.height / 2
        
        let minX = -screenWidth / 2 + objectHalfWidth
        let maxX = screenWidth / 2 - objectHalfWidth
        let minY = -screenHeight / 2 + objectHalfHeight
        let maxY = screenHeight / 2 - objectHalfHeight
        
        let constrainedX = min(max(position.x, minX), maxX)
        let constrainedY = min(max(position.y, minY), maxY)
        
        return CGPoint(x: constrainedX, y: constrainedY)
    }
    
    static func increaseHealth() {        
        if health >= maxHealth {
            return
        }

        Player.healthBar[Player.health].isHidden = false
        
        health += 1
    }
    
    func soundCharacter() {
        // play sfx character hit
        SoundManager.shared.playSoundEffect(in: scene!, audioFileName: "Character Hit.wav", volume: 3.0, randomizePitch: true)
    }
    
    func decreaseHealth(amount: Int) {
        guard Player.health > 0, !iFrameActive else { return }
        
        soundCharacter()
        
        Player.health -= amount
        Player.health = max(0, Player.health)
        enableIFrame()
        
        Player.healthBar[Player.health].isHidden = true
        
        if Player.health == 0 {
            Player.kill()
        }
        
        shakeScreen()
        
    }
    
    func enableIFrame() {
        iFrameActive = true
        twinkleScreen()
        
        self.run(SKAction.wait(forDuration: iFrameDuration)) {
            self.iFrameActive = false
            self.removeAction(forKey: "twinkleActionKey")
        }
    }
    
    func twinkleScreen() {
        let fadeInAction = SKAction.fadeIn(withDuration: 0.1)
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.1)
        let twinkleSequence = SKAction.sequence([fadeOutAction, fadeInAction])
        let twinkleAction = SKAction.repeatForever(twinkleSequence)
        
        self.run(twinkleAction, withKey: "twinkleActionKey")
    }
    
    static func kill() {
        Player.killed = true
        Player.killedAction.invoke()
    }
    
    func destroy() {
        self.removeFromParent()
    }
    
    func shakeScreen() {
        let shake = SKAction.shake(initialPosition: cameraNode.position, duration: 0.1, amplitudeX: 50, amplitudeY: 70)
        cameraNode.run(shake)
    }
}
