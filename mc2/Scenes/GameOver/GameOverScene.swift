//
//  GameOverScene.swift
//  mc2
//
//  Created by Michelle Annice on 16/06/23.
//

import SpriteKit

class GameOverScene: Scene {
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        InputManager.buttonAPressed.subscribe(node: self, closure: restart)
        InputManager.buttonBPressed.subscribe(node: self, closure: moveToMainMenu)
        
        SoundManager.shared.playBGM(in: self, audioFileName: "MainMenu.wav")

        
        let scoreLabel = childNode(withName: "scoreText") as? SKLabelNode
        let highScoreLabel = childNode(withName: "highScoreText") as? SKLabelNode
        let waveLabel = childNode(withName: "waveText") as? SKLabelNode
        ScoreManager.shared.setup(scoreLabel: scoreLabel, highScoreLabel: highScoreLabel)
    }
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
        InputManager.buttonAPressed.unsubscribe(node: self)
        InputManager.buttonBPressed.unsubscribe(node: self)
    }
    func restart() {
        GameViewController.changeScene(to: "GameScene", in: self.view!)
    }
    func moveToMainMenu() {
        GameViewController.changeScene(to: "MainMenu", in: self.view!)
    }
}
