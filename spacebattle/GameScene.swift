//
//  GameScene.swift
//  spacebattle
//
//  Created by Horváth Donát on 2019. 08. 30..
//  Copyright © 2019. Horváth Donát. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score = 0
    var level = 0
    var lives = 3
    
    let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
    let livesLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    let player = SKSpriteNode(imageNamed: "playership")
    
    struct PhysicsCategories {
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1 // 1
        static let Bullet : UInt32 = 0b10 // 2
        static let Enemy : UInt32 = 0b100 // 4
    }
    
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
        
        self.physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0
        self.addChild(background)
        
        player.setScale(1.3)
        player.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.2)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.9)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        livesLabel.text = "Lives: 3"
        livesLabel.fontSize = 70
        livesLabel.fontColor = SKColor.white
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLabel.position = CGPoint(x: self.size.width * 0.85, y: self.size.height * 0.9)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
        
        newLevel()
    }
    
    func loseLife() {
        
        lives -= 1
        livesLabel.text = "Lives: \(lives)"
        
        let colorizeRed = SKAction.colorize(with: SKColor.red, colorBlendFactor: 1, duration: 0.001)
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let colorizeWhite = SKAction.colorize(with: SKColor.white, colorBlendFactor: 1, duration: 0.001)
        let scaleSeq = SKAction.sequence([colorizeRed ,scaleUp, scaleDown, colorizeWhite])
        livesLabel.run(scaleSeq)
    }
    
    func addScore() {
        
        score += 1
        scoreLabel.text = "Score: \(score)"
        
        if score == 10 || score == 25 || score == 50 {
            newLevel()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy {
            
            if body1.node != nil {
                blast(position: body1.node!.position)
            }
            
            if body2.node != nil {
                blast(position: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
        
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy && (body2.node?.position.y)! < self.size.height {
            
            addScore()
            
            if body2.node != nil {
                blast(position: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
    }
    
    func blast(position: CGPoint) {
        
        let blast = SKSpriteNode(imageNamed: "blast")
        blast.position = position
        blast.zPosition = 3
        blast.setScale(0)
        self.addChild(blast)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let remove = SKAction.removeFromParent()
        
        let blastSeq = SKAction.sequence([scaleIn, fadeOut, remove])
        blast.run(blastSeq)
    }
    
    func newLevel() {
        
        level += 1
        
        if self.action(forKey: "spawnEnemy") != nil {
            self.removeAction(forKey: "spawnEnemy")
        }
        
        var spawnSpeed = TimeInterval()
        
        switch level {
        case 1: spawnSpeed = 1.2
        case 2: spawnSpeed = 1
        case 3: spawnSpeed = 0.8
        case 4: spawnSpeed = 0.5
        default:
            spawnSpeed = 0.5
        }
        
        let spawn = SKAction.run(spawnEnemy)
        let wait = SKAction.wait(forDuration: spawnSpeed)
        let spawnSeq = SKAction.sequence([wait, spawn])
        let spawnMachnism = SKAction.repeatForever(spawnSeq)
        self.run(spawnMachnism, withKey: "spawnEnemy")
    }
    
    func fire() {
        
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.setScale(0.8)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
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
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        self.addChild(enemy)
        
        let move = SKAction.move(to: exitPoint, duration: 1.5)
        let remove = SKAction.removeFromParent()
        let loseLifeAction = SKAction.run(loseLife)
        let enemySeq = SKAction.sequence([move, remove, loseLifeAction])
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
