//
//  GameScene.swift
//  mc2
//
//  Created by Paraptughessa Premaswari on 12/06/23.
//

import SpriteKit
import GameController

class GameScene: Scene {
    var contactManager: ContactManager!
    var waveManager: WaveManager!
    
    let gameOverTransitionDelay = 1.0
    
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
    
    //Scene Setup
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        //play bgm buat intro, tunggu 13.5 detik pake skaction.wait
        SoundManager.shared.playBGM(in: self, audioFileName: "Wave 1", volume: 0.5)
        self.run(SKAction.wait(forDuration: 13.5)) {
            //ubah boolean jadi true
            //play lagu in game
            SoundManager.shared.playBGM(in: self, audioFileName: "In Game.wav", volume: 0.5)
        }
        
        Player.killedAction.subscribe(node: self, closure: gameOver)
        
        contactManager = ContactManager()
        physicsWorld.contactDelegate = contactManager
        
        let scoreLabel = childNode(withName: "scoreText") as? SKLabelNode
        ScoreManager.shared.setup(scoreLabel: scoreLabel)
        ScoreManager.shared.resetScore()
        
        waveManager = WaveManager(gameScene: self)
        waveManager?.start()
    }
    
    //Scene Clean Up
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
        waveManager?.stop()
        Player.killedAction.unsubscribe(node: self)
    }

    //Move to Game Over Scene
    private func gameOver() {
        //play sfx game over
        SoundManager.shared.playBGM(in: self, audioFileName: "Game Over.wav")
            
        ScoreManager.shared.saveScore()
        self.run (SKAction.wait (forDuration: gameOverTransitionDelay)) {
            SoundManager.shared.playBGM(in: self, audioFileName: "MainMenu.wav")
            GameViewController.changeScene(to: "GameOverScene", in: self.view!)
        }
    }
}
