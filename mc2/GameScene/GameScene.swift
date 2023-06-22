//
//  GameScene.swift
//  mc2
//
//  Created by Paraptughessa Premaswari on 12/06/23.
//

import SpriteKit
import GameController

class GameScene: SKScene {
    private var controller: GCController = GCController()
    
    private var player: Player!
    private var obstacle: SKSpriteNode!
    private var waveLabel: SKLabelNode!
    
    private var restartDelay = 2.0
    private var enemiesSpawned: Int = 0
    private var enemiesKilled: Int = 0
    private var maxEnemiesPerWave: Int = 5
    private var enemySpawnRate: TimeInterval = 2.0
    private var maxEnemySpawnRate: TimeInterval = 0.3
    private var wavePause: TimeInterval = 3.0
    
    private var waveNumber: Int = 0  {
        didSet {
            waveLabel.text = "Wave \(waveNumber)"
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
        physicsWorld.contactDelegate = self
        
        player = childNode(withName: "player") as? Player
        player.setup(killedAction: restartScene)
        
        waveLabel = childNode(withName: "waveText") as? SKLabelNode
        waveLabel.alpha = 0
        
        obstacle = childNode(withName: "obstacle") as? SKSpriteNode
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = CBitMask.obstacle
        obstacle.physicsBody?.collisionBitMask = CBitMask.player
        obstacle.physicsBody?.contactTestBitMask = CBitMask.bullet
        
        WalkingEnemy.killedAction.subscribe(node: self, closure: enemyKilledAction)
        
        self.run(SKAction.wait(forDuration: wavePause)) {
            self.startNextWave()
        }
    }
    override func willMove(from view: SKView) {
        WalkingEnemy.killedAction.unsubscribe(node: self)
    }

    override func update(_ currentTime: TimeInterval) {
        let deltaTime = calculateDeltaTime(from: currentTime)
        
        self.traverseNodes { node in
            if let process = node as? Processable {
                process.update(deltaTime: deltaTime)
            }
        }
    }

    //calculate the time difference between the current and previous frame
    private var timeOnLastFrame: TimeInterval = 0
    private func calculateDeltaTime(from currentTime: TimeInterval) -> TimeInterval {
        if timeOnLastFrame.isZero { timeOnLastFrame = currentTime }
        let deltaTime = currentTime - timeOnLastFrame
        timeOnLastFrame = currentTime
        return deltaTime
    }

    override func keyDown(with event: NSEvent) {
        if event.keyCode == 49 { //Spacebar
//            player.decreaseHealth(damage: 1)
        }
    }

    private func restartScene() {
        self.run (SKAction.wait (forDuration: restartDelay)) {
            GameViewController.changeScene(to: "GameScene", in: self.view!)
        }
    }
    
    private func startNextWave() {
        waveNumber += 1
        
        if waveNumber > 1 {
            enemySpawnRate -= 0.1
            enemySpawnRate = max(enemySpawnRate, maxEnemySpawnRate)
            maxEnemiesPerWave += 5
        }
        
        enemiesSpawned = 0
        enemiesKilled = 0
        
        let fadeInAction = SKAction.fadeIn(withDuration: 1)
        let waitDuration = SKAction.wait(forDuration: 0.5)
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let sequenceAction = SKAction.sequence([fadeInAction, waitDuration, fadeOutAction])
        waveLabel.run(sequenceAction, completion: {
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
        if enemiesSpawned < maxEnemiesPerWave {
            self.run(SKAction.wait(forDuration: enemySpawnRate)) {
                self.startSpawningEnemy()
            }
        }
    }
    
    private func enemyKilledAction() {
        enemiesKilled += 1
        if enemiesKilled >= maxEnemiesPerWave {
            self.run(SKAction.wait(forDuration: wavePause)) {
                self.startNextWave()
            }
        }
    }
}
