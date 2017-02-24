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
}


class GameScene: SKScene{

   
   var wallPair = SKNode()
   var Ground = SKSpriteNode()
   var Ghost = SKSpriteNode()

   var moveAndRemove = SKAction()
   var gameStarted = Bool()
   
    
    override func didMove(to view: SKView) {
        
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
        Ghost.physicsBody?.contactTestBitMask =  PhysicsCatagory.Ground | PhysicsCatagory.Wall
        Ghost.physicsBody?.affectedByGravity = false
        Ghost.physicsBody?.isDynamic = true
        Ghost.zPosition = 2
        self.addChild(Ghost)
        checkPhysics()
        
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

            let movePipes = SKAction.moveBy(x: -distance - 200, y: 0, duration: TimeInterval(0.0065 * distance))
            let removePipes = SKAction.removeFromParent() //remove the pipes after they moved off the screen
            
            moveAndRemove = SKAction.sequence([movePipes, removePipes])
            
            Ghost.physicsBody?.velocity = CGVector(dx: 0.0 , dy: 0.0)
            Ghost.physicsBody?.applyImpulse(CGVector(dx: 0.0 , dy: 200.0), at: Ghost.position)
            
        }else{
            Ghost.physicsBody?.velocity = CGVector(dx: 0.0 , dy: 0.0)
            Ghost.physicsBody?.applyImpulse(CGVector(dx: 0.0 , dy: 200.0), at: Ghost.position)
        }

}
    
        override func update(_ currentTime: TimeInterval) {

    }
}












