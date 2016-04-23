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

    let specialShapes = ["bomb", "heart"]
    var shapeCounter = [0,0,0,0,0,0]
    let delayTime = 1.7 // time between spawns
    var range = 100.0 //range of X velocities
    let UPPERRANGEBOUND = 300.0;
    let LOWESTBOUND = CGFloat(100.0)
    var X_VELOCITY_RANGE = CGFloat(0);
    var Y_VELOCITY_RANGE = CGFloat(0);
    var LOWERBOUND = CGFloat(40.0) // smallest velocity possible
    var sShapeProbabilityBound = 600
    var specialShapeProbability = 1000
    var dx = CGFloat(0)
    var dy = CGFloat(0)
    let red: UIColor = UIColor(red: 164/255, green: 84/255, blue: 80/255, alpha: 1)
    let blue: UIColor = UIColor(red: 85/255, green: 135/255, blue: 141/255, alpha: 1)
    let green: UIColor = UIColor(red: 147/255, green: 158/255, blue: 106/255, alpha: 1)
    let purple: UIColor = UIColor(red: 99/255, green: 103/255, blue: 211/255, alpha: 1)
    let yellow: UIColor = UIColor(red: 250/255, green: 235/255, blue: 83/255, alpha: 1)
    
    let sizeRect = UIScreen.mainScreen().applicationFrame;
    
    func speedUpVelocity(speedFactor: Double) {
        range += speedFactor
        range = min(range, UPPERRANGEBOUND);
        LOWERBOUND += CGFloat(speedFactor);
        LOWERBOUND = min(LOWERBOUND, LOWESTBOUND)
    }
    
    func pentagonPath(rect: CGRect) -> CGPath {
        let dw = M_PI / 2.5
        let path = UIBezierPath()
        for i in 0...4 {
            let x = rect.size.width/2 * CGFloat(cos(Double(i) * dw))
            let y = rect.size.width/2 * CGFloat(sin(Double(i) * dw))
            if i == 0 {
                path.moveToPoint(CGPoint(x: x, y: y))
            } else {
                path.addLineToPoint(CGPoint(x: x, y: y))
            }
        }
        path.closePath()
        return path.CGPath
    }
    
    func createPentagon() -> SKShapeNode {
        let rect: CGRect = CGRectMake(0, 0, sizeRect.size.width/6, sizeRect.size.width/6)
        let pentagon = SKShapeNode()
        pentagon.path = pentagonPath(rect)
        pentagon.strokeColor = red
        pentagon.fillColor = red
        //circle.position = CGPointMake(sceneWidth/2, sceneHeight/2);
        pentagon.name = "pentagon";
        pentagon.zPosition=5
        setupTrianglePhysics(pentagon)
        return pentagon
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
    
    func circlePath() -> CGPathRef {
        let circlePath : UIBezierPath = UIBezierPath(arcCenter: CGPointMake(CGFloat(0), CGFloat(0)), radius: sizeRect.width/13, startAngle: CGFloat(0), endAngle: CGFloat(2*M_PI), clockwise: true)
        return circlePath.CGPath
    }
    
    func squarePath(rect:CGRect) -> CGPathRef {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 2)
        return path.CGPath
    }
    
    func createSquare() -> SKShapeNode {
        let rect: CGRect = CGRectMake(-sizeRect.size.width/12, -sizeRect.size.width/12, sizeRect.size.width/6.5, sizeRect.size.width/6.5)
        let square = SKShapeNode()
        square.path = squarePath(rect)
        square.strokeColor = green
        square.fillColor = green
        square.name = "square";
        square.zPosition=5
        setupTrianglePhysics(square)
        return square
    }
    
    
    func createCircle() -> SKShapeNode {
        let circle = SKShapeNode()
        circle.path = self.circlePath()
        circle.strokeColor = blue
        circle.fillColor = blue
        //circle.position = CGPointMake(sceneWidth/2, sceneHeight/2);
        circle.name = "circle";
        circle.zPosition=5
        setupCirclePhysics(circle)
        return circle
    }
    
    func setupCirclePhysics(circle: SKShapeNode) {
        circle.userInteractionEnabled = false
        circle.physicsBody = SKPhysicsBody(circleOfRadius: circle.frame.width/2)
        circle.physicsBody?.dynamic = true
        circle.physicsBody?.affectedByGravity=false
        circle.physicsBody?.categoryBitMask=PhysicsCategory.Shape;
        circle.physicsBody?.collisionBitMask=PhysicsCategory.Bin
        circle.physicsBody?.contactTestBitMask=PhysicsCategory.Bin
    }
    
    func createTriangle () -> SKShapeNode {
        let rect: CGRect = CGRectMake(0, 0, sizeRect.size.width/5.5, sizeRect.size.width/5.5)
        let triangle = SKShapeNode()
        triangle.path = self.triangleInRect(rect)
        triangle.strokeColor = purple
        triangle.fillColor = purple
        triangle.position = CGPointMake(sizeRect.size.width/2 - triangle.frame.width/2, sizeRect.size.height/2);
        // Set names for the launcher so that we can check what node is touched in the touchesEnded method
        triangle.name = "triangle";
        //could randomize rotation here
        triangle.runAction(SKAction.rotateByAngle(CGFloat(M_PI/2), duration: 3))
        triangle.zPosition=5
        setupTrianglePhysics(triangle)
        return triangle
    }
    
    func setupTrianglePhysics(triangle: SKShapeNode) {
        triangle.userInteractionEnabled = false
        triangle.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: triangle.frame.width, height: triangle.frame.height))
        triangle.physicsBody?.dynamic = true
        triangle.physicsBody?.affectedByGravity=false
        triangle.physicsBody?.categoryBitMask=PhysicsCategory.Shape;
        triangle.physicsBody?.collisionBitMask=PhysicsCategory.Bin
        triangle.physicsBody?.contactTestBitMask=PhysicsCategory.Bin
    }
    
    
    func resetVelocityBounds() {
        range = 100.0
        LOWERBOUND = CGFloat(40.0)
    }
    
    func resetSpecialShapeProbability() {
        specialShapeProbability = 1000
    }
    
    func setUpSpecialShape(shape: SKNode, scale: CGFloat) {
        shape.setScale(scale) // see Ashwin's paper for description of how these numbers were computed
               //shape.physicsBody?.categoryBitMask = PhysicsCategory.Shape
        //shape.position = CGPointMake(scene.frame.width/2, scene.frame.height/2)
        shape.zPosition = 5 // assures shape shows up over other stuff
        shape.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(shape.frame.width, shape.frame.height)) //can generalize later
        shape.physicsBody?.affectedByGravity = false
        shape.physicsBody?.categoryBitMask=PhysicsCategory.Shape;
        /** ASHWIN, sets up collision masks for the shapes*/
        shape.physicsBody!.dynamic = true
        //shape.physicsBody?.collisionBitMask  // want to track all collisions, which is the default
        //shape.physicsBody?.contactTestBitMask = shape.physicsBody!.collisionBitMask // which collisions do you want to know about (in this case all of them)
        shape.physicsBody?.collisionBitMask=PhysicsCategory.Bin
        shape.physicsBody?.contactTestBitMask=PhysicsCategory.Bin
        
    }
    
    func spawnShape() -> SKNode {
        
        let width = sizeRect.size.width * UIScreen.mainScreen().scale / 2; //screen width in points
        let height = sizeRect.size.height * UIScreen.mainScreen().scale / 2; //screen height in points
        var shapePicker=100
        let shapes = [createTriangle(),createSquare(),createPentagon(),createCircle()]
        X_VELOCITY_RANGE = CGFloat(range)
        Y_VELOCITY_RANGE = CGFloat(1.5*range)
        var shape = SKNode()
        if((shapeCounter.reduce(0,combine: +) > 10) &&
            Int(arc4random_uniform(UInt32(specialShapeProbability))) < 200){ // special shape 20% of time initially, at end of game, this value is 33%
            if(Int(arc4random_uniform(5)) != 0){ // 80% chance for bomb, 20% for heart
                shapePicker=Int(4)
                shape=SKSpriteNode(imageNamed: specialShapes[0])
                shape=shape as SKNode
                setUpSpecialShape(shape, scale: 0.2*width/shape.frame.width)
                shape.name="bomb"
            }
            else{
                shapePicker=Int(5)
                shape=SKSpriteNode(imageNamed: specialShapes[1])
                shape=shape as SKNode
                setUpSpecialShape(shape, scale: 0.2*width/shape.frame.width)
                shape.name="heart"
            }
        }
        else{
            shapePicker = Int(arc4random_uniform(4))
            shape = shapes[shapePicker] as SKNode
        }
        //let shape = SKSpriteNode(imageNamed: shapes[shapePicker])
        //print("", shapes[shapePicker], ": ", shape.size.width);
        
        shapeCounter[shapePicker] += 1
        //setUpShape(shape, scale: 0.2*width/shape.size.width)
        //shape.name = shapes[shapePicker]
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
        if(shape.name == "heart"){
            shape.physicsBody?.velocity = CGVectorMake(2*dx, 2*dy)
        }
        else{
            shape.physicsBody?.velocity = CGVectorMake(dx, dy)
        }
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