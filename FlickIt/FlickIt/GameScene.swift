//
//  GameScene.swift
//  FlickIt
//
//  Created by Jeffrey Zhang on 2/13/16.
//  Copyright (c) 2016 Abhi_Shaili_Jeffrey_Rohan_Ashwin. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let Bin : UInt32 = 0x1 << 1
    static let Shape : UInt32 = 0x1 << 2
}

class GameScene: SKScene {
    var startBin = SKSpriteNode()
    var rulesBin = SKSpriteNode()
    var aboutBin = SKSpriteNode()
    var triangle = SKShapeNode()
    
    //variables needed for flicking
    var start = CGPoint()
    var startTime = NSTimeInterval()
    let kMinDistance = CGFloat(50)
    let kMinDuration = CGFloat(0)
    let kMinSpeed = CGFloat(100)
    let kMaxSpeed = CGFloat(500)
    
    var bgImage = SKSpriteNode(imageNamed: "flickitbg.png")
    var startLabel = SKLabelNode(text: "START")
    var launchTriangle = SKSpriteNode(imageNamed: "red_triangle.png")
    var rulesLabel = SKLabelNode(text: "RULES")
    var titleLabel = SKLabelNode(text: "FLICK IT")
    var curveUp = SKShapeNode()
    var curveDown = SKShapeNode()
    
    override func didMoveToView(view: SKView) {
        createHomeScreen()
    }
    
    func createHomeScreen(){
        //create triangle SKShapeNode
        createTriangle()
        
        //setup Physics stuff of triangle SKShapeNode
        setupTrianglePhysics()
        
        // Create and add title to home screen
        setupTitleLabel()
        
        // Sets bg image to fill the entire screen
        bgImage.size = CGSize(width: self.size.width, height: self.size.height);
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        // Set up start Label
        setupStartLabel()
        
        // Set up rules Label
        setupRulesLabel()
        
        //Add Curved Lines
        addCurvedLines(curveUp, dub1: 1.5*M_PI, dub2: M_PI, bol: false)
        addCurvedLines(curveDown, dub1: M_PI/2, dub2: M_PI, bol: true)
        
        
        //set Z-positions
        bgImage.zPosition = 1
        startLabel.zPosition = 2
        rulesLabel.zPosition = 2
        titleLabel.zPosition = 2
        curveDown.zPosition = 3
        curveUp.zPosition = 3
        triangle.zPosition = 4
        
        // Add all the elements to the screen
        self.addChild(bgImage)
        self.addChild(triangle)
        self.addChild(curveUp)
        self.addChild(curveDown)
        self.addChild(titleLabel)
        self.addChild(rulesLabel)
        self.addChild(startLabel)

        // Have triangle first shoot up quickly, then slower and slower.
        triangle.runAction(SKAction.sequence([
            SKAction.moveBy(CGVectorMake(0, self.frame.height / 15), duration: 1),
            SKAction.moveBy(CGVectorMake(0, self.frame.height / 15), duration: 15),
            SKAction.moveBy(CGVectorMake(0, self.frame.height / 20), duration: 50)
            ])
        )
    }
    
    func addCurvedLines(curve: SKShapeNode, dub1: Double, dub2: Double, bol: Bool) {
        let circlePath : UIBezierPath = UIBezierPath(arcCenter: CGPointMake(CGFloat(self.frame.width/2), CGFloat(self.frame.height/4)), radius: CGFloat(self.frame.width/3), startAngle: CGFloat(dub1), endAngle: CGFloat(dub2), clockwise: bol)
        curve.path = circlePath.CGPath
        curve.position = CGPointMake(0, self.frame.height/2)
        curve.strokeColor = UIColor.grayColor()
        curve.lineWidth = 3
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
        let rect: CGRect = CGRectMake(0, 0, self.size.width/5, self.size.width/5)
        triangle.path = self.triangleInRect(rect)
        triangle.strokeColor = UIColor(red: 160/255, green: 80/255, blue: 76/255, alpha: 1)
        triangle.fillColor = UIColor(red: 160/255, green: 80/255, blue: 76/255, alpha: 1)
        triangle.position = CGPointMake(self.size.width/2, self.size.height/2);
        // Set names for the launcher so that we can check what node is touched in the touchesEnded method
        triangle.name = "launch triangle";
    }
    
    func setupTrianglePhysics() {
        triangle.userInteractionEnabled=false
        triangle.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: launchTriangle.size.width, height: launchTriangle.size.height))
        triangle.physicsBody?.dynamic = true
        triangle.physicsBody?.affectedByGravity=false
    }
    
    func setupTitleLabel() {
        titleLabel.position = CGPointMake(self.frame.width/2, self.frame.height * 9 / 10);
        titleLabel.horizontalAlignmentMode = .Center
        titleLabel.fontColor = UIColor.whiteColor()
        titleLabel.fontName = "Futura"
        titleLabel.fontSize = 45
    }
    
    func setupStartLabel() {
        startLabel.position = CGPointMake(self.frame.width/2, self.frame.height * 9 / 10);
        startLabel.horizontalAlignmentMode = .Center
        startLabel.fontColor = UIColor.whiteColor()
        startLabel.fontName = "Futura"
        startLabel.fontSize = 40
    }
    
    func setupRulesLabel() {
        rulesLabel.position = CGPointMake(self.frame.width/2, self.frame.height / 10);
        rulesLabel.horizontalAlignmentMode = .Center
        rulesLabel.fontColor = UIColor.whiteColor()
        rulesLabel.fontName = "Futura"
        rulesLabel.fontSize = 40
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.locationInNode(self)
        // Save start location and time
        start = location
        startTime = touch.timestamp
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.locationInNode(self)
        // Determine distance from the starting point
        var dx: CGFloat = location.x - start.x
        var dy: CGFloat = location.y - start.y
        let magnitude: CGFloat = sqrt(dx * dx + dy * dy)
        if (magnitude >= self.kMinDistance){
            // Determine time difference from start of the gesture
            dx = dx / magnitude
            dy = dy / magnitude
            let touchedNode=self.nodeAtPoint(start)
            //make it move
            touchedNode.physicsBody?.velocity=CGVectorMake(0.0, 0.0)
            if (touchedNode.name == "launch triangle" && dy > 0){
                touchedNode.physicsBody?.applyImpulse(CGVectorMake(0, 100*dy))
            }
            if (touchedNode.name == "launch triangle" && dy < 0){
                touchedNode.physicsBody?.applyImpulse(CGVectorMake(0, 100*dy))
            }
            //touchedNode.physicsBody?.applyImpulse(CGVectorMake(100*dx, 100*dy))
        }
    }
    
    func startGame() {
        //titleLabel.removeFromSuperview()
        let scene: SKScene = StartGameScene(size: self.size)
        
        // Configure the view.
        let skView = self.view as SKView!
        skView.showsFPS = false
        skView.showsNodeCount = false
            
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
            
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
        
    }
   
    override func update(currentTime: CFTimeInterval) {
//        /* Called before each frame is rendered */
//        if (launchTriangle.position.y >= startSquare.position.y){
//            // call method to start game
//            // for now just remove all the elements to show something has happened
//            self.removeAllChildren();
//            self.startGame();
//            launchTriangle.position.y = 0
//        }
//        
//        if (launchTriangle.position.y <= rulesCircle.position.y){
//            // call method to start game
//            // for now just remove all the elements to show something has happened
//            self.removeAllChildren();
//            launchTriangle.position.y = 0
//        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
        
    }
}
