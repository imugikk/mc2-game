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
    }
        
    func activateHealthPowerup() {
        Player.increaseHealth()
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
    }
    func runSlowMoPowerupTimer(deltaTime: TimeInterval) {
        if slowMoTimer <= 0 { return }
        
        slowMoTimer -= deltaTime
        
        if slowMoTimer <= 0 {
            slowMoPowerupStopped.invoke()
        }
    }
}
