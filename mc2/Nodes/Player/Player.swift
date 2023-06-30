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
     
//    func playerAnimation(inputController: CGPoint){
//        let joystickPosition = CGPoint(x: inputController.x, y: inputController.y)
//        let joystickActive = joystickPosition != .zero
//
//        //animation cycle
//        if joystickActive != isRunning {
//            isRunning = joystickActive
//
//            if isRunning {
//                runningAnimation()
//            } else {
//                runIdleAnimation()
//            }
//        }
//
//        //flip
//        playerSprite.xScale = joystickPosition.x < 0 ? -5 : 5
//
//        if joystickPosition != .zero {
//            lastJoystickDirection = joystickPosition
//        } else {
//            playerSprite.xScale = lastJoystickDirection.x < 0 ? -abs(playerSprite.xScale) : abs(playerSprite.xScale)
//        }
//    }
//
//    func runIdleAnimation() {
//        let idleTextures = [
//            SKTexture(imageNamed: "Porter_Idle_1"),
//            SKTexture(imageNamed: "Porter_Idle_2"),
//            SKTexture(imageNamed: "Porter_Idle_3"),
//            SKTexture(imageNamed: "Porter_Idle_4")
//        ]
//
//        let idleAnimation = SKAction.animate(with: idleTextures, timePerFrame: 0.2)
//        let idleAction = SKAction.repeatForever(idleAnimation)
//
//        playerSprite = childNode(withName: "playerSprite")!
//
//        playerSprite.run(idleAction, withKey: "idleAnimation")
//    }
//
//    func runningAnimation() {
//        let runTextures = [
//            SKTexture(imageNamed: "Porter_Run_4"),
//            SKTexture(imageNamed: "Porter_Run_5"),
//            SKTexture(imageNamed: "Porter_Run_6"),
//            SKTexture(imageNamed: "Porter_Run_7"),
//            SKTexture(imageNamed: "Porter_Run_8"),
//            SKTexture(imageNamed: "Porter_Run_9"),
//            SKTexture(imageNamed: "Porter_Run_10"),
//            SKTexture(imageNamed: "Porter_Run_11"),
//            SKTexture(imageNamed: "Porter_Run_12"),
//            SKTexture(imageNamed: "Porter_Run_13"),
//            SKTexture(imageNamed: "Porter_Run_14"),
//            SKTexture(imageNamed: "Porter_Run_15"),
//            SKTexture(imageNamed: "Porter_Run_16"),
//            SKTexture(imageNamed: "Porter_Run_17"),
//            SKTexture(imageNamed: "Porter_Run_18"),
//            SKTexture(imageNamed: "Porter_Run_1"),
//            SKTexture(imageNamed: "Porter_Run_2"),
//            SKTexture(imageNamed: "Porter_Run_3")
//        ]
//
//        let runAnimation = SKAction.animate(with: runTextures, timePerFrame: 0.1)
//        let runAction = SKAction.repeatForever(runAnimation)
//        playerSprite = childNode(withName: "playerSprite")!
//
//        playerSprite.run(runAction, withKey: "runAnimation")
//    }
}
