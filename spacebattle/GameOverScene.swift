//
//  GameOverScene.swift
//  spacebattle
//
//  Created by Horváth Donát on 2019. 08. 30..
//  Copyright © 2019. Horváth Donát. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    let restartLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverLabel = SKLabelNode(fontNamed: "The Bold Font")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 180
        gameOverLabel.fontColor = SKColor.red
        gameOverLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.75)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        let defaults = UserDefaults()
        var highScore = defaults.integer(forKey: "highScoreSaved")
        
        if score > highScore {
            highScore = score
            defaults.set(highScore, forKey: "highScoreSaved")
        }
        
        let highScoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        highScoreLabel.text = "Best: \(highScore)"
        highScoreLabel.fontSize = 100
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.6)
        highScoreLabel.zPosition = 1
        self.addChild(highScoreLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 100
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.5)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        restartLabel.text = "Try Again"
        restartLabel.fontSize = 90
        restartLabel.fontColor = SKColor.yellow
        restartLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.2)
        restartLabel.zPosition = 1
        self.addChild(restartLabel)
        
        let faintOut = SKAction.fadeAlpha(to: 0.2, duration: 1)
        let faintIn = SKAction.fadeAlpha(to: 1.0, duration: 0.7)
        let faintSeq = SKAction.sequence([faintOut, faintIn])
        let faintEffect = SKAction.repeatForever(faintSeq)
        restartLabel.run(faintEffect)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            let touchPoint = touch.location(in: self)
            
            if restartLabel.contains(touchPoint) {
                
                let sceneToMove = GameScene(size: self.size)
                sceneToMove.scaleMode = self.scaleMode
                let transitionReplay = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMove, transition: transitionReplay)
            }
        }
    }
}
