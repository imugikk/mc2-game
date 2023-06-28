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
    static var health = 0 {
        didSet {
            healthText.text = "HP: \(Player.health)"
        }
    }
    static var healthText: SKLabelNode!
    let iFrameDuration = 1.0
    var iFrameActive = false
    static var killed = false
    static var killedAction = Event()
    
    func setup() {
        self.inputIndex = getUserData(key: "inputIndex")
        
        self.physicsBody = SKPhysicsBody(texture: texture!, alphaThreshold: 0.1, size: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PsxBitmask.player
        self.physicsBody?.collisionBitMask = PsxBitmask.obstacle | PsxBitmask.player
        self.physicsBody?.contactTestBitMask = PsxBitmask.enemy | PsxBitmask.enemyBullet
        
        Player.healthText = scene?.childNode(withName: "healthText") as? SKLabelNode
        Player.health = Player.maxHealth
        Player.killed = false
        
        InputManager.buttonXPressed.subscribe(node: self, closure: {
            self.inputIndex = 1 - self.inputIndex
        })
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
        health += 1
    }
    
    func decreaseHealth(amount: Int) {
        guard Player.health > 0, !iFrameActive else { return }
        
        Player.health -= amount
        Player.health = max(0, Player.health)
        enableIFrame()
        
        if Player.health == 0 {
            Player.kill()
        }
    }
    
    func enableIFrame() {
        iFrameActive = true
        self.run(SKAction.wait(forDuration: iFrameDuration)) {
            self.iFrameActive = false
        }
    }
    
    static func kill() {
        Player.killed = true
        Player.killedAction.invoke()
    }
    func destroy() {
        InputManager.buttonXPressed.unsubscribe(node: self)
        self.removeFromParent()
    }
}
