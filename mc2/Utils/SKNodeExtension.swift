//
//  SKNodeExtension.swift
//  mc2
//
//  Created by Ardli Fadhillah on 22/06/23.
//

import SpriteKit

extension SKNode {
    
    var screenHeight: Double { scene!.frame.size.height }
    var screenWidth: Double { scene!.frame.size.width }
    
    var destroyed: Bool { parent == nil }
    
    var globalPosition: CGPoint {
        self.parent!.convert(self.position, to: scene!)
    }
    
    var globalZRotation: CGFloat {
        var rotation: CGFloat = self.zRotation
        var currentNode = self
        
        while let parentNode = currentNode.parent {
            currentNode = parentNode
            rotation += currentNode.zRotation
        }
        
        return rotation
    }
    
    func traverseNodes(_ block: (SKNode) -> Void) {
        block(self)
        for childNode in children {
            childNode.traverseNodes(block)
        }
    }
}
