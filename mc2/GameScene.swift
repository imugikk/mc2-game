//
//  GameScene.swift
//  mc2
//
//  Created by Paraptughessa Premaswari on 12/06/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var entities = [GKEntity]()
    
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet{
            if scoreLabel != nil {
                scoreLabel.text = "Score: \(score)"
            }
        }
    }
    
    var highScoreLabel:SKLabelNode!
    var highScore:Int = 0 {
        didSet{
            if highScoreLabel != nil{
                highScoreLabel.text = "High Score: \(highScore)"
                
            }
        }
    }
    
    let scoreKey = "HighScoreKey"
    
    
    override func sceneDidLoad() {
        scoreLabel = self.childNode(withName: "scoreText") as? SKLabelNode
        score = 0
        
        highScoreLabel = self.childNode(withName: "highScoreText") as? SKLabelNode
        highScore = UserDefaults.standard.integer(forKey: scoreKey)
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        //"i"
        case 34:
            score += 1
        //"s"
        case 1:
            if score > highScore {
                highScore = score
                UserDefaults.standard.set(score, forKey: scoreKey)
            }
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
//        case 14:
//            if let view = self.view {
//                if let scene = SKScene(fileNamed: "StartScene") as? StartScene {
//                    scene.highScore = highScore
//                    scene.updateLabels()
//                    scene.entities = self.entities
//                    scene.scaleMode = .aspectFit
//                    view.presentScene(scene)
//                }
//            }
            
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
}
