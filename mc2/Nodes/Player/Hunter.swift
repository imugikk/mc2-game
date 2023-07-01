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
    
    var lastJoystickDirection: CGPoint = .zero
    var isRunning: Bool = false
    private var playerSprite: SKNode!
    
    override func setup() {
        super.setup()
        
        weapon = self.childNode(withName: "weapon") as? Weapon
        weapon.setup()
        bulletSpawnPos = weapon.childNode(withName: "bulletSpawnPos")

        // Start idle animation by default
        runIdleAnimation()
    }
    
    override func update(deltaTime: TimeInterval) {
        super.update(deltaTime: deltaTime)
        
        let input = InputManager.shared.getLeftJoystickInput(controllerIndex: inputIndex)
        
        if InputManager.shared.isrightTriggerHeld(controllerIndex: inputIndex) {
            shootBullet()
        }
        
        playerAnimation(inputController: input)
    }
    
    func shootBullet() {
        if shootDelay { return }
        
        let bullet = Bullet()
        bullet.position = bulletSpawnPos.globalPosition
        bullet.zRotationInDegrees = bulletSpawnPos.globalZRotationInDegrees
        bullet.zPosition = bulletSpawnPos.zPosition
        bullet.spawn(in: scene!)
        
        shootDelay = true
        let shake = SKAction.shake(initialPosition: (cameraNode?.position)!, duration: 0.1, amplitudeX: 3, amplitudeY: 3)
        cameraNode.run(shake)
        
        self.run(SKAction.wait(forDuration: shootDelayDuration)) {
            self.shootDelay = false
        }
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
