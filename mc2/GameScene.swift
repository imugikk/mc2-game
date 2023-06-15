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
    var graphs = [String : GKGraph]()
    
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var highScoreLabel:SKLabelNode!
    var highScore:Int = 0 {
        didSet{
            highScoreLabel.text = "High Score: \(highScore)"
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
        //press "i" -> keycode : 34
        case 34:
            score += 1
            
        case 1:
            if score > highScore {
                highScore = score
                UserDefaults.standard.set(score, forKey: scoreKey)
            }
            
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
}
