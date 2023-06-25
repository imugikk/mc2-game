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
        get {
            self.parent!.convert(self.position, to: scene!)
        }
        set {
            self.position = scene!.convert(newValue, to: self.parent!)
        }
    }
    
    var globalZRotationInDegrees: CGFloat {
        get {
            var rotation: CGFloat = self.zRotation
            var currentNode = self
            
            while let parentNode = currentNode.parent {
                currentNode = parentNode
                rotation += currentNode.zRotation
            }
            
            return rotation.toDegrees()
        }
        set {
            var rotation: CGFloat = newValue.toRadians()
            var currentNode = self
            
            while let parentNode = currentNode.parent {
                currentNode = parentNode
                rotation -= currentNode.zRotation
            }
            
            self.zRotation = rotation
        }
    }
    
    var zRotationInDegrees: CGFloat {
        get {
            return self.zRotation.toDegrees()
        }
        set {
            self.zRotation = newValue.toRadians()
        }
    }
    
    func traverseNodes(_ block: (SKNode) -> Void) {
        block(self)
        for childNode in children {
            childNode.traverseNodes(block)
        }
    }
    
    func getUserData<T>(key: String) -> T {
        return userData?[key] as! T
    }
}
