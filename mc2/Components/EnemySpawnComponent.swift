////
////  EnemySpawnComponent.swift
////  mc2
////
////  Created by Tiffany Angela Indryani on 22/06/23.
////
//
//import GameplayKit
//
//class EnemySpawnComponent: GKComponent {
//    let entityManager: GKComponentSystem<GKComponent>
//    let targetEntity: GKEntity
//    let spawnRate: TimeInterval
//    let maxEnemies: Int
//    let initialDelay: TimeInterval
//    var elapsedTime: TimeInterval = 0
//    var enemyCount: Int = 0
//    
//    init(entityManager: GKComponentSystem<GKComponent>, targetEntity: GKEntity, spawnRate: TimeInterval, maxEnemies: Int, initialDelay: TimeInterval) {
//        self.entityManager = entityManager
//        self.targetEntity = targetEntity
//        self.spawnRate = spawnRate
//        self.maxEnemies = maxEnemies
//        self.initialDelay = initialDelay
//        super.init()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func update(deltaTime seconds: TimeInterval) {
//        elapsedTime += seconds
//        
//        if elapsedTime >= initialDelay {
//            let shouldSpawnEnemy = elapsedTime.truncatingRemainder(dividingBy: spawnRate) < seconds
//            if shouldSpawnEnemy && enemyCount < maxEnemies {
//                spawnEnemy()
//                enemyCount += 1
//            }
//        }
//    }
//    
//    private func spawnEnemy() {
//        guard let visualComponent = entity?.component(ofType: VisualComponent.self) else {
//            return
//        }
//        
//        let enemyNode = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
//        enemyNode.position = randomSpawnPosition()
//        visualComponent.node.addChild(enemyNode)
//        
//        let enemyEntity = GKEntity()
//        enemyEntity.addComponent(VisualComponent(node: enemyNode))
//        
//        let enemyComponent = EnemyComponent(node: enemyNode, targetEntity: targetEntity, scene: self, health: 3, obstacleEntities: obstacleEntities)
//        enemyEntity.addComponent(enemyComponent)
//        
//        entityManager.addComponent(EnemyChaseComponent(targetEntity: targetEntity), to: enemyEntity)
//        entityManager.addComponent(EnemyBehaviorComponent(), to: enemyEntity)
//        entityManager.addComponent(HealthComponent(maxHealth: 100), to: enemyEntity)
//        
//        entityManager.addComponent(EnemySpawnComponent(entityManager: entityManager, targetEntity: targetEntity, spawnRate: spawnRate, maxEnemies: maxEnemies, initialDelay: initialDelay), to: enemyEntity)
//        
//        entityManager.add(enemyEntity)
//        
//        enemyCount += 1
//        if enemyCount < maxEnemies {
//            self.run(SKAction.wait(forDuration: spawnRate)) {
//                self.spawnEnemy()
//            }
//        }
//    }
//    
//    private func randomSpawnPosition() -> CGPoint {
//        // Customize this method to generate random spawn positions within your game scene
//        // For example, you can use the size of the game scene or specific spawn areas.
//        let sceneSize = CGSize(width: 800, height: 600)
//        let x = CGFloat.random(in: 0...sceneSize.width)
//        let y = CGFloat.random(in: 0...sceneSize.height)
//        return CGPoint(x: x, y: y)
//    }
//}
//
