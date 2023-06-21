//
//  SKNodeExtension.swift
//  mc2
//
//  Created by Ardli Fadhillah on 22/06/23.
//

import SpriteKit

extension SKNode {
    func traverseNodes(_ block: (SKNode) -> Void) {
        block(self)
        for childNode in children {
            childNode.traverseNodes(block)
        }
    }
}
