//
//  StartScene.swift
//  mc2
//
//  Created by Michelle Annice on 20/06/23.
//

import SpriteKit

class MainMenuScene: Scene {
    //Observe for Controllers
    override func sceneDidLoad() {
        super.sceneDidLoad()

        InputManager.shared.ObserveForGameControllers()
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        //play bgm buat main menu
        SoundManager.shared.playBGM(in: self, audioFileName: "MainMenu.wav")
        
        InputManager.buttonAPressed.subscribe(node: self, closure: connectingPlayer)
        InputManager.buttonYPressed.subscribe(node: self, closure: moveToCredits)
        InputManager.buttonBPressed.subscribe(node: self, closure: exitGame)
        
        let highScoreLabel = childNode(withName: "highScoreText") as? SKLabelNode
        ScoreManager.shared.setup(highScoreLabel: highScoreLabel)
    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
        InputManager.buttonAPressed.unsubscribe(node: self)
        InputManager.buttonBPressed.unsubscribe(node: self)
        InputManager.buttonYPressed.unsubscribe(node: self)
    }
    
    func connectingPlayer() {
        GameViewController.changeScene(to: "ControllerScene", in: self.view!)
    }
    
    func moveToCredits() {
        GameViewController.changeScene(to: "CreditScene", in: self.view!)
    }
    
    func exitGame() {
        exit(0)
    }
}
