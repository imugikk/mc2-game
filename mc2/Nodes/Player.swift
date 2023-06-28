//
//  Player.swift
//  mc2
//
//  Created by Ardli Fadhillah on 13/06/23.
//

import SpriteKit

class Player: SKSpriteNode, Processable, PreSpawned, HandleContactEnter {
    private var inputIndex = 0
    private let moveSpeed = 425.0
    
    private var shootDelayDuration = 0.25
    private var shootDelay = false
    private var weapon: Weapon!
    private var bulletSpawnPos: SKNode!
    private var playerSprite: SKNode!
    
    private var health = 3
    private let iFrameDuration = 1.0
    private var iFrameActive = false
    static var killedAction = Event()
    
    var lastJoystickDirection: CGPoint = .zero
    var isRunning: Bool = false
    var twinkleActionKey = "twinkleAction"
    
    private var healthBar: [SKNode?]!
    
    func setup() {
        self.inputIndex = getUserData(key: "inputIndex")
        
        self.physicsBody = SKPhysicsBody(texture: texture!, alphaThreshold: 0.1, size: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PsxBitmask.player
        self.physicsBody?.collisionBitMask = PsxBitmask.obstacle | PsxBitmask.tree
        self.physicsBody?.contactTestBitMask = PsxBitmask.enemy

        weapon = self.childNode(withName: "weapon") as? Weapon
        weapon.setup()
        bulletSpawnPos = weapon.childNode(withName: "bulletSpawnPos")
        health = 3
        
        healthBar = [scene?.childNode(withName: "heart_fill_1"), scene?.childNode(withName: "heart_fill_2"), scene?.childNode(withName: "heart_fill_3")]
        
        // Start idle animation by default
        runIdleAnimation()
    }
    
    func update(deltaTime: TimeInterval) {
        let input = InputManager.shared.getLeftJoystickInput(controllerIndex: inputIndex)
        let direction = CGPoint(x: input.x, y: input.y).normalized()
        let movement = moveSpeed * deltaTime * direction
        self.position += movement
        self.position = constrainedPosition()
        
        if InputManager.shared.isrightTriggerHeld(controllerIndex: inputIndex) {
            shootBullet()
        }
        
        playerAnimation(inputController: input)
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
    
    func shootBullet() {
        if shootDelay { return }
        
        let bullet = Bullet()
        bullet.position = bulletSpawnPos.globalPosition
        bullet.zRotationInDegrees = bulletSpawnPos.globalZRotationInDegrees
        bullet.zPosition = bulletSpawnPos.zPosition
        bullet.spawn(in: scene!)
        
        shootDelay = true
        self.run(SKAction.wait(forDuration: shootDelayDuration)) {
            self.shootDelay = false
        }
    }
    
    func decreaseHealth(amount: Int) {
        guard health > 0, !iFrameActive else { return }
        
        // play sfx character hit
        SoundManager.shared.playSoundEffect(in: scene!, audioFileName: "Character Hit.wav", volume: 3.0, randomizePitch: true)
        
        health -= amount
        health = max(0, health)
        enableIFrame()
        
        if let lastNode = healthBar.last {
            if let unwrappedNode = lastNode {
                unwrappedNode.removeFromParent()
            }
            healthBar.removeLast()
        }
        
        if health == 0 {
            destroy()
        }
        
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
    
    func destroy() {
        Player.killedAction.invoke()
        self.removeFromParent()
    }
    
    func onContactEnter(with other: SKNode?) {
        if other is Enemy {
            playerTouchesEnemy()
        } else if other is EnemyBullet {
            let enemyBullet = other as! EnemyBullet
            playerTouchesBullet(enemyBullet: enemyBullet)
        }
    }
    
    func playerTouchesEnemy() {
        self.decreaseHealth(amount: 1)
    }
    
    func playerTouchesBullet(enemyBullet: EnemyBullet) {
        enemyBullet.destroy()
        self.decreaseHealth(amount: 1)
    }
     
    func playerAnimation(inputController: CGPoint){
        let joystickPosition = CGPoint(x: inputController.x, y: inputController.y)
        let joystickActive = joystickPosition != .zero

        //animation cycle
        if joystickActive != isRunning {
            isRunning = joystickActive
            
            if isRunning {
                runningAnimation()
            } else {
                runIdleAnimation()
            }
        }
        
        //flip
        playerSprite.xScale = joystickPosition.x < 0 ? -5 : 5
        
        if joystickPosition != .zero {
            lastJoystickDirection = joystickPosition
        } else {
            playerSprite.xScale = lastJoystickDirection.x < 0 ? -abs(playerSprite.xScale) : abs(playerSprite.xScale)
        }
    }
    
    func runIdleAnimation() {
        let idleTextures = [
            SKTexture(imageNamed: "Porter_Idle_1"),
            SKTexture(imageNamed: "Porter_Idle_2"),
            SKTexture(imageNamed: "Porter_Idle_3"),
            SKTexture(imageNamed: "Porter_Idle_4")
        ]
        
        let idleAnimation = SKAction.animate(with: idleTextures, timePerFrame: 0.2)
        let idleAction = SKAction.repeatForever(idleAnimation)
        
        playerSprite = childNode(withName: "playerSprite")!
        
        playerSprite.run(idleAction, withKey: "idleAnimation")
    }
    
    func runningAnimation() {
        let runTextures = [
            SKTexture(imageNamed: "Porter_Run_4"),
            SKTexture(imageNamed: "Porter_Run_5"),
            SKTexture(imageNamed: "Porter_Run_6"),
            SKTexture(imageNamed: "Porter_Run_7"),
            SKTexture(imageNamed: "Porter_Run_8"),
            SKTexture(imageNamed: "Porter_Run_9"),
            SKTexture(imageNamed: "Porter_Run_10"),
            SKTexture(imageNamed: "Porter_Run_11"),
            SKTexture(imageNamed: "Porter_Run_12"),
            SKTexture(imageNamed: "Porter_Run_13"),
            SKTexture(imageNamed: "Porter_Run_14"),
            SKTexture(imageNamed: "Porter_Run_15"),
            SKTexture(imageNamed: "Porter_Run_16"),
            SKTexture(imageNamed: "Porter_Run_17"),
            SKTexture(imageNamed: "Porter_Run_18"),
            SKTexture(imageNamed: "Porter_Run_1"),
            SKTexture(imageNamed: "Porter_Run_2"),
            SKTexture(imageNamed: "Porter_Run_3")
        ]
        
        let runAnimation = SKAction.animate(with: runTextures, timePerFrame: 0.1)
        let runAction = SKAction.repeatForever(runAnimation)
        playerSprite = childNode(withName: "playerSprite")!
        
        playerSprite.run(runAction, withKey: "runAnimation")
    }
}
