//
//  powerupManager.swift
//  mc2
//
//  Created by Ardli Fadhillah on 28/06/23.
//

import SpriteKit

class PowerupManager: SKSpriteNode, Processable, PreSpawned {
    private static var instance: PowerupManager? = nil
    static var shared: PowerupManager! {
        return instance
    }
    
    var activatePowerups: [String: () -> Void] = [:]
    
    var damageTimer = 0.0
    var damagePowerupDuration = 10.0
    var damagePowerupActive: Bool {
        return damageTimer > 0
    }
    
    var slowMoPowerupStarted = Event()
    var slowMoPowerupStopped = Event()
    var slowMoTimer = 0.0
    var slowMoPowerupDuration = 10.0
    var slowMoPowerupActive: Bool {
        return slowMoTimer > 0
    }
    var powerUpText: SKLabelNode!
    var powerUpTextStartPos = CGPoint.zero
    
    func setup() {
        if PowerupManager.instance == nil {
            PowerupManager.instance = self
        }
        else if PowerupManager.instance != self {
            removeFromParent()
            return
        }
        
        activatePowerups = [
            "RRB": activateHealthPowerup,
            "RBR": activateDamagePowerup,
            "BBR": activateSlowDownPowerup
        ]
        
        powerUpText = scene!.childNode(withName: "powerUpText") as? SKLabelNode
        powerUpTextStartPos = powerUpText.position
    }
        
    func activateHealthPowerup() {
        Player.increaseHealth()
        playTextAnimation("Health Up!!!")
    }
    
    func update(deltaTime: TimeInterval) {
        runDamagePowerupTimer(deltaTime: deltaTime)
        runSlowMoPowerupTimer(deltaTime: deltaTime)
    }
    func activateDamagePowerup() {
        if damageTimer <= 0 {
            damageTimer = damagePowerupDuration
        }
        else {
            damageTimer += damagePowerupDuration
        }
        playTextAnimation("Damage Up!!!")
    }
    func runDamagePowerupTimer(deltaTime: TimeInterval) {
        if damageTimer <= 0 { return }
        
        damageTimer -= deltaTime
    }
    func activateSlowDownPowerup() {
        if slowMoTimer <= 0 {
            slowMoPowerupStarted.invoke()
            slowMoTimer = slowMoPowerupDuration
        }
        else {
            slowMoTimer += slowMoPowerupDuration
        }
        playTextAnimation("Slow Mo!!!")
    }
    func runSlowMoPowerupTimer(deltaTime: TimeInterval) {
        if slowMoTimer <= 0 { return }
        
        slowMoTimer -= deltaTime
        
        if slowMoTimer <= 0 {
            slowMoPowerupStopped.invoke()
        }
    }
    func playTextAnimation(_ text: String){
        powerUpText.isHidden = false
        powerUpText.alpha = 1.0
        powerUpText.position = powerUpTextStartPos
        powerUpText.text = text
        
        let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 50), duration: 1.0)
        let fadeOutAction = SKAction.fadeOut(withDuration: 1.0)
        let groupAction = SKAction.group([moveAction, fadeOutAction])

        powerUpText.run(groupAction) {
            self.powerUpText.isHidden = true
        }
    }
}
