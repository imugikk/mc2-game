//
//  GameScene.swift
//  mc2
//
//  Created by Paraptughessa Premaswari on 12/06/23.
//

import SpriteKit
import GameplayKit
import GameController

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var controllerInput = (x: 0.0, y: 0.0)
    
    var controller: GCController = GCController()
    
    private var lastUpdateTime : TimeInterval = 0
    
    var player: Player!
    var ingredientNode: SKSpriteNode?
    var ingredientNode2: SKSpriteNode?
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
        player = childNode(withName: "player") as? Player
        ingredientNode = childNode(withName: "star") as? SKSpriteNode
        ingredientNode2 = childNode(withName: "star_2") as? SKSpriteNode
    }
    
    override func didMove(to view: SKView) {
        self.ObserveForGameControllers()
        
        if let view = self.view as? SKView {
            view.showsPhysics = true
        }
        
        // Set up your scene and physics world
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        // Assign the ingredient node to the Player instance
        player.ingredientNode = ingredientNode
        player.ingredientNode2 = ingredientNode2
        
        // Create your player physics body
        let playerBody = SKPhysicsBody(rectangleOf: CGSize(width: 88, height: 41))
        playerBody.categoryBitMask = 0x1
        playerBody.contactTestBitMask = 0x2
        playerBody.collisionBitMask = 0 // Disable collision with ingredients
        playerBody.isDynamic = true // Ensure player is dynamic
        playerBody.friction = 0 // Set friction to 0
        player.physicsBody = playerBody

        let ingredientBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        ingredientBody.categoryBitMask = 0x2 // Unique bitmask for the ingredient body
        ingredientBody.contactTestBitMask = 0x1 // Bitmask for bodies the enemy should detect contact with
        ingredientBody.collisionBitMask = 0 // Disable collision with ingredients
        ingredientBody.isDynamic = false // Ensure ingredient is dynamic
        ingredientBody.friction = 0 // Set friction to 0
        ingredientNode?.physicsBody = ingredientBody
        
        let ingredientBody2 = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        ingredientBody2.categoryBitMask = 0x4 // Unique bitmask for the second ingredient body
        ingredientBody2.contactTestBitMask = 0x1 // Bitmask for bodies the second ingredient should detect contact with
        ingredientBody2.collisionBitMask = 0 // Disable collision with ingredients
        ingredientBody2.isDynamic = false // Ensure the second ingredient is not dynamic
        ingredientBody2.friction = 0 // Set friction to 0
        ingredientNode2?.physicsBody = ingredientBody2
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if (bodyA.node is Player && bodyB.node == (bodyA.node as? Player)?.ingredientNode) ||
           (bodyB.node is Player && bodyA.node == (bodyB.node as? Player)?.ingredientNode) {
            // Player body contacted with ingredient body
            (bodyA.node as? Player)?.showPickupPopup(ingredientNode1: ingredientNode)
            print("test")

            // Disable collision between player and ingredient
            bodyA.collisionBitMask = 0
            bodyB.collisionBitMask = 0
        }
        
        if (bodyA.node is Player && bodyB.node == (bodyA.node as? Player)?.ingredientNode2) ||
           (bodyB.node is Player && bodyA.node == (bodyB.node as? Player)?.ingredientNode2) {
            // Player body contacted with ingredient body
            (bodyA.node as? Player)?.showPickupPopup(ingredientNode1: ingredientNode2)
            print("test")

            // Disable collision between player and ingredient
            bodyA.collisionBitMask = 0
            bodyB.collisionBitMask = 0
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if (bodyA.node is Player && bodyB.node == (bodyA.node as? Player)?.ingredientNode) ||
           (bodyB.node is Player && bodyA.node == (bodyB.node as? Player)?.ingredientNode) {
            // Player body no longer in contact with ingredient body
            (bodyA.node as? Player)?.removePickupPopup()
        }
        
        if (bodyA.node is Player && bodyB.node == (bodyA.node as? Player)?.ingredientNode2) ||
           (bodyB.node is Player && bodyA.node == (bodyB.node as? Player)?.ingredientNode2) {
            // Player body no longer in contact with ingredient body
            (bodyA.node as? Player)?.removePickupPopup()
        }
    }
    
    var timeOnLastFrame: TimeInterval = 0
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = calculateDeltaTime(from: currentTime)
        
        player.movement(hInput: controllerInput.x, vInput: controllerInput.y, deltaTime: deltaTime)
    }
    
    //calculate the time difference between the current and previous frame
    private func calculateDeltaTime(from currentTime: TimeInterval) -> TimeInterval {
        if timeOnLastFrame.isZero { timeOnLastFrame = currentTime }
        let deltaTime = currentTime - timeOnLastFrame
        timeOnLastFrame = currentTime
        return deltaTime
    }
}
