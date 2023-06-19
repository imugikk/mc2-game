//
//  GameScene.swift
//  mc2
//
//  Created by Paraptughessa Premaswari on 12/06/23.
//

import SpriteKit
import GameplayKit
import GameController

enum bitMask: UInt32 {
    case player = 0x1
    case ingredient = 0x2
    case square = 0x5
    case raycast = 0x8
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var controllerInput = (x: 0.0, y: 0.0)
    
    var controller: GCController = GCController()
    
    private var lastUpdateTime : TimeInterval = 0
    
    var player: Player!
    var ingredientNode: SKSpriteNode?
    var ingredientNode2: SKSpriteNode?
    var ingredientNode3: SKSpriteNode?
    var highlight: SKSpriteNode?
    
    var square_1: SKSpriteNode?
    var square_2: SKSpriteNode?
    var square_3: SKSpriteNode?
    
    var ray: SKPhysicsBody!
    
    var gameover: Bool = false
    var lastRayPos = CGPoint(x: 0, y: 0)
    var leftJoystickInput1 = (x: 0.0, y: 0.0)
    
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
        player = childNode(withName: "player") as? Player
        ingredientNode = childNode(withName: "star") as? SKSpriteNode
        ingredientNode2 = childNode(withName: "star_2") as? SKSpriteNode
        ingredientNode3 = childNode(withName: "star_3") as? SKSpriteNode
        
        square_1 = childNode(withName: "square_1") as? SKSpriteNode
        square_2 = childNode(withName: "square_2") as? SKSpriteNode
        square_3 = childNode(withName: "square_3") as? SKSpriteNode
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
        player.ingredientNode3 = ingredientNode3
        
        // Create your player physics body
        let playerBody = SKPhysicsBody(rectangleOf: CGSize(width: 88, height: 41))
        playerBody.categoryBitMask = bitMask.player.rawValue
        playerBody.contactTestBitMask = bitMask.ingredient.rawValue
        playerBody.collisionBitMask = bitMask.square.rawValue
        playerBody.isDynamic = true // Ensure player is dynamic
        playerBody.friction = 0 // Set friction to 0
        playerBody.allowsRotation = false
        player.physicsBody = playerBody

        let ingredientBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        ingredientBody.categoryBitMask = bitMask.ingredient.rawValue // Unique bitmask for the ingredient body
        ingredientBody.contactTestBitMask = bitMask.player.rawValue // Bitmask for bodies the enemy should detect contact with
        ingredientBody.collisionBitMask = 0
        ingredientBody.isDynamic = false // Ensure ingredient is dynamic
        ingredientBody.friction = 0 // Set friction to 0
        ingredientNode?.physicsBody = ingredientBody
        
        let ingredientBody2 = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        ingredientBody2.categoryBitMask = bitMask.ingredient.rawValue // Unique bitmask for the second ingredient body
        ingredientBody2.contactTestBitMask = bitMask.player.rawValue // Bitmask for bodies the second ingredient should detect contact with
        ingredientBody2.collisionBitMask = 0
        ingredientBody2.isDynamic = false // Ensure the second ingredient is not dynamic
        ingredientBody2.friction = 0 // Set friction to 0
        ingredientNode2?.physicsBody = ingredientBody2
        
        let ingredientBody3 = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        ingredientBody3.categoryBitMask = bitMask.ingredient.rawValue // Unique bitmask for the second ingredient body
        ingredientBody3.contactTestBitMask = bitMask.player.rawValue // Bitmask for bodies the second ingredient should detect contact with
        ingredientBody3.collisionBitMask = 0
        ingredientBody3.isDynamic = false // Ensure the second ingredient is not dynamic
        ingredientBody3.friction = 0 // Set friction to 0
        ingredientNode3?.physicsBody = ingredientBody3

        let squareBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        squareBody.categoryBitMask = bitMask.square.rawValue // Unique bitmask for the second ingredient body
        squareBody.contactTestBitMask = bitMask.raycast.rawValue // Bitmask for bodies the second ingredient should detect contact with
        squareBody.collisionBitMask = bitMask.player.rawValue
        squareBody.isDynamic = false // Ensure the second ingredient is not dynamic
        squareBody.friction = 0 // Set friction to 0
        square_1?.physicsBody = squareBody

        let squareBody2 = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        squareBody2.categoryBitMask = bitMask.square.rawValue // Unique bitmask for the second ingredient body
        squareBody2.contactTestBitMask = bitMask.raycast.rawValue // Bitmask for bodies the second ingredient should detect contact with
        squareBody2.collisionBitMask = bitMask.player.rawValue
        squareBody2.isDynamic = false // Ensure the second ingredient is not dynamic
        squareBody2.friction = 0 // Set friction to 0
        square_2?.physicsBody = squareBody2

        let squareBody3 = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        squareBody3.categoryBitMask = bitMask.square.rawValue // Unique bitmask for the second ingredient body
        squareBody3.contactTestBitMask = bitMask.raycast.rawValue // Bitmask for bodies the second ingredient should detect contact with
        squareBody3.collisionBitMask = bitMask.player.rawValue
        squareBody3.isDynamic = false // Ensure the second ingredient is not dynamic
        squareBody3.friction = 0 // Set friction to 0
        square_3?.physicsBody = squareBody3

    }

    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        let categoryA = contact.bodyA.categoryBitMask
        let categoryB = contact.bodyB.categoryBitMask
        
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
        
        if (bodyA.node is Player && bodyB.node == (bodyA.node as? Player)?.ingredientNode3) ||
           (bodyB.node is Player && bodyA.node == (bodyB.node as? Player)?.ingredientNode3) {
            // Player body contacted with ingredient body
            (bodyA.node as? Player)?.showPickupPopup(ingredientNode1: ingredientNode3)
            print("test")

            // Disable collision between player and ingredient
            bodyA.collisionBitMask = 0
            bodyB.collisionBitMask = 0
        }
        
//        if (categoryA == bitMask.raycast.rawValue && categoryB == bitMask.square_1.rawValue) {
//            highlight = childNode(withName: "highlight") as? SKSpriteNode
//            highlight?.position = contact.bodyB.node!.position
//
//            self.scene?.addChild(highlight!)
//        } else {
//            highlight?.removeFromParent()
//        }
        
        // Enable collision between player and ingredient
        bodyA.collisionBitMask = 1
        bodyB.collisionBitMask = 1
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if (bodyA.node is Player && bodyB.node == (bodyA.node as? Player)?.ingredientNode) ||
           (bodyB.node is Player && bodyA.node == (bodyB.node as? Player)?.ingredientNode) ||
            (bodyA.node is Player && bodyB.node == (bodyA.node as? Player)?.ingredientNode2) ||
               (bodyB.node is Player && bodyA.node == (bodyB.node as? Player)?.ingredientNode2) ||
            (bodyA.node is Player && bodyB.node == (bodyA.node as? Player)?.ingredientNode3) ||
               (bodyB.node is Player && bodyA.node == (bodyB.node as? Player)?.ingredientNode3)
        {
            // Player body no longer in contact with ingredient body
            (bodyA.node as? Player)?.removePickupPopup()
        }
    }
    
    var timeOnLastFrame: TimeInterval = 0
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = calculateDeltaTime(from: currentTime)
        
        player.movement(hInput: controllerInput.x, vInput: controllerInput.y, deltaTime: deltaTime)
        
        let lastPos = player.position
        let rayPos = CGPoint(x: lastPos.x + 70, y: lastPos.y + 70)
        
        ray = SKPhysicsBody(circleOfRadius: 10, center: rayPos)
        ray.categoryBitMask = bitMask.raycast.rawValue
        ray.contactTestBitMask = bitMask.square.rawValue
        ray.collisionBitMask = 0
        ray.isDynamic = true
        physicsBody = ray
        lastRayPos = rayPos
    }
    
    //calculate the time difference between the current and previous frame
    private func calculateDeltaTime(from currentTime: TimeInterval) -> TimeInterval {
        if timeOnLastFrame.isZero { timeOnLastFrame = currentTime }
        let deltaTime = currentTime - timeOnLastFrame
        timeOnLastFrame = currentTime
        return deltaTime
    }
}
