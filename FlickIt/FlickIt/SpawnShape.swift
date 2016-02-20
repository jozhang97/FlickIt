//
//  SpawnShape.swift
//  FlickIt
//
//  Created by Jeffrey Zhang on 2/20/16.
//  Copyright © 2016 Abhi_Shaili_Jeffrey_Rohan_Ashwin. All rights reserved.
//

import SpriteKit
import Foundation
class SpawnShape: SKScene
{

    let shapes = ["blue_triangle", "red_square", "green_triangle","yellow_square"]
    var shapeCounter = [0,0,0,0]
    let delayTime = 2.0 // time between spawns
    static let range = 100.0 //range of X velocities
    let X_VELOCITY_RANGE = CGFloat(range)
    let Y_VELOCITY_RANGE = CGFloat(1.5*range)
    let LOWERBOUND = CGFloat(40.0) // smallest velocity possible
    
    func spawnShape() {
        let shapePicker = (Int) (arc4random()*4 + 1)
        let shape = SKSpriteNode(imageNamed: shapes[shapePicker])
        shape.name = shapes[shapePicker]
        shapeCounter[shapePicker] += 1
        shape.setScale(0.5)
        shape.physicsBody?.categoryBitMask = PhysicsCategory.Shape
        shape.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        shape.zPosition = 5 // assures shape shows up over other stuff
        shape.physicsBody = SKPhysicsBody(circleOfRadius: self.frame.height/2) //can generalize later
        shape.physicsBody?.affectedByGravity = false
        shape.physicsBody?.dynamic = true
        
        /** ASHWIN, CHANGE 0 TO BIN WHEN WORKING ON COLLISION */
        shape.physicsBody?.collisionBitMask = 0 // PhysicsCategory.Bin
        shape.physicsBody?.contactTestBitMask = 0 //PhysicsCategory.Bin
        
        // Randomizing velocity vectors
        var dx = CGFloat(Float(arc4random())/0xFFFFFFFF)
        var dy = CGFloat(Float(arc4random())/0xFFFFFFFF)
        while (abs(dx) < LOWERBOUND && abs(dy) < LOWERBOUND)
        {
            dx = CGFloat(Float(arc4random())/0xFFFFFFFF)
            dx = X_VELOCITY_RANGE*dx - X_VELOCITY_RANGE/2
            dy = CGFloat(Float(arc4random())/0xFFFFFFFF)
            dy = Y_VELOCITY_RANGE*dy - Y_VELOCITY_RANGE/2
        }
        shape.physicsBody?.velocity = CGVectorMake(dx, dy)
        self.addChild(shape)
        print("in here")
    }

    func startSpawning()
    {
        print("in here")
        let spawn = SKAction.runBlock({
            () in
            self.spawnShape()
        })
        let delay = SKAction.waitForDuration(delayTime)
        let spawnDelay = SKAction.sequence([spawn,delay])
        let spawnDelayForever = SKAction.repeatActionForever(spawnDelay)
        self.runAction(spawnDelayForever)
    }
}