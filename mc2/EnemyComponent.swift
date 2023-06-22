////
////  EnemyComponent.swift
////  mc2
////
////  Created by Tiffany Angela Indryani on 13/06/23.
////
//
//import Foundation
//import GameplayKit
//
//class EnemyComponent: GKComponent {
//    let node: SKSpriteNode
//    let targetEntity: GKEntity
//    let speed: CGFloat = 150.0
//    let scene: SKScene
//    var health: Int
//    let obstacleEntities: [GKAgent2D]
//    let agent: GKAgent2D
//
//    init(node: SKSpriteNode, targetEntity: GKEntity, scene: SKScene, health: Int, obstacleEntities: [GKAgent2D]) {
//        self.node = node
//        self.targetEntity = targetEntity
//        self.scene = scene
//        self.health = health
//        self.obstacleEntities = obstacleEntities
//        self.agent = GKAgent2D()
//        
//        super.init()
//        
//        // Configure agent properties
//        agent.radius = Float(node.size.width) * 0.5
//        agent.position = vector2(Float(node.position.x), Float(node.position.y))
//        agent.maxSpeed = Float(speed)
//        agent.delegate = self
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func update(deltaTime: TimeInterval) {
//        if let targetNode = targetEntity.component(ofType: PlayerComponent.self)?.node {
//            let direction = CGPoint(x: targetNode.position.x - node.position.x, y: targetNode.position.y - node.position.y)
//            let length = sqrt(direction.x * direction.x + direction.y * direction.y)
//            let normalizedDirection = CGPoint(x: direction.x / length, y: direction.y / length)
//            
//            let velocity = CGVector(dx: normalizedDirection.x * speed * CGFloat(deltaTime), dy: normalizedDirection.y * speed * CGFloat(deltaTime))
//            
//            node.position = CGPoint(x: node.position.x + velocity.dx, y: node.position.y + velocity.dy)
//            
//            // Update the obstacle avoidance behavior
////            agent.behavior = obstacleAvoidanceBehavior()
////            agent.update(deltaTime: deltaTime)
//        }
//    }
//    
//    private func obstacleAvoidanceBehavior() -> GKBehavior {
//        // Create a behavior to handle obstacle avoidance
//        let behavior = GKBehavior()
//        
//        // Set the weight for obstacle avoidance
//        let obstacleAvoidanceWeight: Float = 100.0
//        
//        // Add each obstacle entity to the behavior with the obstacle avoidance weight
//        for obstacleEntity in obstacleEntities {
//            // Create a goal to avoid the obstacle entity
//            let goal = GKGoal(toAvoid: [obstacleEntity], maxPredictionTime: 1.0)
//            behavior.setWeight(obstacleAvoidanceWeight, for: goal)
//        }
//        
//        return behavior
//    }
//    
//    func takeDamage(amount: Int) {
//        
//        if health <= 0 {
//            return
//        }
//        
//        health -= amount
//        print(health)
//        
//        if health <= 0 {
//            dropItem()
//        }
//    }
//    
//    private func destroyEnemy() {
//        // Implement enemy destruction logic here
//        node.removeFromParent()
//    }
//    
//    func dropItem(){
//        let itemNode = SKSpriteNode(color: .green, size: CGSize(width: 30, height: 30))
//        let itemEntity = GKEntity()
//        let itemComponent = ItemComponent(node: itemNode)
//        itemEntity.addComponent(itemComponent)
//        scene.addChild(itemNode)
//        
//        itemNode.position = node.position
//        
//        destroyEnemy()
//    }
//}
//
//extension EnemyComponent: GKAgentDelegate {
//    func agentWillUpdate(_ agent: GKAgent) {
//        // No implementation needed
//    }
//    
//    func agentDidUpdate(_ agent: GKAgent) {
//        // Update the enemy's position based on the agent's position
//        if let agent2D = agent as? GKAgent2D {
//            node.position = CGPoint(x: CGFloat(agent2D.position.x), y: CGFloat(agent2D.position.y))
//        }
//    }
//}
