//
//  SpawnShape.swift
//  FlickIt
//
//  Created by Jeffrey Zhang on 2/20/16.
//  Copyright © 2016 Abhi_Shaili_Jeffrey_Rohan_Ashwin. All rights reserved.
//

import SpriteKit
import Foundation
class SpawnShape
{

    let shapes = ["blue_triangle-1", "blue_square-1", "blue_circle-1","blue_star-1"]
    var shapeCounter = [0,0,0,0]
    let delayTime = 2.0 // time between spawns
    var range = 100.0 //range of X velocities
    let UPPERRANGEBOUND = 300.0;
    let LOWESTBOUND = CGFloat(100.0)
    var X_VELOCITY_RANGE = CGFloat(0);
    var Y_VELOCITY_RANGE = CGFloat(0);
    var LOWERBOUND = CGFloat(40.0) // smallest velocity possible
    
    var dx = CGFloat(0)
    var dy = CGFloat(0)
    
    let sizeRect = UIScreen.mainScreen().applicationFrame;
    
    func speedUpVelocity(speedFactor: Double) {
        range += speedFactor
        range = min(range, UPPERRANGEBOUND);
        LOWERBOUND += CGFloat(speedFactor);
        LOWERBOUND = min(LOWERBOUND, LOWESTBOUND)
    }
    
    func resetVelocityBounds() {
        range = 100.0
        LOWERBOUND = CGFloat(40.0)
    }
    
    func spawnShape() -> SKSpriteNode {
        
        X_VELOCITY_RANGE = CGFloat(range)
        Y_VELOCITY_RANGE = CGFloat(1.5*range)
        let width = sizeRect.size.width * UIScreen.mainScreen().scale / 2; //screen width in points
        let height = sizeRect.size.height * UIScreen.mainScreen().scale / 2; //screen height in points
        
        print(width);
        print(height);
        
        let shapePicker = Int(arc4random_uniform(4))
        let shape = SKSpriteNode(imageNamed: shapes[shapePicker])
        //print("", shapes[shapePicker], ": ", shape.size.width);
        shapeCounter[shapePicker] += 1
        shape.setScale(0.2*width/shape.size.width) // see Ashwin's paper for description of how these numbers were computed
        
        //shape.physicsBody?.categoryBitMask = PhysicsCategory.Shape
        //shape.position = CGPointMake(scene.frame.width/2, scene.frame.height/2)
        shape.zPosition = 5 // assures shape shows up over other stuff
        shape.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(shape.size.width, shape.size.height)) //can generalize later
        shape.physicsBody?.affectedByGravity = false
        shape.physicsBody?.categoryBitMask=PhysicsCategory.Shape;
        
        
        
        /** ASHWIN, sets up collision masks for the shapes*/
        shape.physicsBody!.dynamic = true
        shape.name = shapes[shapePicker]
        //shape.physicsBody?.collisionBitMask  // want to track all collisions, which is the default
        //shape.physicsBody?.contactTestBitMask = shape.physicsBody!.collisionBitMask // which collisions do you want to know about (in this case all of them)
        shape.physicsBody?.collisionBitMask=PhysicsCategory.Bin
        shape.physicsBody?.contactTestBitMask=PhysicsCategory.Bin
        
        // Randomizing velocity vectors
        dx = CGFloat(Float(arc4random())/0xFFFFFFFF)
        dy = CGFloat(Float(arc4random())/0xFFFFFFFF)
        while (abs(dx) < LOWERBOUND && abs(dy) < LOWERBOUND)
        {
            dx = CGFloat(Float(arc4random())/0xFFFFFFFF)
            dx = X_VELOCITY_RANGE*dx - X_VELOCITY_RANGE/2
            dy = CGFloat(Float(arc4random())/0xFFFFFFFF)
            dy = Y_VELOCITY_RANGE*dy - Y_VELOCITY_RANGE/2
        }
        shape.physicsBody?.velocity = CGVectorMake(dx, dy)
        return shape;
        
    }

//    func startSpawning()
//    {
//        print("in here")
//        let spawn = SKAction.runBlock({
//            () in
//            self.spawnShape()
//        })
//        let delay = SKAction.waitForDuration(delayTime)
//        let spawnDelay = SKAction.sequence([spawn,delay])
//        let spawnDelayForever = SKAction.repeatActionForever(spawnDelay)
//        scene.runAction(spawnDelayForever)
//    }
}