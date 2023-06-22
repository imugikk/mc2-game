////
////  EnemyChaseComponent.swift
////  mc2
////
////  Created by Tiffany Angela Indryani on 22/06/23.
////
//
//import GameplayKit
//
//class EnemyChaseComponent: GKComponent {
//    let targetEntity: GKEntity
//    
//    init(targetEntity: GKEntity) {
//        self.targetEntity = targetEntity
//        super.init()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func update(deltaTime seconds: TimeInterval) {
//        guard let enemyNode = entity?.component(ofType: VisualComponent.self)?.node,
//              let targetNode = targetEntity.component(ofType: VisualComponent.self)?.node else {
//            return
//        }
//        
//        // Calculate the direction towards the target
//        let direction = CGPoint(x: targetNode.position.x - enemyNode.position.x,
//                                y: targetNode.position.y - enemyNode.position.y)
//        
//        // Normalize the direction
//        let length = hypot(direction.x, direction.y)
//        let normalizedDirection = CGPoint(x: direction.x / length, y: direction.y / length)
//        
//        // Set the enemy's velocity or position based on the direction
//        let speed: CGFloat = 150.0
//        let velocity = CGPoint(x: normalizedDirection.x * speed, y: normalizedDirection.y * speed)
//        enemyNode.position = CGPoint(x: enemyNode.position.x + velocity.x * CGFloat(seconds),
//                                     y: enemyNode.position.y + velocity.y * CGFloat(seconds))
//    }
//}
