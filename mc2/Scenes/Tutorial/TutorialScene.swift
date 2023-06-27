//
//  TutorialScene.swift
//  mc2
//
//  Created by Michelle Annice on 27/06/23.
//

import Foundation
import SpriteKit
import GameController

class TutorialScene: Scene {
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        InputManager.buttonAPressed.subscribe(node: self, closure: restart)
    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
        InputManager.buttonAPressed.unsubscribe(node: self)
    }
    
    func restart() {
        GameViewController.changeScene(to: "GameScene", in: self.view!)
    }
}
