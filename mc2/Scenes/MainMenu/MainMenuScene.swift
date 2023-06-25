//
//  StartScene.swift
//  mc2
//
//  Created by Michelle Annice on 20/06/23.
//

import SpriteKit

class MainMenuScene: Scene {
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        InputManager.buttonAPressed.subscribe(node: self, closure: startGame)
        InputManager.buttonBPressed.subscribe(node: self, closure: exitGame)
        
        let highScoreLabel = childNode(withName: "highScoreText") as? SKLabelNode
        ScoreManager.shared.setup(highScoreLabel: highScoreLabel)
    }
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
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
