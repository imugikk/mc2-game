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
    
//    var lastJoystickDirection: CGPoint = .zero
//    var isRunning: Bool = false
    var twinkleActionKey = "twinkleAction"
    
    private var healthBar: [SKNode?]!
    
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
        
        //ikutin maxhealth
        healthBar = [scene?.childNode(withName: "heart_fill_1"), scene?.childNode(withName: "heart_fill_2"), scene?.childNode(withName: "heart_fill_3")]
        
        cameraNode = scene?.childNode(withName: "CameraNode")
        
//        // Start idle animation by default
//        runIdleAnimation()
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
        health += 1
    }
    
    func decreaseHealth(amount: Int) {
        guard Player.health > 0, !iFrameActive else { return }
        
        // play sfx character hit
        SoundManager.shared.playSoundEffect(in: scene!, audioFileName: "Character Hit.wav", volume: 3.0, randomizePitch: true)
        
        Player.health -= amount
        Player.health = max(0, Player.health)
        enableIFrame()
        
        if let lastNode = healthBar.last {
            if let unwrappedNode = lastNode {
                unwrappedNode.removeFromParent()
            }
            healthBar.removeLast()
        }
        
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
