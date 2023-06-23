//
//  WaveManager.swift
//  mc2
//
//  Created by Ardli Fadhillah on 22/06/23.
//

import SpriteKit

class WaveManager {
    private let disableWave = false
    
    private var gameScene: GameScene
    private var waveText: SKLabelNode!
    
    private var enemiesSpawned: Int = 0
    private var enemiesKilled: Int = 0
    
    private var maxEnemyCount: Int = 5
    private let maxEnemyCountIncrement: Int = 5
    
    private var enemySpawnRate = 2.0
    private let maxEnemySpawnRate = 0.3
    private var enemySpawnRateDecrement = 0.1
    
    private let wavePause = 3.0
    
    private var waveNumber: Int = 0  {
        didSet {
            waveText.text = "Wave \(waveNumber)"
        }
    }
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
    }
    
    func start() {
        waveText = gameScene.childNode(withName: "waveText") as? SKLabelNode
        waveText.alpha = 0
        
        Enemy.killedAction.subscribe(node: gameScene, closure: enemyKilledAction)
        
        guard !disableWave else { return }
        
        gameScene.run(SKAction.wait(forDuration: wavePause)) {
            self.startNextWave()
        }
    }
    
    func stop() {
        Enemy.killedAction.unsubscribe(node: gameScene)
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
            let enemyNode = WalkingEnemy(in: gameScene, playerNode: gameScene.player)
            enemyNode.spawn()
        }
        else if randomNumber == 2 {
            let enemyNode = ShootingEnemy(in: gameScene, playerNode: gameScene.player)
            enemyNode.spawn()
        }
        
        enemiesSpawned += 1
        if enemiesSpawned < maxEnemyCount {
            gameScene.run(SKAction.wait(forDuration: enemySpawnRate)) {
                self.startSpawningEnemy()
            }
        }
    }
    
    private func enemyKilledAction() {
        enemiesKilled += 1
        ScoreManager.shared.increaseScore(amount: 1)
        if enemiesKilled >= maxEnemyCount {
            gameScene.run(SKAction.wait(forDuration: wavePause)) {
                self.startNextWave()
            }
        }
    }
}
