//
//  GameScene.swift
//  spacebattle
//
//  Created by Horváth Donát on 2019. 08. 30..
//  Copyright © 2019. Horváth Donát. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "playership")
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0
        self.addChild(background)
        
        player.setScale(1.3)
        player.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.2)
        player.zPosition = 2
        self.addChild(player)
    }
    
    func fire() {
        
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.setScale(0.8)
        bullet.position = player.position
        bullet.zPosition = 1
        self.addChild(bullet)
        
        let move = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let remove = SKAction.removeFromParent()
        let bulletSeq = SKAction.sequence([move, remove])
        bullet.run(bulletSeq)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fire()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            let touchPoint = touch.location(in: self)
            let prevPoint = touch.previousLocation(in: self)
            let moveAmount = touchPoint.x - prevPoint.x
            player.position.x += moveAmount
        }
    }
}
