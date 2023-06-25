//
//  Player.swift
//  mc2
//
//  Created by Ardli Fadhillah on 13/06/23.
//

import SpriteKit

class Player: SKSpriteNode, Processable {
    private var inputIndex = 0
    private let moveSpeed = 425.0
    
    private var shootDelayDuration = 0.25
    private var shootDelay = false
    private var weapon: Weapon!
    private var bulletSpawnPos: SKNode!
    
    private var health = 3 {
        didSet {
            healthText.text = "HP: \(health)"
        }
    }
    private var healthText: SKLabelNode!
    private let iFrameDuration = 1.0
    private var iFrameActive = false
    static var killedAction = Event()
    
    func setup(inputIndex: Int) {
        self.inputIndex = inputIndex
        
        self.physicsBody = SKPhysicsBody(texture: texture!, alphaThreshold: 0.1, size: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = CBitMask.player
        self.physicsBody?.collisionBitMask = CBitMask.obstacle
        self.physicsBody?.contactTestBitMask = CBitMask.enemy
        
        healthText = scene?.childNode(withName: "healthText") as? SKLabelNode
        weapon = self.childNode(withName: "weaponPivot") as? Weapon
        weapon.setup(inputIndex: inputIndex)
        bulletSpawnPos = weapon.childNode(withName: "bulletSpawnPos")
        health = 3
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
        bullet.zRotation = bulletSpawnPos.globalZRotation
        bullet.zPosition = bulletSpawnPos.zPosition
        bullet.spawn(in: scene!)
        
        shootDelay = true
        self.run(SKAction.wait(forDuration: shootDelayDuration)) {
            self.shootDelay = false
        }
    }
    
    func decreaseHealth(amount: Int) {
        guard health > 0, !iFrameActive else { return }
        
        health -= amount
        health = max(0, health)
        enableIFrame()
        
        if health == 0 {
            destroy()
        }
    }
    
    func enableIFrame() {
        iFrameActive = true
        self.run(SKAction.wait(forDuration: iFrameDuration)) {
            self.iFrameActive = false
        }
    }
    
    func destroy() {
        Player.killedAction.invoke()
        self.removeFromParent()
    }
}
