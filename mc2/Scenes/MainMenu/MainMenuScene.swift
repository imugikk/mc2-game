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
        NotificationCenter.default.addObserver(self, selector: #selector(controllerConnected), name: NSNotification.Name.GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(controllerDisconnected), name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
    }
    @objc func controllerConnected() {
        self.isPaused = false
    }
    @objc func controllerDisconnected() {
        self.isPaused = true
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        //play bgm buat main menu
        SoundManager.shared.playBGM(in: self, audioFileName: "MainMenu.wav")
        
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
        GameViewController.changeScene(to: "TutorialScene", in: self.view!)
    }
    func exitGame() {
        exit(0)
    }
}
