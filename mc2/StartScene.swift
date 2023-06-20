//
//  StartScene.swift
//  mc2
//
//  Created by Michelle Annice on 20/06/23.
//

import SpriteKit
import GameplayKit

class StartScene: SKScene {
    var entities = [GKEntity]()

    var highScore:Int = 0
    
    var highScoreLabel: SKLabelNode!
        
    override func sceneDidLoad() {
        super.sceneDidLoad()
        highScoreLabel = self.childNode(withName: "highScoreText") as? SKLabelNode
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
            //"p"
        case 35:
            if let view = self.view {
                if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                    scene.score = 0
                    scene.highScore = highScore
                    scene.entities = self.entities
                    scene.scaleMode = .aspectFit
                    view.presentScene(scene)
                }
            }
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }

    func updateLabels() {
        highScoreLabel.text = "High Score: \(highScore)"
    }
}
