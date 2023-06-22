////
////  ObstacleComponent.swift
////  mc2
////
////  Created by Tiffany Angela Indryani on 20/06/23.
////
//
//import Foundation
//import GameplayKit
//
//class ObstacleComponent: GKComponent {
//    let node: SKSpriteNode
//    let agent: GKAgent2D
//    
//    init(node: SKSpriteNode) {
//        self.node = node
//        self.agent = GKAgent2D()
//        
//        super.init()
//        
//        configureAgent()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func configureAgent() {
//        // Set up agent properties
//        agent.radius = 25.0 // Adjust the radius as needed
//        agent.mass = 1.0 // Adjust the mass as needed
//        
//        // Set the agent's position based on the node's position
//        agent.position = vector_float2(Float(node.position.x), Float(node.position.y))
//        
//        // Set the agent's delegate to this component
//        agent.delegate = self
//    }
//}
//
//extension ObstacleComponent: GKAgentDelegate {
//    func agentDidUpdate(_ agent: GKAgent) {
//        // Update the node's position based on the agent's position
//        if let agent2D = agent as? GKAgent2D {
//            node.position = CGPoint(x: CGFloat(agent2D.position.x), y: CGFloat(agent2D.position.y))
//        }
//    }
//}
//
//
