////
////  EnemyEntity.swift
////  mc2
////
////  Created by Tiffany Angela Indryani on 21/06/23.
////
//
//import Foundation
//import GameplayKit
//
//class EnemyEntity: GKEntity {
//    init(node: SKSpriteNode, targetEntity: GKEntity, health: Int, agent: GKAgent2D) {
//        super.init()
//        
//        let visualComponent = VisualComponent(node: node)
//        let enemyComponent = EnemyComponent(node: node, targetEntity: targetEntity, health: health, agent: agent)
//        let followPlayerComponent = FollowPlayerComponent(targetEntity: targetEntity)
//        
//        addComponent(visualComponent)
//        addComponent(enemyComponent)
//        addComponent(followPlayerComponent)
//    }
//}
//
