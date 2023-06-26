//
//  Player.swift
//  mc2
//
//  Created by Ardli Fadhillah on 13/06/23.
//

import SpriteKit
import SwiftUI

class Player: SKSpriteNode {
    
    let moveSpeed = 200.0
    var ingredientNode: SKSpriteNode?
    var ingredientNode2: SKSpriteNode?
    var ingredientNode3: SKSpriteNode?
    var popupLabel: SKLabelNode?
    var ingredientImage: SKSpriteNode?
    var ingredientImageHold: SKSpriteNode?
    
    var heldIngredient: SKSpriteNode?
    var pickIngredient: SKSpriteNode?
    
    var kitchen1: SKSpriteNode?
    var kitchen2: SKSpriteNode?
    var kitchen3: SKSpriteNode?
    var isPut1: Bool = false
    var isPut2: Bool = false
    var isPut3: Bool = false
    var colorIngredient: [Color] = [.white, .white, .white]
//    var isPlace1: Bool = false
//    var isPlace2: Bool = false
//    var isPlace3: Bool = false
    
    func movement(hInput: Double, vInput: Double, deltaTime: Double) {
        let direction = CGPoint(x: hInput, y: vInput).normalized()
        let movement = moveSpeed * deltaTime * direction
        self.position += movement
    
        ingredientImageHold?.position = CGPoint(x: self.position.x, y: self.position.y + 50)
    }
    
    func showPickupPopup(ingredientNode1: SKSpriteNode?) {
        // Check if the pickup popup label already exists
        if let popupLabel = self.scene?.childNode(withName: "pickupLabel") as? SKLabelNode {
            popupLabel.removeFromParent() // Remove existing label
        }
        
        let popupLabel = SKLabelNode(text: "Press A to pick up")
        popupLabel.name = "pickupLabel" // Set a name for easy identification
        let offset: CGFloat = 20 // Adjust the offset as needed
        let ingredientPositionInScene = ingredientNode1?.convert(CGPoint.zero, to: self.scene!)
        popupLabel.position = CGPoint(x: ingredientPositionInScene?.x ?? 0, y: (ingredientPositionInScene?.y ?? 0) + ingredientNode1!.size.height/2 + offset)
        popupLabel.fontSize = 24
        popupLabel.fontColor = SKColor.white
        if !(isPut1 || isPut2 || isPut3) {
            self.scene?.addChild(popupLabel)
        }
        
        heldIngredient = ingredientNode1
    }
    
    func removePickupPopup() {
        if let popupLabel = self.scene?.childNode(withName: "pickupLabel") as? SKLabelNode {
            popupLabel.removeFromParent()
        }
        
        heldIngredient = nil
    }
    
    func handlePickupAction() {
        if let ingredientImage = self.ingredientImage {
            // Remove ingredient image from the scene
            ingredientImage.removeFromParent()
            ingredientImageHold?.removeFromParent()
            
            self.ingredientImage = nil

            // Respawn ingredient at player's position
            if let pickIngredient = pickIngredient {
                var newPosition = self.position
                
                if isPut1 {
                    newPosition = kitchen1!.position
                    colorIngredient[0] = Color(pickIngredient.color)
                    print("test: \(colorIngredient[0])")
                } else if isPut2 {
                    newPosition = kitchen2!.position
                    colorIngredient[1] = Color(pickIngredient.color)
                    print("test: \(colorIngredient[1])")
                } else if isPut3 {
                    newPosition = kitchen3!.position
                    colorIngredient[2] = Color(pickIngredient.color)
                    print("test: \(colorIngredient[2])")
                }
                
                pickIngredient.position = newPosition
                self.scene?.addChild(pickIngredient)
            }
        }
        
        if let playerPhysicsBody = self.physicsBody, let ingredientPhysicsBody = heldIngredient?.physicsBody {
            if playerPhysicsBody.allContactedBodies().contains(ingredientPhysicsBody) {
                // Remove ingredient from the scene
                if heldIngredient == ingredientNode {
                    ingredientNode?.removeFromParent()
                } else if heldIngredient == ingredientNode2 {
                    ingredientNode2?.removeFromParent()
                } else if heldIngredient == ingredientNode3 {
                    ingredientNode3?.removeFromParent()
                }
                
                pickIngredient = heldIngredient
                
                // Remove pickup label
                removePickupPopup()

                // Create image node for the ingredient UI
                if pickIngredient == ingredientNode2 {
                    ingredientImage = SKSpriteNode(imageNamed: "Star-2")
                    ingredientImageHold = SKSpriteNode(imageNamed: "Star-2")
                } else if pickIngredient == ingredientNode {
                    ingredientImage = SKSpriteNode(imageNamed: "Star")
                    ingredientImageHold = SKSpriteNode(imageNamed: "Star")
                } else if pickIngredient == ingredientNode3 {
                    ingredientImage = SKSpriteNode(imageNamed: "Star-3")
                    ingredientImageHold = SKSpriteNode(imageNamed: "Star-3")
                }

                ingredientImage?.size = CGSize(width: 50, height: 50) // Set the desired size here
                ingredientImage?.position = CGPoint(x: self.scene!.size.width/2 - 50, y: self.scene!.size.height/2 - 50)
                self.scene?.addChild(ingredientImage!)
                
                ingredientImageHold?.size = CGSize(width: 50, height: 50) // Set the desired size here
                self.scene?.addChild(ingredientImageHold!)

            }
        }
        
        print("test gih \(colorIngredient[0])_\(colorIngredient[1])_\(colorIngredient[2])")
        if (colorIngredient[0] == .yellow) && (colorIngredient[1] == .blue) && ( colorIngredient[2] == .green) {
            print("test gih")
        }
    }
}
