//
//  StartScene.swift
//  mc2
//
//  Created by Michelle Annice on 20/06/23.
//

import SpriteKit

class MainMenuScene: SKScene {
    var highScoreLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        InputManager.buttonAPressed.subscribe(node: self, closure: startGame)
        InputManager.buttonBPressed.subscribe(node: self, closure: exitGame)
        
        highScoreLabel = childNode(withName: "highScoreText") as? SKLabelNode
        ScoreManager.shared.setup(highScoreLabel: highScoreLabel)
    }
    override func willMove(from view: SKView) {
        InputManager.buttonAPressed.unsubscribe(node: self)
        InputManager.buttonBPressed.unsubscribe(node: self)
    }
    func startGame() {
        GameViewController.changeScene(to: "GameScene", in: self.view!)
    }
    func exitGame() {
        exit(0)
    }
}
