//
//  Chef.swift
//  mc2
//
//  Created by Ardli Fadhillah on 27/06/23.
//

import SpriteKit

class Chef: Player {
    var contactedIngredient: Ingredient? = nil
    var ingredientSprite: SKSpriteNode!
    
    override func setup() {
        super.setup()
        
        self.moveSpeed = 212.5
        self.ingredientSprite = self.childNode(withName: "ingredientSprite") as? SKSpriteNode
        self.ingredientSprite.alpha = 1.0
        self.ingredientSprite.isHidden = true
        
        self.physicsBody?.categoryBitMask = PsxBitmask.player
        self.physicsBody?.collisionBitMask = PsxBitmask.obstacle | PsxBitmask.player
        self.physicsBody?.contactTestBitMask = PsxBitmask.enemy | PsxBitmask.enemyBullet
        
        InputManager.buttonAPressed.subscribe(node: self, closure: pickupOrDropIngredient)
    }
    
    func pickupOrDropIngredient() {
        if !ingredientSprite.isHidden {
            ingredientSprite.isHidden = true
            
            let ingredient = Ingredient()
            ingredient.position = self.position
            ingredient.spawn(in: self.scene!, color: ingredientSprite.color)
        }
        
        if let contactedIngredient {
            ingredientSprite.texture = contactedIngredient.texture
            ingredientSprite.color = contactedIngredient.color
            ingredientSprite.isHidden = false
            contactedIngredient.onContactExit(with: self)
            contactedIngredient.destroy()
        }
    }
    
    override func destroy() {
        InputManager.buttonAPressed.unsubscribe(node: self)
        super.destroy()
    }
}
