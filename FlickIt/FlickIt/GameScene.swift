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
    var shape = SKSpriteNode()
    //variables needed for flicking
    var start=CGPoint();
    var startTime=NSTimeInterval();
    let kMinDistance=CGFloat(50)
    let kMinDuration=CGFloat(0)
    let kMinSpeed=CGFloat(100)
    let kMaxSpeed=CGFloat(500)
    
    var bgImage = SKSpriteNode(imageNamed: "neon_circle.jpg");
    var startSquare = SKSpriteNode(imageNamed: "start_square.jpg");
    var launchSquare = SKSpriteNode(imageNamed: "launch_square.jpg");
    var rulesCircle = SKSpriteNode(imageNamed: "rules_circle.jpg");
    var launchCircle = SKSpriteNode(imageNamed: "launch_circle.jpg");
    
    func createHomeScreen(){
        //set Z-positions
        bgImage.zPosition = 1;
        startSquare.zPosition = 2;
        rulesCircle.zPosition = 2;
        launchSquare.zPosition = 3;
        launchCircle.zPosition = 3;
        
        
        // Sets the neon circle image to fill the entire screen
        bgImage.size = CGSize(width: self.size.width, height: self.size.height);
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        
        // Put the start square bin at the top center and rules circle bin at the bottom center
        startSquare.position = CGPointMake(self.frame.width/2, self.frame.height * 9 / 10);
        rulesCircle.position = CGPointMake(self.frame.width/2, self.frame.height / 10);
        
        
        // Start the launch square and circle in the very middle of the screen
        launchSquare.position = CGPointMake(self.size.width/2, self.size.height/2);
        launchCircle.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        // Set names for the launcher so that we can check what node is touched in the touchesEnded method
        launchSquare.name = "launch square";
        launchCircle.name = "launch circle";
        
        /** Add Physics Stuff for square launcher */
        launchSquare.userInteractionEnabled=false
        launchSquare.physicsBody=SKPhysicsBody(rectangleOfSize: CGSize(width: launchSquare.size.width, height: launchSquare.size.height));
        launchSquare.physicsBody?.dynamic=true
        launchSquare.physicsBody?.affectedByGravity=false
        
        /** Add Physics Stuff for circle launcher */
        launchCircle.userInteractionEnabled=false
        launchCircle.physicsBody=SKPhysicsBody(circleOfRadius: launchCircle.frame.height/2)
        launchCircle.physicsBody?.dynamic=true
        launchCircle.physicsBody?.affectedByGravity=false
        
        // Create and add title to home screen CURRENTLY ONLY WORKS IF YOU DO title.center = CGPointMake(160, 284)
        var title = UILabel(frame: CGRectMake(0, 0, 200, 21))
        title.center = CGPointMake(self.frame.width/2, self.frame.height/2)
        title.textAlignment = NSTextAlignment.Center
        
        title.text = "Flick-It"
        title.font = UIFont(name: "Futura", size: 30)
        title.textColor = UIColor.blueColor()
        self.view?.addSubview(title)
        
        // Add all the elements to the screen
        self.addChild(bgImage);
        self.addChild(startSquare);
        self.addChild(launchSquare);
        
        self.addChild(rulesCircle);
        self.addChild(launchCircle);

        // Have square first shoot up quickly, then slower and slower.
        launchSquare.runAction(SKAction.sequence([
            SKAction.moveBy(CGVectorMake(0, self.frame.height / 15), duration: 1),
            SKAction.moveBy(CGVectorMake(0, self.frame.height / 15), duration: 15),
            SKAction.moveBy(CGVectorMake(0, self.frame.height / 20), duration: 50)
            ])
        )
        // Have circle first shoot down quickly, then slower and slower.
        launchCircle.runAction(SKAction.sequence([
            SKAction.moveBy(CGVectorMake(0, -self.frame.height / 15), duration: 1),
            SKAction.moveBy(CGVectorMake(0, -self.frame.height / 15), duration: 15),
            SKAction.moveBy(CGVectorMake(0, -self.frame.height / 20), duration: 50)
            ])
        )
    }
    
    /** Creates scene by setting position and defining physics */
    func createScene(){
        
        /** Puts in background */
        self.view?.backgroundColor = UIColor.blackColor()
        
        /** Puts in the title */
        let title = UILabel(frame: CGRectMake(self.frame.width/9, self.frame.height/8, self.frame.width/2, self.frame.height/8))
        
        title.text = "Flick-It"
        title.font = UIFont(name: "Futura", size: 30)
        title.textColor = UIColor.blueColor()
        self.view?.addSubview(title)
        
    //New labels added in after Jeffrey's commit
        //start label -- edit placement and width
        let start = UILabel(frame: CGRectMake(self.frame.width/2, self.frame.height*1/4, self.frame.width/4, self.frame.height/12))
        start.text = "Start"
        start.font = UIFont(name: "Futura", size: 18)
        start.textColor = UIColor.whiteColor();
        self.view?.addSubview(start)
        
        //rules label -- edit placement and width
        let rules = UILabel(frame: CGRectMake(self.frame.width/2 + 10, self.frame.height*1/4, self.frame.width/4, self.frame.height/12))
        rules.text = "Rules"
        rules.font = UIFont(name: "Futura", size: 18)
        rules.textColor = UIColor.whiteColor();
        self.view?.addSubview(rules)

        //about label -- edit placement and width
        let about = UILabel(frame: CGRectMake(self.frame.width/2, self.frame.height*1/2 - 10, self.frame.width/4, self.frame.height/12))
        about.text = "About"
        about.font = UIFont(name: "Futura", size: 18)
        about.textColor = UIColor.whiteColor();
        self.view?.addSubview(about)

        
        
        

        
        /** Giving the objects pictures */
        startBin = SKSpriteNode(imageNamed: "bin")
        rulesBin = SKSpriteNode(imageNamed: "bin")
        aboutBin = SKSpriteNode(imageNamed: "bin")
        shape = SKSpriteNode(imageNamed: "blue_triangle")
        
        /** Downsizes pictures to fit on screen better */
        startBin.setScale(0.15)
        rulesBin.setScale(0.15)
        aboutBin.setScale(0.15)
        shape.setScale(0.15)
        
        /** Sets positions of startBin, rulesBin, shape */
        startBin.position = CGPoint(x: self.frame.width/2, y: self.frame.height*1/4)
        rulesBin.position = CGPoint(x: self.frame.width*1/4, y: self.frame.height/2)
        aboutBin.position = CGPoint(x: self.frame.width*2/4, y: self.frame.height/2)
        shape.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        
        /** Did Physics Stuff */
        shape.userInteractionEnabled=false
        shape.physicsBody=SKPhysicsBody(circleOfRadius: shape.frame.height/2)
        shape.physicsBody?.dynamic=true
        shape.physicsBody?.affectedByGravity=false
        
        
        /** Adding objects into screen */
        self.addChild(startBin)
        self.addChild(rulesBin)
        self.addChild(aboutBin)
        self.addChild(shape)
    }
    
    override func didMoveToView(view: SKView) {
        createHomeScreen()
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
            if (touchedNode.name == "launch square" && dy > 0){
                touchedNode.physicsBody?.applyImpulse(CGVectorMake(0, 100*dy))
            }
            if (touchedNode.name == "launch circle" && dy < 0){
                touchedNode.physicsBody?.applyImpulse(CGVectorMake(0, 100*dy))
            }
            //touchedNode.physicsBody?.applyImpulse(CGVectorMake(100*dx, 100*dy))
        }
    }
    
    func startGame() {
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
    
    func getHelp() {
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if (launchSquare.position.y >= startSquare.position.y){
            // call method to start game
            // for now just remove all the elements to show something has happened
            self.removeAllChildren();
            self.startGame();
            launchSquare.position.y = 0
        }
        
        if (launchCircle.position.y <= rulesCircle.position.y){
            // call method to start game
            // for now just remove all the elements to show something has happened
            self.removeAllChildren();
            getHelp();
            launchCircle.position.y = 0
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
        
    }
}
