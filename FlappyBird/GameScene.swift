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
    static let Ghost : UInt32 = 0x1 << 1
}







class GameScene: SKScene {
    
   var Ground = SKSpriteNode()
   var Ghost = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        Ground = SKSpriteNode(imageNamed: "Ground")
        Ground.setScale(0.7)
        Ground.position = CGPoint(x: self.frame.midX, y: self.frame.minY + Ground.frame.height/2)
        self.addChild(Ground)
        
        Ghost = SKSpriteNode(imageNamed: "Ghost")
        Ghost.size = CGSize(width: 90, height: 100)
        Ghost.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(Ghost)
        
        createWalls()
    
    }
    
    
    func createWalls(){
        let wallPair = SKNode()
        let topWall = SKSpriteNode(imageNamed: "Wall")
        let btmWall = SKSpriteNode(imageNamed: "Wall")
        
        topWall.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 550)
        btmWall.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 550)

        topWall.setScale(0.7)
        btmWall.setScale(0.7)
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        self.addChild(wallPair)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }
    
        override func update(_ currentTime: TimeInterval) {

    }
}
