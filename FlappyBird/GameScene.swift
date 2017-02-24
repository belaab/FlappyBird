//
//  GameScene.swift
//  FlappyBird
//
//  Created by Iza on 21.02.2017.
//  Copyright © 2017 IB. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCatagory{
    static let Ghost : UInt32 = 0x1 << 1  //The code uses a shift operator to set a unique value for each of the categoryBitMasks in our physics bodies.
    static let Wall : UInt32 = 0x1 << 2
    static let Ground : UInt32 = 0x1 << 3
    static let Score : UInt32 = 0x1 << 4
}


class GameScene: SKScene, SKPhysicsContactDelegate{

   
   var wallPair = SKNode()
   var Ground = SKSpriteNode()
   var Ghost = SKSpriteNode()
   var Score = Int()
   var moveAndRemove = SKAction()
   var gameStarted = Bool()
   let scoreLabel = SKLabelNode()
   var died = Bool()
   var restartButton = SKSpriteNode()
    
    
    func restartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = false
        Score = 0
        createScene()
    }
    
    func createScene(){
        
        self.physicsWorld.contactDelegate = self
        
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 200)
        scoreLabel.text = "\(Score)"
        scoreLabel.zPosition = 6
        
        self.addChild(scoreLabel)
        Ground = SKSpriteNode(imageNamed: "Ground")
        Ground.setScale(0.7)
        Ground.position = CGPoint(x: self.frame.midX, y: self.frame.minY + Ground.frame.height/2)
        
        Ground.physicsBody = SKPhysicsBody(rectangleOf: Ground.size)
        Ground.physicsBody?.categoryBitMask = PhysicsCatagory.Ground
        Ground.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
        Ground.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        Ground.physicsBody?.affectedByGravity = false
        Ground.physicsBody?.isDynamic = false
        Ground.zPosition = 3
        self.addChild(Ground)
        
        
        Ghost = SKSpriteNode(imageNamed: "Ghost")
        Ghost.size = CGSize(width: 90, height: 100)
        Ghost.position = CGPoint(x: self.frame.midX - 100, y: self.frame.midY)
        
        Ghost.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        Ghost.physicsBody?.categoryBitMask = PhysicsCatagory.Ghost
        Ghost.physicsBody?.collisionBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall
        Ghost.physicsBody?.contactTestBitMask =  PhysicsCatagory.Ground | PhysicsCatagory.Wall | PhysicsCatagory.Score
        Ghost.physicsBody?.affectedByGravity = false
        Ghost.physicsBody?.isDynamic = true
        Ghost.zPosition = 2
        self.addChild(Ghost)
        checkPhysics()
    }
    
    override func didMove(to view: SKView) {
            createScene()
    }
    
    
    
    func createButton(){
        restartButton = SKSpriteNode(color: SKColor.cyan, size: CGSize(width: 200, height: 100))
        restartButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        restartButton.zPosition = 6
        self.addChild(restartButton)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == PhysicsCatagory.Score && secondBody.categoryBitMask == PhysicsCatagory.Ghost || firstBody.categoryBitMask == PhysicsCatagory.Ghost && secondBody.categoryBitMask == PhysicsCatagory.Score{
            Score += 1
            scoreLabel.text = "\(Score)"
        }

        if firstBody.categoryBitMask == PhysicsCatagory.Ghost && secondBody.categoryBitMask == PhysicsCatagory.Wall || firstBody.categoryBitMask == PhysicsCatagory.Wall && secondBody.categoryBitMask == PhysicsCatagory.Ghost{
            died = true
            createButton()
        }
        
    }
    
    func checkPhysics() {
        // Create an array of all the nodes with physicsBodies
        var physicsNodes = [SKNode]()
        
        //Get all physics bodies
        enumerateChildNodes(withName: "//.") { node, _ in
            if let _ = node.physicsBody {
                physicsNodes.append(node)
            } else {
                print("\(node.name) does not have a physics body so cannot collide or be involved in contacts.")
            }
        }
        
        //For each node, check it's category against every other node's collion and contctTest bit mask
        for node in physicsNodes {
            let category = node.physicsBody!.categoryBitMask
            // Identify the node by its category if the name is blank
            let name = node.name != nil ? node.name! : "Category \(category)"
            
            let collisionMask = node.physicsBody!.collisionBitMask
            let contactMask = node.physicsBody!.contactTestBitMask
            
            // If all bits of the collisonmask set, just say it collides with everything.
            if collisionMask == UInt32.max {
                print("\(name) collides with everything")
            }
            
            for otherNode in physicsNodes {
                if (node != otherNode) && (node.physicsBody?.isDynamic == true) {
                    let otherCategory = otherNode.physicsBody!.categoryBitMask
                    // Identify the node by its category if the name is blank
                    let otherName = otherNode.name != nil ? otherNode.name! : "Category \(otherCategory)"
                    
                    // If the collisonmask and category match, they will collide
                    if ((collisionMask & otherCategory) != 0) && (collisionMask != UInt32.max) {
                        print("\(name) collides with \(otherName)")
                    }
                    // If the contactMAsk and category match, they will contact
                    if (contactMask & otherCategory) != 0 {print("\(name) notifies when contacting \(otherName)")}
                }
            }
        }
    }
    

    
    func createWalls(){
        let scoreNode = SKSpriteNode()
        scoreNode.size =  CGSize(width: 1, height: 400)
        scoreNode.position = CGPoint(x: self.frame.width, y: self.frame.midY)
        
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsCatagory.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        scoreNode.color = SKColor.cyan
        scoreNode.zPosition = 5
        
        wallPair = SKNode()
        let topWall = SKSpriteNode(imageNamed: "Wall")
        let btmWall = SKSpriteNode(imageNamed: "Wall")

        topWall.position = CGPoint(x: self.frame.width, y: self.frame.midY + 550)
        btmWall.position = CGPoint(x: self.frame.width, y: self.frame.midY - 550)

        topWall.setScale(0.7)
        btmWall.setScale(0.7)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        topWall.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
        topWall.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        
        btmWall.physicsBody = SKPhysicsBody(rectangleOf: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        btmWall.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
        btmWall.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        btmWall.physicsBody?.isDynamic = false
        btmWall.physicsBody?.affectedByGravity = false
        
       topWall.zRotation  = CGFloat(M_PI)
    
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        wallPair.zPosition = 1
        
        var randomPosition = CGFloat.random(min: -250, max: 250)
        wallPair.position.y = wallPair.position.y + randomPosition
        wallPair.addChild(scoreNode)
        wallPair.run(moveAndRemove)
        self.addChild(wallPair)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameStarted == false{
            gameStarted = true
            Ghost.physicsBody?.affectedByGravity = true

            let spawn = SKAction.run({
                () in
                self.createWalls()
            })
            
            let delay = SKAction.wait(forDuration: 2.0)
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width*2) //self.frame.width + wallPair.frame.width

            let movePipes = SKAction.moveBy(x: -distance - 200, y: 0, duration: TimeInterval(0.006 * distance))
            let removePipes = SKAction.removeFromParent() //remove the pipes after they moved off the screen
            
            moveAndRemove = SKAction.sequence([movePipes, removePipes])
            
            Ghost.physicsBody?.velocity = CGVector(dx: 0.0 , dy: 0.0)
            Ghost.physicsBody?.applyImpulse(CGVector(dx: 0.0 , dy: 200.0), at: Ghost.position)
            
        }else{
            if died == true{
                
                
            }else{
                
                Ghost.physicsBody?.velocity = CGVector(dx: 0.0 , dy: 0.0)
                Ghost.physicsBody?.applyImpulse(CGVector(dx: 0.0 , dy: 200.0), at: Ghost.position)
            }
            
        }
        
        
        for touch in touches{
            let location = touch.location(in: self)
            
            if died == true{
                if restartButton.contains(location){
                    restartScene()
                }
            }
        }

}
    
        override func update(_ currentTime: TimeInterval) {

    }
}












