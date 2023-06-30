//
//  Table.swift
//  mc2
//
//  Created by Ardli Fadhillah on 28/06/23.
//

import SpriteKit

class Table: Obstacle {
    private var highlight: SKSpriteNode!
    private var ingredientParent: SKNode!
    private var spawnPositions = [SKNode]()
    private var ingredientCount = 0
    private var maxIngredientCount = 3
    private var ingredientCombination = ""
    
    override func setup() {
        super.setup()
        self.physicsBody?.contactTestBitMask |= PsxBitmask.circleCast
        
        highlight = self.childNode(withName: "highlight") as? SKSpriteNode
        highlight.isHidden = true
        highlight.alpha = 1.0
        
        let positionParent = self.childNode(withName: "positions")!
        for position in positionParent.children {
            spawnPositions.append(position)
        }
        ingredientParent = self.childNode(withName: "ingredients")
    }
    
    func toggleHighlight(enabled: Bool) {
        highlight.isHidden = !enabled
    }
    
    func insertIngredient(type: IngredientType) {
        if ingredientCount >= maxIngredientCount { return }
        
        let ingredient = Ingredient()
        ingredient.spawn(in: ingredientParent, type: type)
        let spawnPos = spawnPositions[ingredientCount]
        ingredient.globalPosition = spawnPos.globalPosition
        
        ingredientCombination += ingredient.stringRepresentation
        ingredientCount += 1
        
        if ingredientCount >= maxIngredientCount {
            if PowerupManager.shared.activatePowerups.keys.contains(where: { $0 == ingredientCombination }) {
                PowerupManager.shared.activatePowerups[ingredientCombination]!()
            }
            
            ingredientCount = 0
            ingredientCombination = ""
            ingredientParent.removeAllChildren()
        }
    }
}
