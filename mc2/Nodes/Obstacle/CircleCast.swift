//
//  CircleCast.swift
//  mc2
//
//  Created by Ardli Fadhillah on 28/06/23.
//

import SpriteKit

class CircleCast: SKSpriteNode, PreSpawned, HandleContactEnter, HandleContactExit {
    private var chef: Chef!
    
    func setup() {
        self.physicsBody?.categoryBitMask = PsxBitmask.circleCast
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = PsxBitmask.obstacle
        
        chef = self.parent as? Chef
    }
    func onContactEnter(with other: SKNode?) {
        if let table = other as? Table {
            contactWithTable(table: table, enter: true)
        }
    }
    func onContactExit(with other: SKNode?) {
        if let table = other as? Table {
            contactWithTable(table: table, enter: false)
        }
    }
    
    func contactWithTable(table: Table, enter: Bool){
        if !chef.isHoldingIngredient { return }
        table.toggleHighlight(enabled: enter)
        chef.isTouchingTable = enter
    }
}
