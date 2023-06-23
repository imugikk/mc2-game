//
//  CreditScene.swift
//  mc2
//
//  Created by Michelle Annice on 21/06/23.
//

import SpriteKit

class CreditScene: SKScene {
    override func didMove(to view: SKView) {
        InputManager.buttonBPressed.subscribe(node: self, closure: goBackToGameOver)
    }
    override func willMove(from view: SKView) {
        InputManager.buttonBPressed.unsubscribe(node: self)
    }
    func goBackToGameOver() {
        GameViewController.changeScene(to: "GameOverScene", in: self.view!)
    }
}

