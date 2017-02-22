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
    static let Ground : UInt32 = 0x1 << 2  //0x1 << 1 is the hex value of 1, and 0x1 << 2 is the value of 2.
    static let Wall : UInt32 = 0x1 << 3

}


class GameScene: SKScene {
    
   var Ground = SKSpriteNode()
   var Ghost = SKSpriteNode()
    
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
        Ghost.position = CGPoint(x: self.frame.midX - Ghost.frame.width, y: self.frame.midY)
        
        Ghost.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        Ghost.physicsBody?.categoryBitMask = PhysicsCatagory.Ghost
        Ghost.physicsBody?.collisionBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall
        Ghost.physicsBody?.contactTestBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall
        Ghost.physicsBody?.affectedByGravity = true
        Ghost.physicsBody?.isDynamic = true
        Ghost.zPosition = 2
        
        self.addChild(Ghost)
        
        createWalls()
    
    }
    
    
    func createWalls(){
        let wallPair = SKNode()
        let topWall = SKSpriteNode(imageNamed: "Wall")
        let btmWall = SKSpriteNode(imageNamed: "Wall")
        
        topWall.position = CGPoint(x: self.frame.width, y: self.frame.midY + 550)
        btmWall.position = CGPoint(x: self.frame.width, y: self.frame.midY - 550)

        topWall.setScale(0.7)
        btmWall.setScale(0.7)
        
        topWall.physicsBody? = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        topWall.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
        topWall.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        topWall.physicsBody?.affectedByGravity = false
        topWall.physicsBody?.isDynamic = false
        
        btmWall.physicsBody? = SKPhysicsBody(rectangleOf: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        btmWall.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
        btmWall.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        btmWall.physicsBody?.affectedByGravity = false
        btmWall.physicsBody?.isDynamic = false
        
        topWall.zRotation  = CGFloat(M_PI)
    
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        wallPair.zPosition = 1
        
        self.addChild(wallPair)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //let vector : CGVector = (0, 0)
        
        Ghost.physicsBody?.velocity = CGVector(dx: 0.0 , dy: 0.0)
        Ghost.physicsBody?.applyImpulse(CGVector(dx: 0.0 , dy: 200.0), at: Ghost.position)
        
        
    }
    
        override func update(_ currentTime: TimeInterval) {

    }
}








