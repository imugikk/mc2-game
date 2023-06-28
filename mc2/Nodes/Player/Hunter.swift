//
//  Hunter.swift
//  mc2
//
//  Created by Ardli Fadhillah on 27/06/23.
//

import SpriteKit

class Hunter: Player {
    private var shootDelayDuration = 0.25
    private var shootDelay = false
    private var weapon: Weapon!
    private var bulletSpawnPos: SKNode!
    
    override func setup() {
        super.setup()
        
        weapon = self.childNode(withName: "weapon") as? Weapon
        weapon.setup()
        bulletSpawnPos = weapon.childNode(withName: "bulletSpawnPos")
    }
    
    override func update(deltaTime: TimeInterval) {
        super.update(deltaTime: deltaTime)
        
        if InputManager.shared.isrightTriggerHeld(controllerIndex: inputIndex) {
            shootBullet()
        }
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
}
