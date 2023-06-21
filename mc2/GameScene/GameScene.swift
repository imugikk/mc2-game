//
//  GameScene.swift
//  mc2
//
//  Created by Paraptughessa Premaswari on 12/06/23.
//

import SpriteKit
import GameController

struct CBitMask {
    static let player: UInt32 = 1
    static let bullet: UInt32 = 2
    static let obstacle: UInt32 = 4
    static let enemy: UInt32 = 8
}

class GameScene: SKScene {
    private var controller: GCController = GCController()
    
    private var player: Player!
    private var weapon: Weapon!
    private var obstacle: SKSpriteNode!
    private var enemies: [WalkingEnemy] = []
    private var waveLabel: SKLabelNode!
    
    private var restartDelay = 2.0
    private var enemiesSpawned: Int = 0
    private var enemiesKilled: Int = 0
    private var maxEnemiesPerWave: Int = 10
    private var enemySpawnRate: TimeInterval = 1.0
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
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        player = childNode(withName: "player") as? Player
        player.setup(killedAction: restartScene)
        weapon = player.childNode(withName: "weaponPivot") as? Weapon
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
    
    @objc func controllerConnected() {
        // Unpause the Game if it is currently paused
        self.isPaused = false
    }
    
    @objc func controllerDisconnected() {
        // Pause the Game if a controller is disconnected ~ This is mandated by Apple
        self.isPaused = true
    }

    override func update(_ currentTime: TimeInterval) {
        let deltaTime = calculateDeltaTime(from: currentTime)

        player.update(deltaTime: deltaTime)
        weapon.update(deltaTime: deltaTime)
        
        for enemy in enemies {
            enemy.update(deltaTime: deltaTime)
            
            if enemy.destroyed {
                enemies.removeAll(where: { $0 == enemy })
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
        //Spacebar
        if event.keyCode == 49 {
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
        let enemyNode = WalkingEnemy(imageName: "Capsule", in: self, playerNode: player)
        enemies.append(enemyNode)
        
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
