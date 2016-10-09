//
//  HomeScreen.swift
//  FlickIt
//
//  Created by Rohan Narayan on 10/8/16.
//  Copyright © 2016 Abhi_Shaili_Jeffrey_Rohan_Ashwin. All rights reserved.
//

import Foundation

import SpriteKit
import AVFoundation
import GameKit

class HomeScene: SKScene , SKPhysicsContactDelegate {
    var start = CGPoint()
    var line = SKShapeNode()
    var startTime = TimeInterval()
    var touching = false
    let red: UIColor = UIColor(red: 164/255, green: 84/255, blue: 80/255, alpha: 1)
    let blue: UIColor = UIColor(red: 85/255, green: 135/255, blue: 141/255, alpha: 1)
    let green: UIColor = UIColor(red: 147/255, green: 158/255, blue: 106/255, alpha: 1)
    let purple: UIColor = UIColor(red: 99/255, green: 103/255, blue: 211/255, alpha: 1)
    let yellow: UIColor = UIColor(red: 250/255, green: 235/255, blue: 83/255, alpha: 1)
    let yellowLight: UIColor = UIColor(red: 255/255, green: 252/255, blue: 210/255, alpha: 1)
    let kMinDistance = CGFloat(50)
    let kMinDuration = CGFloat(0)
    let kMinSpeed = CGFloat(100)
    let kMaxSpeed = CGFloat(500)
    let star = SKShapeNode()
    let starBin = SKShapeNode()
    let starLargerBin = SKShapeNode()
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    override func didMove(to view: SKView) {
        createBackground()
        self.physicsWorld.contactDelegate = self
        star.zPosition = 5
        star.name = "launchStar"
        starBin.zPosition = 5
        starBin.name = "regularBinStar"
        starLargerBin.zPosition = 5
        starLargerBin.name = "largerBinStar"
        createStar(star: star, name: star.name!)
        createStar(star: starBin, name: starBin.name!)
        createStar(star: starLargerBin, name: starLargerBin.name!)
        //playMusic("bensound-straight", type: "mp3")
        
        self.addChild(starLargerBin)
        self.addChild(star)
        self.addChild(starBin)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.location(in: self)
        // Save start location and time
        start = location
        startTime = touch.timestamp
        if(star.contains(location)){
            touching = true
        }
        /*
        if muteButton.contains(location) {
            if appDelegate.muted == false {  //MUTE IT
                muteIt()
            }
            else if appDelegate.muted == true { //UNMUTE IT
                unmuteIt()
            }
            self.star.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            self.star.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
        } else if aboutIcon.contains(location) {
            startAbout()
        } else if startLabel.contains(location) {
            startGame()
        } else if settingIcon.contains(location) {
            openSettings()
        }
        */
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.atPoint(start).name != nil && touching && self.atPoint(start).physicsBody?.categoryBitMask == PhysicsCategory.Shape) {
            for touch in touches{
                self.removeChildren(in: [line])
                let currentLocation=touch.location(in: self)
                createLine(currentLocation)
                self.addChild(line)
                
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeChildren(in: [line])
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.location(in: self)
        // Determine distance from the starting point
        var dx: CGFloat = location.x - start.x
        var dy: CGFloat = location.y - start.y
        let magnitude: CGFloat = sqrt(dx * dx + dy * dy)
        
        if (magnitude >= self.kMinDistance){
            // Determine time difference from start of the gesture
            dx = dx / magnitude
            dy = dy / magnitude
            let touchedNode=self.atPoint(start)
            //make it move
            touchedNode.physicsBody?.velocity=CGVector(dx: 0.0, dy: 0.0)
            touchedNode.physicsBody?.applyImpulse(CGVector(dx: 400*dx, dy: 400*dy))
        }
        touching = false
    }
    override func update(_ currentTime: TimeInterval) {
        removeOffScreenNodes()
    }
    func didBegin(_ contact: SKPhysicsContact){
        var firstBody=contact.bodyA
        var secondBody=contact.bodyB
        if(firstBody.categoryBitMask==PhysicsCategory.Bin && secondBody.categoryBitMask==PhysicsCategory.Shape){
            firstBody=contact.bodyB
            secondBody=contact.bodyA
        }
        if (firstBody.categoryBitMask==PhysicsCategory.Shape && secondBody.categoryBitMask==PhysicsCategory.Bin){
                let explosionEmitterNode = SKEmitterNode(fileNamed:"ExplosionEffect.sks")
                explosionEmitterNode!.position = contact.contactPoint
                explosionEmitterNode?.zPosition=100
                explosionEmitterNode?.particleColorSequence=SKKeyframeSequence(keyframeValues: [UIColor.red], times: [0])
                self.addChild(explosionEmitterNode!)
                self.startGame();
                self.removeAllChildren();
                self.star.position.y = 0
        }
    }

    func startGame() {
        let scene: SKScene = StartGameScene(size: self.size)
        // Configure the view.
        let skView = self.view as SKView!
        skView?.showsFPS = false
        skView?.showsNodeCount = false
    
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView?.ignoresSiblingOrder = true
    
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .aspectFill
        skView?.presentScene(scene)
    }




    func createBackground(){
        let size = CGSize(width: screenWidth, height: screenHeight)
        let color1 = UIColor(red: 171/255.0, green: 232/255.0, blue: 243/255.0, alpha: 1.0).cgColor
        let color2 = UIColor(red: 246/255.0, green: 204/255.0, blue: 208/255.0, alpha: 1.0).cgColor
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        layer.colors = [color1, color2] // start color
        UIGraphicsBeginImageContext(size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let bg = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        UIGraphicsEndImageContext()
        let back = SKTexture.init(cgImage: bg!)
        let backnode = SKSpriteNode(texture: back, size: size)
        backnode.zPosition = 0
        backnode.position = CGPoint(x:screenWidth/2,y:screenHeight/2)
        self.addChild(backnode)
    }
    
    func createStar(star: SKShapeNode, name: String){
        if (name == "launchStar") {
            let rect: CGRect = CGRect(x: 0, y: 0, width: screenWidth/6, height: screenWidth/6)
            star.path = self.starPath(0, y: 0, radius: rect.size.width/3, sides: 5, pointyness: 2)
            star.position = CGPoint(x: screenWidth/5, y: self.size.height/2);
            let rotation = SKAction.rotate(byAngle: CGFloat(2 * M_PI), duration: 10)
            star.run(SKAction.repeatForever(rotation))
            star.strokeColor = UIColor.black
            star.fillColor = yellow
            setupStarPhysics(star: star)
        }
        else if (name == "regularBinStar") {
            let rect: CGRect = CGRect(x: 0, y: 0, width: screenWidth/6, height: screenWidth/6)
            star.path = self.starPath(0, y: 0, radius: rect.size.width/3, sides: 5, pointyness: 2)
            star.position = CGPoint(x: screenWidth*4/5, y: self.size.height/2);
            star.fillColor = yellowLight
            setupStarBinPhysics(bin: star)
        }
        else {
            let rect: CGRect = CGRect(x: 0, y: 0, width: screenWidth/4, height: screenWidth/4)
            star.path = self.starPath(0, y: 0, radius: rect.size.width/3, sides: 5, pointyness: 2)
            star.position = CGPoint(x: screenWidth*4/5, y: self.size.height/2);
            star.strokeColor = UIColor.black
            star.fillColor = yellow
        }
    }
    func degree2radian(_ a:CGFloat)->CGFloat {
        let b = CGFloat(M_PI) * a/180
        return b
    }
    func polygonPointArray(_ sides:Int,x:CGFloat,y:CGFloat,radius:CGFloat,adjustment:CGFloat=0)->[CGPoint] {
        let angle = degree2radian(360/CGFloat(sides))
        let cx = x // x origin
        let cy = y // y origin
        let r  = radius // radius of circle
        var i = sides
        var points = [CGPoint]()
        while points.count <= sides {
            let xpo = cx - r * cos(angle * CGFloat(i)+degree2radian(adjustment))
            let ypo = cy - r * sin(angle * CGFloat(i)+degree2radian(adjustment))
            points.append(CGPoint(x: xpo, y: ypo))
            i -= 1;
        }
        return points
    }
    func starPath(_ x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, pointyness:CGFloat) -> CGPath {
        let adjustment = 360/sides/2
        let path = CGMutablePath()
        let points = polygonPointArray(sides,x: x,y: y,radius: radius)
        let cpg = points[0]
        let points2 = polygonPointArray(sides,x: x,y: y,radius: radius*pointyness,adjustment:CGFloat(adjustment))
        var i = 0
        path.move(to: CGPoint(x: cpg.x, y: cpg.y))
        //CGPathMoveToPoint(path, nil, cpg.x, cpg.y)
        for p in points {
            path.addLine(to: CGPoint(x: points2[i].x, y: points2[i].y))
            path.addLine(to: CGPoint(x: p.x, y: p.y))
            //CGPathAddLineToPoint(path, nil, points2[i].x, points2[i].y)
            //CGPathAddLineToPoint(path, nil, p.x, p.y)
            i += 1
        }
        path.closeSubpath()
        return path
    }
    func setupStarPhysics(star: SKShapeNode) {
        star.isUserInteractionEnabled = false
        star.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: star.frame.width, height: star.frame.height))
        star.physicsBody?.isDynamic = true
        star.physicsBody?.affectedByGravity=false
        star.physicsBody?.categoryBitMask = PhysicsCategory.Shape
        star.physicsBody?.collisionBitMask=PhysicsCategory.Bin
        star.physicsBody?.contactTestBitMask=PhysicsCategory.Bin
    }
    func setupStarBinPhysics(bin: SKShapeNode){
        bin.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: starBin.frame.width, height: starBin.frame.height))
        bin.physicsBody?.isDynamic=false
        bin.physicsBody?.affectedByGravity = false
        bin.physicsBody?.categoryBitMask=PhysicsCategory.Bin
        bin.physicsBody?.collisionBitMask=PhysicsCategory.Shape
        bin.physicsBody?.contactTestBitMask=PhysicsCategory.Shape
    }
    func createLine(_ end: CGPoint){
        line.lineWidth=1.5
        line.path = linePath(end)
        line.fillColor = UIColor.white
        line.strokeColor = UIColor.white
        line.zPosition=4
    }
    func linePath(_ end: CGPoint) -> CGPath {
        let path = UIBezierPath()
        for i in 0...1 {
            if i == 0 {
                path.move(to: start)
            } else {
                path.addLine(to: end)
            }
        }
        
        path.move(to: end)
        path.addLine(to: CGPoint(x: end.x - 5, y: end.y))
        path.addLine(to: CGPoint(x: end.x, y: end.y + 7))
        path.addLine(to: CGPoint(x: end.x + 5, y: end.y))
        path.close()
        return path.cgPath
    }
    func removeOffScreenNodes() {
        for shape in ["launchStar"] {
            self.enumerateChildNodes(withName: shape, using: {
                node, stop in
                let sprite = node
                if (sprite.position.y < 0 || sprite.position.x < 0 || sprite.position.x > self.size.width || sprite.position.y > self.size.height) {
                    self.star.position = CGPoint(x: self.size.width/5, y: self.size.height/2);
                    self.star.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                }
            })
        }
    }



}
