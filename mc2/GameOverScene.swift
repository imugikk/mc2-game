//
//  GameOverScene.swift
//  mc2
//
//  Created by Michelle Annice on 16/06/23.
//

//import UIKit
import SpriteKit
import GameplayKit

class GameOverScene: SKScene {
    var entities = [GKEntity]()
    
    var restartButtonNode:SKSpriteNode!
    
    var score:Int = 0
    var highScore:Int = 0
    
    var scoreLabel: SKLabelNode!
    var highScoreLabel: SKLabelNode!
    
//    override func didMove(to view: SKView){
//        restartButtonNode = self.childNode(withName: "restartButton") as! SKSpriteNode
//    }
        
    override func sceneDidLoad() {
        super.sceneDidLoad()

        scoreLabel = self.childNode(withName: "scoreText") as? SKLabelNode
        highScoreLabel = self.childNode(withName: "highScoreText") as? SKLabelNode
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
            //"x"
        case 7:
//            restartGame()
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
        scoreLabel.text = "Score: \(score)"
        highScoreLabel.text = "High Score: \(highScore)"
    }
}
