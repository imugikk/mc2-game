//
//  tREE.swift
//  mc2
//
//  Created by Paraptughessa Premaswari on 28/06/23.
//

import SpriteKit

class Tree: SKSpriteNode, PreSpawned {
    func setup() {
        self.physicsBody?.categoryBitMask = PsxBitmask.tree
        self.physicsBody?.collisionBitMask = PsxBitmask.player
        self.physicsBody?.contactTestBitMask = PsxBitmask.bullet
    }
}
