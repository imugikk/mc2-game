//
//  Player.swift
//  mc2
//
//  Created by Ardli Fadhillah on 13/06/23.
//

import SpriteKit

class Player: SKSpriteNode {
    private let moveSpeed = 200.0
    private var shootDelayDuration = 0.25
    private var shootDelay = false
    private var health = 3 {
        didSet {
            healthText.text = "HP: \(health)"
        }
    }
    private var healthText: SKLabelNode!
    private var bulletSpawnPos: SKNode!
    private var killedAction: (() -> Void)!
    
    private var bullets = [Bullet]()
    
    func setup(killedAction: @escaping () -> Void) {
        healthText = scene?.childNode(withName: "healthText") as? SKLabelNode
        bulletSpawnPos = childNode(withName: "weaponPivot")?.childNode(withName: "bulletSpawnPos")
        health = 3
        self.killedAction = killedAction
    }

    func update(deltaTime: Double) {
        let input = InputManager.shared.getLeftJoystickInput(controllerIndex: 0)
        let direction = CGPoint(x: input.x, y: input.y).normalized()
        let movement = moveSpeed * deltaTime * direction
        self.position += movement
        
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
    
    func decreaseHealth(damage: Int) {
        guard health > 0 else { return }
        
        health -= damage
        health = max(0, health)
        
        if health == 0 {
            destroy()
        }
    }
    
    func destroy() {
        killedAction()
        removeFromParent()
    }
}
