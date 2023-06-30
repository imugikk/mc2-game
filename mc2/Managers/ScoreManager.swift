//
//  GameScene.swift
//  mc2
//
//  Created by Paraptughessa Premaswari on 12/06/23.
//

import SpriteKit

class ScoreManager {
    static let shared = ScoreManager()
    private init() { }
    
    var scoreLabel: SKLabelNode?
    var score:Int = 0 {
        didSet {
            updateScoreLabel()
        }
    }
    
    var highScoreLabel: SKLabelNode?
    var highScore:Int = 0 {
        didSet {
            updateHighScoreLabel()
        }
    }
    
    var waveLabel: SKLabelNode?
//    var waveScore: Int = 0 {
//        didSet {
//            updateWaveScoreLabel()
//        }
//    }
    
    let highScoreKey = "HighScore"
    
    func setup(scoreLabel: SKLabelNode? = nil, highScoreLabel: SKLabelNode? = nil) {
        self.scoreLabel = scoreLabel
        self.highScoreLabel = highScoreLabel
        
        updateScoreLabel()
        highScore = UserDefaults.standard.integer(forKey: highScoreKey)
    }
    func resetScore() {
        score = 0
    }
    func increaseScore(amount: Int) {
        score += 1
    }
    func saveScore() {
        if score > highScore {
            UserDefaults.standard.set(score, forKey: highScoreKey)
            highScore = score
        }
    }
    
    func updateScoreLabel() {
        scoreLabel?.text = "Score: \(score)"
    }
    func updateHighScoreLabel() {
        highScoreLabel?.text = "High Score: \(highScore)"
    }
//    func updateWaveScoreLabel() {
//        highScoreLabel?.text = "Wave: \(waveScore)"
//    }
}
