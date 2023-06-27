//
//  GameScene.swift
//  mc2
//
//  Created by Paraptughessa Premaswari on 12/06/23.
//

import SpriteKit
import GameController

enum bitMask: UInt32 {
    case player = 0x1
    case ingredient = 0x2
    case square = 0x4
    case raycast = 0x8
}

class GameScene1: SKScene, SKPhysicsContactDelegate {
    
    var controllerInput = CGPoint(x: 0.0, y: 0.0)
    
    var player: Player!
    
    var square_1: SKSpriteNode?
    var square_2: SKSpriteNode?
    var square_3: SKSpriteNode?
    var highlight: SKSpriteNode?
    
    var ray: SKPhysicsBody!
    var lastRayPos = CGPoint(x: 0, y: 0)
    
    override func sceneDidLoad() {
        player = childNode(withName: "player") as? Player
        
        square_1 = childNode(withName: "square_1") as? SKSpriteNode
        square_2 = childNode(withName: "square_2") as? SKSpriteNode
        square_3 = childNode(withName: "square_3") as? SKSpriteNode
        
        highlight = childNode(withName: "highlight_1") as? SKSpriteNode
        highlight?.isHidden = true
    }
    
    override func didMove(to view: SKView) {
        // Create your player physics body
        let playerBody = SKPhysicsBody(rectangleOf: CGSize(width: 88, height: 41))
        playerBody.categoryBitMask = bitMask.player.rawValue
        playerBody.contactTestBitMask = bitMask.ingredient.rawValue
        playerBody.collisionBitMask = bitMask.square.rawValue
        playerBody.isDynamic = true // Ensure player is dynamic
        playerBody.friction = 0 // Set friction to 0
        playerBody.allowsRotation = false
        player.physicsBody = playerBody

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
        let categoryA = contact.bodyA.categoryBitMask
        let categoryB = contact.bodyB.categoryBitMask
        
        print("test enter \(categoryA)_\(categoryB)")
        if (categoryA == bitMask.raycast.rawValue && categoryB == bitMask.square.rawValue) ||
            (categoryB == bitMask.raycast.rawValue && categoryA == bitMask.square.rawValue) {
            highlight?.isHidden = false
        }
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let categoryA = contact.bodyA.categoryBitMask
        let categoryB = contact.bodyB.categoryBitMask
        
        print("test exit \(categoryA)_\(categoryB)")
        if (categoryA == bitMask.raycast.rawValue && categoryB == bitMask.square.rawValue) ||
            (categoryB == bitMask.raycast.rawValue && categoryA == bitMask.square.rawValue) {
            print("test exit raycast-square")
            // Perform actions when raycast ends contact with square
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        let minJoystickInput = 0.5
        let lastPos = (controllerInput.length() < minJoystickInput) ? lastRayPos : player.position
        let offsetMultiplier: CGFloat = 60 // Adjust this value as needed for the desired offset
        let offset = CGPoint(x: controllerInput.x * offsetMultiplier, y: controllerInput.y * offsetMultiplier)
        let rayPos = CGPoint(x: lastPos.x + offset.x, y: lastPos.y + offset.y)
        ray = SKPhysicsBody(circleOfRadius: 10, center: rayPos)
        ray.categoryBitMask = bitMask.raycast.rawValue
        ray.contactTestBitMask = bitMask.square.rawValue
        ray.collisionBitMask = 0
        ray.isDynamic = true
        physicsBody = ray
        lastRayPos = rayPos
    }
}
