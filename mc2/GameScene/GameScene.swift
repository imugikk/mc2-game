//
//  GameScene.swift
//  mc2
//
//  Created by Paraptughessa Premaswari on 12/06/23.
//

import SpriteKit
import GameController

class GameScene: Scene {
    private let disableWave = false
    
    private var player: Player!
    private var obstacle: Obstacle!
    private var waveText: SKLabelNode!
    
    private var enemiesSpawned: Int = 0
    private var enemiesKilled: Int = 0
    
    private var maxEnemyCount: Int = 5
    private let maxEnemyCountIncrement: Int = 5
    
    private var enemySpawnRate = 2.0
    private let maxEnemySpawnRate = 0.3
    private var enemySpawnRateDecrement = 0.1
    
    private let wavePause = 3.0
    private let restartDelay = 2.0
    
    private var waveNumber: Int = 0  {
        didSet {
            waveText.text = "Wave \(waveNumber)"
        }
    }
    
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
        Enemy.killedAction.subscribe(node: self, closure: enemyKilledAction)
        
        player = childNode(withName: "player") as? Player
        player.setup()
        
        obstacle = childNode(withName: "obstacle") as? Obstacle
        obstacle.setup()
        
        waveText = childNode(withName: "waveText") as? SKLabelNode
        waveText.alpha = 0
        
        guard !disableWave else { return }
        
        self.run(SKAction.wait(forDuration: wavePause)) {
            self.startNextWave()
        }
    }
    
    override func willMove(from view: SKView) {
        Player.killedAction.unsubscribe(node: self)
        Enemy.killedAction.unsubscribe(node: self)
    }

    private func restartScene() {
        self.run (SKAction.wait (forDuration: restartDelay)) {
            GameViewController.changeScene(to: "GameScene", in: self.view!)
        }
    }
    
    private func startNextWave() {
        waveNumber += 1
        
        if waveNumber > 1 {
            enemySpawnRate -= enemySpawnRateDecrement
            enemySpawnRate = max(enemySpawnRate, maxEnemySpawnRate)
            maxEnemyCount += maxEnemyCountIncrement
        }
        
        enemiesSpawned = 0
        enemiesKilled = 0
        
        let fadeInAction = SKAction.fadeIn(withDuration: 1)
        let waitDuration = SKAction.wait(forDuration: 0.5)
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let sequenceAction = SKAction.sequence([fadeInAction, waitDuration, fadeOutAction])
        waveText.run(sequenceAction, completion: {
            self.startSpawningEnemy()
        })
    }
    
    private func startSpawningEnemy() {
        let randomNumber = Int.random(in: 1...2)
        if randomNumber == 1 {
            let enemyNode = WalkingEnemy(in: self, playerNode: player)
            enemyNode.setup()
        }
        else if randomNumber == 2 {
            let enemyNode = ShootingEnemy(in: self, playerNode: player)
            enemyNode.setup()
        }
        
        enemiesSpawned += 1
        if enemiesSpawned < maxEnemyCount {
            self.run(SKAction.wait(forDuration: enemySpawnRate)) {
                self.startSpawningEnemy()
            }
        }
    }
    
    private func enemyKilledAction() {
        enemiesKilled += 1
        if enemiesKilled >= maxEnemyCount {
            self.run(SKAction.wait(forDuration: wavePause)) {
                self.startNextWave()
            }
        }
    }
}
