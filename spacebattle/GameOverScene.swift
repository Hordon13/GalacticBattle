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
        
        let moon = SKSpriteNode(imageNamed: "moon")
        moon.position = CGPoint(x: self.size.width * 0.8, y: self.size.height * 0.35)
        moon.zPosition = 1
        moon.zRotation = -0.3
        moon.alpha = 0.8
        self.addChild(moon)
        
        let planet = SKSpriteNode(imageNamed: "planet")
        planet.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.65)
        planet.zPosition = 1
        planet.zRotation = 0.2
        planet.alpha = 0.9
        self.addChild(planet)
        
        let gameOverLabel = SKLabelNode(fontNamed: "The Bold Font")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 180
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.8)
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
        highScoreLabel.fontSize = 110
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.55)
        highScoreLabel.zPosition = 1
        self.addChild(highScoreLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 100
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.475)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        restartLabel.text = "Try Again"
        restartLabel.fontSize = 90
        restartLabel.fontColor = SKColor.yellow
        restartLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.15)
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
