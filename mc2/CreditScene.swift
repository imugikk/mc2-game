//
//  CreditScene.swift
//  mc2
//
//  Created by Michelle Annice on 21/06/23.
//

import SpriteKit
import GameplayKit

class CreditScene: SKScene {
    var entities = [GKEntity]()

    var score:Int = 0
    var highScore:Int = 0
    
    var highScoreLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
        
//    override func sceneDidLoad() {
//        super.sceneDidLoad()
//        highScoreLabel = self.childNode(withName: "highScoreText") as? SKLabelNode
//    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
            //"g"
        case 5:
            if let view = self.view {
                if let scene = SKScene(fileNamed: "GameOverScene") as? GameOverScene {
                    scene.score = score
                    scene.highScore = highScore
                    scene.updateLabels()
                    scene.entities = self.entities
                    scene.scaleMode = .aspectFit
                    view.presentScene(scene)
                }
            }
            //"e"
        case 14:
            if let view = self.view {
                if let scene = SKScene(fileNamed: "StartScene") as? StartScene {
                    scene.highScore = highScore
                    scene.entities = self.entities
                    scene.updateLabels()
                    scene.scaleMode = .aspectFit
                    view.presentScene(scene)
                }
            }
            
        //"z"
        case 6:
            exit(0)
            
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }

    func updateLabels() {
//        highScoreLabel.text = "High Score: \(highScore)"
    }
}

