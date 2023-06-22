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
    var obstacle: Obstacle!
    var waveManager: WaveManager!
    
    let restartDelay = 2.0
    
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
        physicsWorld.contactDelegate = ContactManager.shared
        Player.killedAction.subscribe(node: self, closure: restartScene)
                
        player = childNode(withName: "player") as? Player
        player.setup()
        
        obstacle = childNode(withName: "obstacle") as? Obstacle
        obstacle.setup()
        
        waveManager = WaveManager(gameScene: self)
        waveManager?.start()
    }
    
    override func willMove(from view: SKView) {
        waveManager?.stop()
        Player.killedAction.unsubscribe(node: self)
    }

    private func restartScene() {
        self.run (SKAction.wait (forDuration: restartDelay)) {
            GameViewController.changeScene(to: "GameScene", in: self.view!)
        }
    }
}
