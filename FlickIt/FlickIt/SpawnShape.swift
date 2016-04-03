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

    let shapes = ["blue_triangle-1", "blue_square-1", "blue_circle-1","blue_star-1","bomb"]
    let triangle = SKShapeNode()
    var shapeCounter = [0,0,0,0,0]
    let delayTime = 2.0 // time between spawns
    var range = 100.0 //range of X velocities
    let UPPERRANGEBOUND = 200.0;
    let LOWESTBOUND = CGFloat(100.0)
    var X_VELOCITY_RANGE = CGFloat(0);
    var Y_VELOCITY_RANGE = CGFloat(0);
    var LOWERBOUND = CGFloat(40.0) // smallest velocity possible
    var sShapeProbabilityBound = 600
    var specialShapeProbability = 1000
    var dx = CGFloat(0)
    var dy = CGFloat(0)
    
    let sizeRect = UIScreen.mainScreen().applicationFrame;
    
    func speedUpVelocity(speedFactor: Double) {
        range += speedFactor
        range = min(range, UPPERRANGEBOUND);
        LOWERBOUND += CGFloat(speedFactor);
        LOWERBOUND = min(LOWERBOUND, LOWESTBOUND)
    }
    
    func triangleInRect(rect: CGRect) -> CGPathRef {
        let offsetX: CGFloat = CGRectGetMidX(rect)
        let offsetY: CGFloat = CGRectGetMidY(rect)
        let bezierPath: UIBezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(offsetX, 0))
        bezierPath.addLineToPoint(CGPointMake(-offsetX, offsetY))
        bezierPath.addLineToPoint(CGPointMake(-offsetX, -offsetY))
        bezierPath.closePath()
        return bezierPath.CGPath
    }
    
    func createTriangle() {
        let rect: CGRect = CGRectMake(0, 0, sizeRect.size.width/6, sizeRect.size.width/6)
        triangle.path = self.triangleInRect(rect)
        triangle.strokeColor = UIColor(red: 160/255, green: 80/255, blue: 76/255, alpha: 1)
        triangle.fillColor = UIColor(red: 160/255, green: 80/255, blue: 76/255, alpha: 1)
        triangle.position = CGPointMake(sizeRect.size.width/2 - triangle.frame.width/2, sizeRect.size.height/2);
        // Set names for the launcher so that we can check what node is touched in the touchesEnded method
        triangle.name = "launch triangle";
        //could randomize rotation here
        triangle.runAction(SKAction.rotateByAngle(CGFloat(M_PI/2), duration: 3))
    }
    
    func setupTrianglePhysics() {
        triangle.userInteractionEnabled = false
        triangle.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: triangle.frame.width, height: triangle.frame.height))
        triangle.physicsBody?.dynamic = true
        triangle.physicsBody?.affectedByGravity=false
    }
    
    func resetVelocityBounds() {
        range = 100.0
        LOWERBOUND = CGFloat(40.0)
    }
    
    func resetSpecialShapeProbability() {
        specialShapeProbability = 1000
    }
    
    func setUpShape(shape: SKSpriteNode, scale: CGFloat) {
        shape.setScale(scale) // see Ashwin's paper for description of how these numbers were computed
               //shape.physicsBody?.categoryBitMask = PhysicsCategory.Shape
        //shape.position = CGPointMake(scene.frame.width/2, scene.frame.height/2)
        shape.zPosition = 5 // assures shape shows up over other stuff
        shape.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(shape.size.width, shape.size.height)) //can generalize later
        shape.physicsBody?.affectedByGravity = false
        shape.physicsBody?.categoryBitMask=PhysicsCategory.Shape;
        /** ASHWIN, sets up collision masks for the shapes*/
        shape.physicsBody!.dynamic = true
        //shape.physicsBody?.collisionBitMask  // want to track all collisions, which is the default
        //shape.physicsBody?.contactTestBitMask = shape.physicsBody!.collisionBitMask // which collisions do you want to know about (in this case all of them)
        shape.physicsBody?.collisionBitMask=PhysicsCategory.Bin
        shape.physicsBody?.contactTestBitMask=PhysicsCategory.Bin
        
    }
    
    func spawnShape() -> SKSpriteNode {    
        X_VELOCITY_RANGE = CGFloat(range)
        Y_VELOCITY_RANGE = CGFloat(1.5*range)
        let width = sizeRect.size.width * UIScreen.mainScreen().scale / 2; //screen width in points
        let height = sizeRect.size.height * UIScreen.mainScreen().scale / 2; //screen height in points
        var shapePicker=100
        if((shapeCounter.reduce(0,combine: +) > 10) && Int(arc4random_uniform(UInt32(specialShapeProbability))) < 80){
            shapePicker=Int(4)
        }
        else{
            shapePicker = Int(arc4random_uniform(4))
        }
        let shape = SKSpriteNode(imageNamed: shapes[shapePicker])
        //let shape = shapes[shapePicker]
        //print("", shapes[shapePicker], ": ", shape.size.width);
        
        shapeCounter[shapePicker] += 1
        setUpShape(shape, scale: 0.2*width/shape.size.width)
        shape.name = shapes[shapePicker]
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