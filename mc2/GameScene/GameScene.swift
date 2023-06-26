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
    
    var controllerInput = CGPoint(x: 0.0, y: 0.0)
    
    var controller: GCController = GCController()
    
    private var lastUpdateTime : TimeInterval = 0
    
    var player: Player!
    var ingredientNode: SKSpriteNode?
    var ingredientNode2: SKSpriteNode?
    var ingredientNode3: SKSpriteNode?
    
    var square_1: SKSpriteNode?
    var square_2: SKSpriteNode?
    var square_3: SKSpriteNode?
    
    var ray: SKNode!
    
    var gameover: Bool = false
    var rayPos = CGPoint(x: 0, y: 0)
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
        player.ingredientNode?.color = .yellow
        player.ingredientNode2 = ingredientNode2
        player.ingredientNode2?.color = .blue
        player.ingredientNode3 = ingredientNode3
        player.ingredientNode3?.color = .green
        player.kitchen1 = square_1
        player.kitchen2 = square_2
        player.kitchen3 = square_3
        
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
        square_1?.name = "square_1"

        let squareBody2 = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        squareBody2.categoryBitMask = bitMask.square.rawValue // Unique bitmask for the second ingredient body
        squareBody2.contactTestBitMask = bitMask.raycast.rawValue // Bitmask for bodies the second ingredient should detect contact with
        squareBody2.collisionBitMask = bitMask.player.rawValue
        squareBody2.isDynamic = false // Ensure the second ingredient is not dynamic
        squareBody2.friction = 0 // Set friction to 0
        square_2?.physicsBody = squareBody2
        square_2?.name = "square_2"

        let squareBody3 = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        squareBody3.categoryBitMask = bitMask.square.rawValue // Unique bitmask for the second ingredient body
        squareBody3.contactTestBitMask = bitMask.raycast.rawValue // Bitmask for bodies the second ingredient should detect contact with
        squareBody3.collisionBitMask = bitMask.player.rawValue
        squareBody3.isDynamic = false // Ensure the second ingredient is not dynamic
        squareBody3.friction = 0 // Set friction to 0
        square_3?.physicsBody = squareBody3
        square_3?.name = "square_3"
        
        // Create and configure the ray node
        let rayRadius: CGFloat = 10
        ray = SKShapeNode(circleOfRadius: rayRadius)
        ray.physicsBody = SKPhysicsBody(circleOfRadius: rayRadius)
        ray.physicsBody?.categoryBitMask = bitMask.raycast.rawValue
        ray.physicsBody?.contactTestBitMask = bitMask.square.rawValue
        ray.physicsBody?.collisionBitMask = 0
        ray.physicsBody?.isDynamic = true
        ray.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(ray)
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
        }
        
        if (bodyA.node is Player && bodyB.node == (bodyA.node as? Player)?.ingredientNode2) ||
           (bodyB.node is Player && bodyA.node == (bodyB.node as? Player)?.ingredientNode2) {
            // Player body contacted with ingredient body
            (bodyA.node as? Player)?.showPickupPopup(ingredientNode1: ingredientNode2)
        }
        
        if (bodyA.node is Player && bodyB.node == (bodyA.node as? Player)?.ingredientNode3) ||
           (bodyB.node is Player && bodyA.node == (bodyB.node as? Player)?.ingredientNode3) {
            // Player body contacted with ingredient body
            (bodyA.node as? Player)?.showPickupPopup(ingredientNode1: ingredientNode3)
        }
        
        print("test enter \(categoryA)_\(categoryB)")
        if (categoryA == bitMask.raycast.rawValue && categoryB == bitMask.square.rawValue) ||
            (categoryB == bitMask.raycast.rawValue && categoryA == bitMask.square.rawValue) {
            if(bodyA.node?.name == "square_1" || bodyB.node?.name == "square_1"){
                if let squareNode = childNode(withName: "square_1") as? SKSpriteNode {
                    // Change the color of the square
                    squareNode.color = .blue
                    squareNode.colorBlendFactor = 1
                }
                
                player.isPut1 = true
            } else if (bodyA.node?.name == "square_2" || bodyB.node?.name == "square_2"){
                if let squareNode = childNode(withName: "square_2") as? SKSpriteNode {
                    // Change the color of the square
                    squareNode.color = .blue
                    squareNode.colorBlendFactor = 1
                }
                player.isPut2 = true
            } else if (bodyA.node?.name == "square_3" || bodyB.node?.name == "square_3") {
                if let squareNode = childNode(withName: "square_3") as? SKSpriteNode {
                    // Change the color of the square
                    squareNode.color = .blue
                    squareNode.colorBlendFactor = 1
                }
                player.isPut3 = true
            }
                        
        }
        
    }
    
    
    func didEnd(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        let categoryA = contact.bodyA.categoryBitMask
        let categoryB = contact.bodyB.categoryBitMask
        
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
        
        print("test exit \(categoryA)_\(categoryB)")
        if (categoryA == bitMask.raycast.rawValue && categoryB == bitMask.square.rawValue) ||
            (categoryB == bitMask.raycast.rawValue && categoryA == bitMask.square.rawValue) {
            if(bodyA.node?.name == "square_1" || bodyB.node?.name == "square_1"){
                square_1?.color = .white
                player.isPut1 = false
            } else if (bodyA.node?.name == "square_2" || bodyB.node?.name == "square_2"){
                square_2?.color = .white
                player.isPut2 = false
            } else if (bodyA.node?.name == "square_3" || bodyB.node?.name == "square_3") {
                square_3?.color = .white
                player.isPut3 = false
            }
                        
        }
    }
    
    var timeOnLastFrame: TimeInterval = 0
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = calculateDeltaTime(from: currentTime)
        
        player.movement(hInput: controllerInput.x, vInput: controllerInput.y, deltaTime: deltaTime)
        
        let minJoystickInput = 0.5
//        let lastPos = (controllerInput.length() < minJoystickInput) ? lastRayPos : player.position
        let lastPos = player.position
        let offsetMultiplier: CGFloat = 60 // Adjust this value as needed for the desired offset
        let offset = CGPoint(x: controllerInput.x * offsetMultiplier, y: controllerInput.y * offsetMultiplier)
        let newRayPos = CGPoint(x: lastPos.x + offset.x, y: lastPos.y + offset.y)
        
        ray.position = newRayPos
    }
    
    //calculate the time difference between the current and previous frame
    private func calculateDeltaTime(from currentTime: TimeInterval) -> TimeInterval {
        if timeOnLastFrame.isZero { timeOnLastFrame = currentTime }
        let deltaTime = currentTime - timeOnLastFrame
        timeOnLastFrame = currentTime
        return deltaTime
    }
}
