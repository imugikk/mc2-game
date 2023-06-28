//
//  Chef.swift
//  mc2
//
//  Created by Ardli Fadhillah on 27/06/23.
//

import SpriteKit

class Chef: Player {
    var contactedIngredient: Ingredient? = nil
    var heldIngredient: Ingredient? = nil
    var ingredientHolder: SKNode!
    
    var isHoldingIngredient: Bool {
        heldIngredient != nil
    }
    var isTouchingTable = false
    
    override func setup() {
        super.setup()
        
        self.moveSpeed = 212.5
        self.ingredientHolder = self.childNode(withName: "ingredientHolder")
        
        self.physicsBody?.contactTestBitMask |= PsxBitmask.ingredient
        
        InputManager.buttonAPressed.subscribe(node: self, closure: pickupOrDropIngredient)
    }
        
    func pickupOrDropIngredient() {
        if let contactedIngredient, !isHoldingIngredient {
            pickupIngredient(contactedIngredient)
        }
        else if let heldIngredient, !isTouchingTable {
            dropIngredient(heldIngredient)
        }
        else if let heldIngredient, isTouchingTable {
            placeIngredient(heldIngredient)
        }
    }
    
    func pickupIngredient(_ contactedIngredient: Ingredient) {
        let heldIngredient = Ingredient()
        heldIngredient.spawn(in: ingredientHolder, type: contactedIngredient.type)
        heldIngredient.globalPosition = ingredientHolder.globalPosition
        self.heldIngredient = heldIngredient

        contactedIngredient.pickUpText.hide()
        contactedIngredient.destroy()
        self.contactedIngredient = nil
    }
    
    func dropIngredient(_ heldIngredient: Ingredient) {
        heldIngredient.destroy()
        self.heldIngredient = nil
        
        let ingredient = Ingredient()
        ingredient.position = self.position
        ingredient.spawn(in: self.scene!, type: heldIngredient.type)
    }
    
    func placeIngredient(_ heldIngredient: Ingredient) {
        heldIngredient.destroy()
        self.heldIngredient = nil
        
        let table = scene!.childNode(withName: "table") as! Table
        table.insertIngredient(type: heldIngredient.type)
        
        table.toggleHighlight(enabled: false)
        isTouchingTable = false
        checkCollisionWIthIngredient()
    }
    
    func checkCollisionWIthIngredient() {
        if let chefBody = self.physicsBody {
            let contactedIngredients = chefBody.allContactedBodies().filter({ $0.node is Ingredient })
            if contactedIngredients.count > 0 {
                let ingredient = contactedIngredients.last!.node as! Ingredient
                ingredient.touchesPlayerBegin(chef: self)
            }
        }
    }
    
    override func destroy() {
        InputManager.buttonAPressed.unsubscribe(node: self)
        super.destroy()
    }
}
