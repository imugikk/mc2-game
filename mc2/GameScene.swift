//
//  GameScene.swift
//  mc2
//
//  Created by Paraptughessa Premaswari on 12/06/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    private var playerEntity: GKEntity!
    private var enemyEntities: [GKEntity] = []
    private var enemyQueue: [GKEntity] = []  // Queue to store enemy entities
    private var waveNumber: Int = 0
    private var enemiesSpawned: Int = 0
    private var enemiesKilled: Int = 0
    private var maxEnemiesPerWave: Int = 10
    private var enemySpawnRate: TimeInterval = 1.0
    private var wavePause: TimeInterval = 5.0
    private var enemySpawnTimer: Timer?
    
    private var playerNode: SKSpriteNode!
    private var waveLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        playerNode = childNode(withName: "player") as? SKSpriteNode
        playerEntity = GKEntity()
        let playerComponent = PlayerComponent(node: playerNode)
        playerEntity.addComponent(playerComponent)
        
        waveLabel = childNode(withName: "waveText") as? SKLabelNode
        
        // Add physics body to the player node
        let physicsBody = SKPhysicsBody(rectangleOf: playerNode.size)
        physicsBody.affectedByGravity = false
        playerComponent.node.physicsBody = physicsBody
        playerComponent.node.physicsBody?.isDynamic = false
        
        playerComponent.node.physicsBody?.categoryBitMask = 0x1
        playerComponent.node.physicsBody?.collisionBitMask = 0
        playerComponent.node.physicsBody?.contactTestBitMask = 0x2
        
        physicsWorld.contactDelegate = self

        startNextWave()
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        // Update the player entity
        playerEntity.update(deltaTime: currentTime - (lastUpdateTime ?? currentTime))
        
        // Update the enemy entities
        for enemyEntity in enemyEntities {
            enemyEntity.update(deltaTime: currentTime - (lastUpdateTime ?? currentTime))
        }
        
        lastUpdateTime = currentTime
    }
    
    private func startNextWave() {
        waveNumber += 1
        updateWaveLabel()
        
        // Increase spawn rate and number of enemies for each wave
        if waveNumber > 1 {
            enemySpawnRate -= 0.1
            maxEnemiesPerWave += 5
        }
        
        // Reset enemies spawned and killed count
        enemiesSpawned = 0
        enemiesKilled = 0
        
        // Schedule enemy spawning timer
        startSpawningEnemy()
    }
    
    private func startSpawningEnemy() {
        // Create and add enemy entity
        let enemyNode = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
        let enemyEntity = GKEntity()
        let enemyComponent = EnemyComponent(node: enemyNode, targetEntity: playerEntity, scene: self, health: 3)
        enemyEntity.addComponent(enemyComponent)
        enemyEntities.append(enemyEntity)
        enemyQueue.append(enemyEntity)  // Add the enemy entity to the queue
        addChild(enemyNode)
        
        // Position enemy randomly outside the frame
        enemyNode.position = getRandomPositionOutsideFrame()
        
        enemiesSpawned += 1
        if enemiesSpawned < maxEnemiesPerWave {
            self.run(SKAction.wait(forDuration: enemySpawnRate)) {
                self.startSpawningEnemy()
            }
        }
    }
    
    private func updateWaveLabel() {
        waveLabel.text = "Wave: \(waveNumber)"
    }

    private func getRandomPositionOutsideFrame() -> CGPoint {
        let playableRect = frame.insetBy(dx: -frame.size.width/2, dy: -frame.size.height/2)
        let randomEdge = arc4random_uniform(4) // Randomly select one of the four edges
        var randomX: CGFloat = 0.0
        var randomY: CGFloat = 0.0
        
        switch randomEdge {
        case 0: // Top edge
            randomX = CGFloat.random(in: playableRect.minX...playableRect.maxX)
            randomY = playableRect.maxY
        case 1: // Bottom edge
            randomX = CGFloat.random(in: playableRect.minX...playableRect.maxX)
            randomY = playableRect.minY
        case 2: // Left edge
            randomX = playableRect.minX
            randomY = CGFloat.random(in: playableRect.minY...playableRect.maxY)
        case 3: // Right edge
            randomX = playableRect.maxX
            randomY = CGFloat.random(in: playableRect.minY...playableRect.maxY)
        default:
            break
        }
        
        return CGPoint(x: randomX, y: randomY)
    }
    
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 49 {
            if !enemyQueue.isEmpty {
                let enemyEntity = enemyQueue.removeFirst()
                enemyEntity.component(ofType: EnemyComponent.self)?.takeDamage(amount: 1)
                enemyEntity.component(ofType: EnemyComponent.self)?.dropItem()
                enemiesKilled += 1
            }
                        
            if enemiesKilled >= maxEnemiesPerWave {
                // All enemies for the wave have been killed
                self.run(SKAction.wait(forDuration: wavePause)) {
                    self.startNextWave()
                }
            }
        }
        if let playerComponent = playerEntity.component(ofType: PlayerComponent.self) {
            switch event.keyCode {
            case 2: // "D" key
                playerComponent.node.position.x += 30 // Adjust the position as needed
            default:
                print("keydown: \(event.characters!) keyCode: \(event.keyCode)")
            }
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        // Check if the bodies belong to the nodes you are interested in
        if bodyA.categoryBitMask == 0x1 && bodyB.categoryBitMask == 0x2 {
            // Handle the collision between an enemy and a bullet
            playerNodeHitByBullet(playerBody: bodyA, bulletBody: bodyB)
        } else if bodyA.categoryBitMask == 0x2 && bodyB.categoryBitMask == 0x1 {
            // Handle the collision between an enemy and a bullet
            playerNodeHitByBullet(playerBody: bodyB, bulletBody: bodyA)
        }
    }
    
    func playerNodeHitByBullet(playerBody: SKPhysicsBody, bulletBody: SKPhysicsBody) {
        // Get the enemy node and bullet node from their respective bodies
        guard let bulletNode = bulletBody.node as? SKSpriteNode else {
            return
        }
        
        bulletNode.removeFromParent()
    }
        
    private var lastUpdateTime: TimeInterval?
    
}
