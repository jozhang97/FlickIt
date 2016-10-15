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
    //let red: UIColor = UIColor(red: 164/255, green: 84/255, blue: 80/255, alpha: 1)
    //let blue: UIColor = UIColor(red: 85/255, green: 135/255, blue: 141/255, alpha: 1)
    //let green: UIColor = UIColor(red: 147/255, green: 158/255, blue: 106/255, alpha: 1)
    //let purple: UIColor = UIColor(red: 99/255, green: 103/255, blue: 211/255, alpha: 1)
    let yellow: UIColor = UIColor(red: 250/255, green: 235/255, blue: 83/255, alpha: 1)
    
    // [red, green, blue purple]
    var colors = [UIColor(red: 164/255, green: 84/255, blue: 80/255, alpha: 1),
                  UIColor(red: 147/255, green: 158/255, blue: 106/255, alpha: 1),
                  UIColor(red: 85/255, green: 135/255, blue: 141/255, alpha: 1),
                  UIColor(red: 99/255, green: 103/255, blue: 211/255, alpha: 1)]
    
    var colorScoreLimit = 15
    
    let sizeRect = UIScreen.main.applicationFrame;
    
    func speedUpVelocity(_ speedFactor: Double) {
        range += speedFactor
        range = min(range, UPPERRANGEBOUND);
        LOWERBOUND += CGFloat(speedFactor);
        LOWERBOUND = min(LOWERBOUND, LOWESTBOUND)
    }
    
    func pentagonPath(_ rect: CGRect) -> CGPath {
        let dw = M_PI / 2.5
        let path = UIBezierPath()
        for i in 0...4 {
            let x = rect.size.width/2 * CGFloat(cos(Double(i) * dw))
            let y = rect.size.width/2 * CGFloat(sin(Double(i) * dw))
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.close()
        return path.cgPath
    }
    
    func createPentagon(_ score: Int) -> SKShapeNode {
        let rect: CGRect = CGRect(x: 0, y: 0, width: sizeRect.size.width/6, height: sizeRect.size.width/6)
        let pentagon = SKShapeNode()
        pentagon.path = pentagonPath(rect)
        var c = colors[0] // red is default
        if (score >= colorScoreLimit) {
            c = colors[Int(arc4random_uniform(4))]
        }
        pentagon.strokeColor = UIColor.black
        pentagon.fillColor = c
        //circle.position = CGPointMake(sceneWidth/2, sceneHeight/2);
        pentagon.name = "pentagon";
        pentagon.zPosition=5
        setupTrianglePhysics(pentagon)
        return pentagon
    }
    func triangleInRect(_ rect: CGRect) -> CGPath {
        let offsetX: CGFloat = rect.midX
        let offsetY: CGFloat = rect.midY
        let bezierPath: UIBezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: offsetX, y: 0))
        bezierPath.addLine(to: CGPoint(x: -offsetX, y: offsetY))
        bezierPath.addLine(to: CGPoint(x: -offsetX, y: -offsetY))
        bezierPath.close()
        return bezierPath.cgPath
    }
    
    func circlePath() -> CGPath {
        let circlePath : UIBezierPath = UIBezierPath(arcCenter: CGPoint(x: CGFloat(0), y: CGFloat(0)), radius: sizeRect.width/13, startAngle: CGFloat(0), endAngle: CGFloat(2*M_PI), clockwise: true)
        return circlePath.cgPath
    }
    
    func squarePath(_ rect:CGRect) -> CGPath {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 2)
        return path.cgPath
    }
    
    func createSquare(_ score: Int) -> SKShapeNode {
        let rect: CGRect = CGRect(x: -sizeRect.size.width/12, y: -sizeRect.size.width/12, width: sizeRect.size.width/6.5, height: sizeRect.size.width/6.5)
        let square = SKShapeNode()
        var c = colors[1] // green is default
        if (score >= colorScoreLimit) {
            c = colors[Int(arc4random_uniform(4))]
        }
        square.path = squarePath(rect)
        square.strokeColor = UIColor.black
        square.fillColor = c
        square.name = "square";
        square.zPosition=5
        setupTrianglePhysics(square)
        return square
    }
    
    
    func createCircle(_ score: Int) -> SKShapeNode {
        let circle = SKShapeNode()
        var c = colors[2] // blue is default
        if (score >= colorScoreLimit) {
            c = colors[Int(arc4random_uniform(4))]
        }
        circle.path = self.circlePath()
        circle.strokeColor = UIColor.black
        circle.fillColor = c
        //circle.position = CGPointMake(sceneWidth/2, sceneHeight/2);
        circle.name = "circle";
        circle.zPosition=5
        setupCirclePhysics(circle)
        return circle
    }
    
    func setupCirclePhysics(_ circle: SKShapeNode) {
        circle.isUserInteractionEnabled = false
        circle.physicsBody = SKPhysicsBody(circleOfRadius: circle.frame.width/2)
        circle.physicsBody?.isDynamic = true
        circle.physicsBody?.affectedByGravity=false
        circle.physicsBody?.categoryBitMask=PhysicsCategory.Shape;
        circle.physicsBody?.collisionBitMask=PhysicsCategory.Bin
        circle.physicsBody?.contactTestBitMask=PhysicsCategory.Bin
    }
    
    func createTriangle (_ score: Int) -> SKShapeNode {
        let rect: CGRect = CGRect(x: 0, y: 0, width: sizeRect.size.width/5.5, height: sizeRect.size.width/5.5)
        let triangle = SKShapeNode()
        var c = colors[3] // purple is default
        if (score >= colorScoreLimit) {
            c = colors[Int(arc4random_uniform(4))]
        }
        triangle.path = self.triangleInRect(rect)
        triangle.strokeColor = UIColor.black
        triangle.fillColor = c
        triangle.position = CGPoint(x: sizeRect.size.width/2 - triangle.frame.width/2, y: sizeRect.size.height/2);
        // Set names for the launcher so that we can check what node is touched in the touchesEnded method
        triangle.name = "triangle";
        //could randomize rotation here
        triangle.run(SKAction.rotate(byAngle: CGFloat(M_PI/2), duration: 3))
        triangle.zPosition=5
        setupTrianglePhysics(triangle)
        return triangle
    }
    
    func setupTrianglePhysics(_ triangle: SKShapeNode) {
        triangle.isUserInteractionEnabled = false
        triangle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: triangle.frame.width, height: triangle.frame.height))
        triangle.physicsBody?.isDynamic = true
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
    
    func setUpSpecialShape(_ shape: SKNode, scale: CGFloat) {
        shape.setScale(scale) // see Ashwin's paper for description of how these numbers were computed
               //shape.physicsBody?.categoryBitMask = PhysicsCategory.Shape
        //shape.position = CGPointMake(scene.frame.width/2, scene.frame.height/2)
        shape.zPosition = 5 // assures shape shows up over other stuff
        shape.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: shape.frame.width, height: shape.frame.height)) //can generalize later
        shape.physicsBody?.affectedByGravity = false
        shape.physicsBody?.categoryBitMask=PhysicsCategory.Shape;
        /** ASHWIN, sets up collision masks for the shapes*/
        shape.physicsBody!.isDynamic = true
        //shape.physicsBody?.collisionBitMask  // want to track all collisions, which is the default
        //shape.physicsBody?.contactTestBitMask = shape.physicsBody!.collisionBitMask // which collisions do you want to know about (in this case all of them)
        shape.physicsBody?.collisionBitMask=PhysicsCategory.Bin
        shape.physicsBody?.contactTestBitMask=PhysicsCategory.Bin
        
    }
    
    func spawnShape(_ score: Int, lives: Int) -> SKNode {
        
        let width = sizeRect.size.width * UIScreen.main.scale / 2; //screen width in points
        var shapePicker=100
        let shapes = [createTriangle(score),createSquare(score),createPentagon(score),createCircle(score)]
        X_VELOCITY_RANGE = CGFloat(range)
        Y_VELOCITY_RANGE = CGFloat(1.5*range)
        var shape = SKNode()
        if((shapeCounter.reduce(0,+) >= 5) &&
            Int(arc4random_uniform(UInt32(specialShapeProbability))) < 100){ // special shape 10% of time initially, at end of game, this value is 16%
            if(Int(arc4random_uniform(5000 / UInt32(specialShapeProbability))) != 0){ // Initially: 80% chance for bomb, 20% for heart; at end, 87.5% chance of bomb
                shapePicker=Int(4)
                shape=SKSpriteNode(imageNamed: specialShapes[0])
                shape=shape as SKNode
                setUpSpecialShape(shape, scale: 0.2*width/shape.frame.width)
                shape.name="bomb"
            }
            else{
                if (lives < 5) { // ensures user never has more than 5 lives
                    shapePicker=Int(5)
                    shape=SKSpriteNode(imageNamed: specialShapes[1])
                    shape=shape as SKNode
                    setUpSpecialShape(shape, scale: 0.2*width/shape.frame.width)
                    shape.name="heart"
                }
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
            shape.physicsBody?.velocity = CGVector(dx: 2*dx, dy: 2*dy)
        }
        else{
            shape.physicsBody?.velocity = CGVector(dx: dx, dy: dy)
        }
        return shape;
        
    }
    
    func getShapeCounter() -> [Int] {
        return shapeCounter
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
