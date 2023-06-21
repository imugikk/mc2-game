//
//  Player.swift
//  mc2
//
//  Created by Ardli Fadhillah on 13/06/23.
//

import SpriteKit

class Player: SKSpriteNode {
    var screenHeight: Double { scene!.frame.size.height }
    var screenWidth: Double { scene!.frame.size.width }
    
    private let moveSpeed = 300.0
    
    private var shootDelayDuration = 0.25
    private var shootDelay = false
    private var bulletSpawnPos: SKNode!
    
    private var health = 3 {
        didSet {
            healthText.text = "HP: \(health)"
        }
    }
    private var healthText: SKLabelNode!
    private let iFrameDuration = 1.0
    private var iFrameActive = false
    private var killedAction: (() -> Void)!
    var destroyed = false
    
    private var bullets = [Bullet]()
    
    func setup(killedAction: @escaping () -> Void) {
        self.physicsBody = SKPhysicsBody(texture: texture!, alphaThreshold: 0.1, size: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = CBitMask.player
        self.physicsBody?.collisionBitMask = CBitMask.obstacle
        self.physicsBody?.contactTestBitMask = CBitMask.enemy
        
        healthText = scene?.childNode(withName: "healthText") as? SKLabelNode
        bulletSpawnPos = childNode(withName: "weaponPivot")?.childNode(withName: "bulletSpawnPos")
        health = 3
        self.killedAction = killedAction
    }
    
    func update(deltaTime: Double) {
        if destroyed { return }
        
        let input = InputManager.shared.getLeftJoystickInput(controllerIndex: 0)
        let direction = CGPoint(x: input.x, y: input.y).normalized()
        let movement = moveSpeed * deltaTime * direction
        self.position += movement
        self.position = constrainedPosition()
        
        if InputManager.shared.rightTriggerHeld {
            shootBullet()
        }
        
        for bullet in bullets {
            bullet.update(deltaTime: deltaTime)
            
            if bullet.destroyed {
                bullets.removeAll(where: { $0 == bullet })
            }
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
        
        let bullet = Bullet(imageNamed: "Circle", in: scene!)
        bullet.setScale(1.25)
        let spawnPos = bulletSpawnPos.parent!.convert(bulletSpawnPos.position, to: scene!)
        let spawnRot = globalZRotation(for: bulletSpawnPos)
        bullet.position = spawnPos
        bullet.zPosition = bulletSpawnPos.zPosition
        bullet.zRotation = spawnRot
        bullets.append(bullet)

        shootDelay = true
        self.run(SKAction.wait(forDuration: shootDelayDuration)) {
            self.shootDelay = false
        }
    }
    
    func globalZRotation(for node: SKNode) -> CGFloat {
        var rotation: CGFloat = node.zRotation
        var currentNode = node
        
        while let parentNode = currentNode.parent {
            currentNode = parentNode
            rotation += currentNode.zRotation
        }
        
        return rotation
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
        destroyed = true
        killedAction()
        self.removeFromParent()
    }
}
