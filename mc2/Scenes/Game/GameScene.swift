//
//  GameScene.swift
//  mc2
//
//  Created by Paraptughessa Premaswari on 12/06/23.
//

import SpriteKit
import GameController

class GameScene: Scene {
    var player: Player!
    var player2: Player!
    var obstacle: Obstacle!
    var scoreLabel: SKLabelNode!
    
    var contactManager: ContactManager!
    var waveManager: WaveManager!
    
    let restartDelay = 1.0
    
    override func sceneDidLoad() {
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
        contactManager = ContactManager()
        physicsWorld.contactDelegate = contactManager
        Player.killedAction.subscribe(node: self, closure: gameOver)
        
        player = childNode(withName: "player") as? Player
        player.setup(inputIndex: 0)
        
//        player2 = childNode(withName: "player2") as? Player
//        player2.setup(inputIndex: 1)
        
        obstacle = childNode(withName: "obstacle") as? Obstacle
        obstacle.setup()
        
        scoreLabel = childNode(withName: "scoreText") as? SKLabelNode
        ScoreManager.shared.setup(scoreLabel: scoreLabel)
        ScoreManager.shared.resetScore()
        
        waveManager = WaveManager(gameScene: self)
        waveManager?.start()
    }
    
    override func willMove(from view: SKView) {
        waveManager?.stop()
        Player.killedAction.unsubscribe(node: self)
    }

    private func gameOver() {
        ScoreManager.shared.saveScore()
        self.run (SKAction.wait (forDuration: restartDelay)) {
            GameViewController.changeScene(to: "GameOverScene", in: self.view!)
        }
    }
}
