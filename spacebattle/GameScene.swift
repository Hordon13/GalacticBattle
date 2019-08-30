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
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    let gameArea: CGRect
    
    override init(size: CGSize) {
        
        let maxAspectRatio: CGFloat = 16.0 / 9.0
        let playWidth = size.height / maxAspectRatio
        let margin = (size.width - playWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playWidth, height: size.height)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    func spawnEnemy() {
        
        let startPoint = random(min: gameArea.minX, max: gameArea.maxX)
        let endPoint = random(min: gameArea.minX, max: gameArea.maxX)
        
        let spawnPoint = CGPoint(x: startPoint, y: self.size.height * 1.2)
        let exitPoint = CGPoint(x: endPoint, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "enemyship")
        enemy.setScale(0.7)
        enemy.position = spawnPoint
        enemy.zPosition = 2
        self.addChild(enemy)
        
        let move = SKAction.move(to: exitPoint, duration: 1.5)
        let remove = SKAction.removeFromParent()
        let enemySeq = SKAction.sequence([move, remove])
        enemy.run(enemySeq)
        
        let dx = exitPoint.x - spawnPoint.x
        let dy = exitPoint.y - spawnPoint.y
        let rotate = atan2(dy, dx)
        enemy.zRotation = rotate
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
            
            if player.position.x >= gameArea.maxX - player.size.width / 2 {
                player.position.x = gameArea.maxX - player.size.width / 2
            }
            
            if player.position.x <= gameArea.minX + player.size.width / 2 {
                player.position.x = gameArea.minX + player.size.width / 2
            }
        }
    }
}
