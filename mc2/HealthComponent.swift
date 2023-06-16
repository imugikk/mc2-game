////
////  HealthComponent.swift
////  mc2
////
////  Created by Tiffany Angela Indryani on 15/06/23.
////
//
//import GameplayKit
//
//class HealthComponent: GKComponent {
//    var maxHealth: Int
//    var currentHealth: Int
//    
//    init(maxHealth: Int) {
//        self.maxHealth = maxHealth
//        self.currentHealth = maxHealth
//        
//        super.init()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func takeDamage(amount: Int) {
//        currentHealth -= amount
//        
//        if currentHealth <= 0 {
//            // Enemy is defeated
//            entity?.component(ofType: EnemyComponent.self)?.dropItem()
//            entity?.component(ofType: EnemyComponent.self)?.destroyEnemy()
//        }
//    }
//}
//
