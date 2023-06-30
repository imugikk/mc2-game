//
//  ControllerScene.swift
//  mc2
//
//  Created by Paraptughessa Premaswari on 27/06/23.
//

import SpriteKit
import GameController

class ControllerScene: Scene {
    
    var potterLabel : SKLabelNode!
    var porterSprite : SKSpriteNode!
    var karenSprite : SKSpriteNode!
    var karenLabel : SKLabelNode!
    var hasMoveScene: Bool = false
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        //play bgm buat controller
        SoundManager.shared.playBGM(in: self, audioFileName: "MainMenu.wav")
        
        potterLabel = childNode(withName: "potterConnected") as? SKLabelNode
        karenLabel = childNode(withName: "karenConnected") as? SKLabelNode
        
        runIdleAnimation()
        runIdleAnimationKaren()
        
        InputManager.buttonAPressed.subscribe(node: self, closure: startGame)
    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
        InputManager.buttonAPressed.unsubscribe(node: self)
    }
    
    func startGame() {
        if InputManager.shared.controller_1 == true && InputManager.shared.controller_2 == true && hasMoveScene == false{
            hasMoveScene = true
            GameViewController.changeScene(to: "TutorialScene", in: self.view!)
        }
    }
    
    override func update(deltaTime: TimeInterval) {
        connectingPlayer()
    }
    
    func connectingPlayer() {
        if InputManager.shared.controller_1 == true {
            potterLabel.text = "Connected"
        }
        else {
            potterLabel.text = "Not Connected"
        }
        
        if InputManager.shared.controller_2 == true {
            karenLabel.text = "Connected"
        }
        else  {
            karenLabel.text = "Not Connected"
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
        
        porterSprite = childNode(withName: "porter") as? SKSpriteNode
        
        porterSprite.run(idleAction, withKey: "idleAnimation")
    }
    
    func runIdleAnimationKaren() {
        let idleTextures = [
            SKTexture(imageNamed: "Karen_Idle_3"),
            SKTexture(imageNamed: "Karen_Idle_4"),
            SKTexture(imageNamed: "Karen_Idle_1"),
            SKTexture(imageNamed: "Karen_Idle_2")
        ]
        
        let idleAnimation = SKAction.animate(with: idleTextures, timePerFrame: 0.2)
        let idleAction = SKAction.repeatForever(idleAnimation)
        
        karenSprite = childNode(withName: "karen") as? SKSpriteNode
        karenSprite.xScale = -abs(karenSprite.xScale)
        
        karenSprite.run(idleAction, withKey: "idleAnimation")
    }
}
