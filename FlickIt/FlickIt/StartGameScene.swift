
//
//  startGame.swift
//  FlickIt
//
//  Created by Apple on 2/20/16.
//  Copyright © 2016 Abhi_Shaili_Jeffrey_Rohan_Ashwin. All rights reserved.
//

import SpriteKit

class StartGameScene: SKScene, SKPhysicsContactDelegate {
    var NUMBEROFLIFES = 1
    var bgImage = SKSpriteNode(imageNamed: "neon_circle.jpg");
    var startSquare = SKSpriteNode(imageNamed: "start_square.jpg");
    var launchSquare = SKSpriteNode(imageNamed: "launch_square.jpg");
    var rulesCircle = SKSpriteNode(imageNamed: "rules_circle.jpg");
    var launchCircle = SKSpriteNode(imageNamed: "launch_circle.jpg");
    
    var bin_1 = SKSpriteNode(imageNamed: "topRightBin.png"); //change this to differently oriented triangles
    var bin_2 = SKSpriteNode(imageNamed: "topLeftBin.png");
    var bin_3 = SKSpriteNode(imageNamed: "lowerRightBin.png");
    var bin_4 = SKSpriteNode(imageNamed: "lowerLeftBin.png");
    
    var score = 0;
    var missedCounter = 0;
    
    let shapes = ["blue_triangle", "blue_square", "blue_circle","blue_star"]
    let bins = ["bin_1", "bin_2", "bin_3", "bin_4"]
    
    var start=CGPoint();
    var startTime=NSTimeInterval();
    let kMinDistance=CGFloat(50)
    let kMinDuration=CGFloat(0)
    let kMinSpeed=CGFloat(100)
    let kMaxSpeed=CGFloat(500)
    var scoreLabel=SKLabelNode()
    var missedLabel = SKLabelNode()
    var time : CFTimeInterval = 2;
    var shapeToAdd = SKSpriteNode();
    var touched:Bool = false;
    var shapeController = SpawnShape();
    var restartBTN = SKSpriteNode();
    var gameOver = false; // SET THESE
    var oldVelocities = [SKNode: CGVector]()
    
    let sizeRect = UIScreen.mainScreen().applicationFrame;
    // Actual dimensions of the screen
    var sceneHeight = CGFloat(0);
    var sceneWidth = CGFloat(0);
    override init(size: CGSize) {
        super.init(size: size)
        createScene()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func didMoveToView(view: SKView) {
//        print("hello")
//        createScene()
//    }
    
    func createScene() {
        physicsWorld.contactDelegate = self // error fix = do self.physicsWorld...
        sceneHeight = sizeRect.size.height * UIScreen.mainScreen().scale;
        sceneWidth = sizeRect.size.width * UIScreen.mainScreen().scale;
        // Sets the neon circle image to fill the entire screen
        bgImage.size = CGSize(width: self.size.width, height: self.size.height);
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        bgImage.zPosition = 1
        self.addChild(bgImage);
        
        print("Entered create scene")
        print(self.size.width)
        print(self.size.height)
        
        //adds bins on all 4 corners of screen with name, zposition and size
        //bin_1.size = CGSize(width: 100, height: 100)
        // top right
        bin_1.anchorPoint = CGPoint(x: 1, y: 1)
        bin_1.size = CGSize(width: bin_1.size.width / 2, height: bin_1.size.height/2)
        bin_1.position = CGPointMake(self.size.width, self.size.height)
        bin_1.zPosition = 3
        //bin_1.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(bin_1.size.width, bin_1.size.height))
        bin_1.physicsBody = SKPhysicsBody(circleOfRadius: bin_1.size.width)
        bin_1.physicsBody?.dynamic=false
        bin_1.physicsBody?.affectedByGravity = false
        bin_1.physicsBody?.categoryBitMask=PhysicsCategory.Bin
        bin_1.physicsBody?.collisionBitMask=PhysicsCategory.Shape
        bin_1.physicsBody?.contactTestBitMask=PhysicsCategory.Shape
        bin_1.name = "bin_1"
        
        //bin_2.size = CGSize(width: 100, height: 100)
        // top left
        bin_2.anchorPoint = CGPoint(x: 0, y: 1)
        bin_2.size = CGSize(width: bin_2.size.width / 2, height: bin_2.size.height/2)
        bin_2.position = CGPointMake(0, self.size.height)
        bin_2.zPosition = 3
        //bin_2.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(bin_2.size.width, bin_2.size.height))
        bin_2.physicsBody = SKPhysicsBody(circleOfRadius: bin_2.size.width)
        bin_2.physicsBody?.dynamic=false
        bin_2.physicsBody?.affectedByGravity = false
        bin_2.physicsBody?.categoryBitMask=PhysicsCategory.Bin
        bin_2.physicsBody?.collisionBitMask=PhysicsCategory.Shape
        bin_2.physicsBody?.contactTestBitMask=PhysicsCategory.Shape
        bin_2.name = "bin_2"
        
        //bin_3.size = CGSize(width: 100, height: 100)
        // bottom right
        bin_3.anchorPoint = CGPoint(x: 1, y: 0)
        bin_3.size = CGSize(width: bin_3.size.width / 2, height: bin_3.size.height/2)
        bin_3.position = CGPointMake(self.size.width, 0)
        bin_3.zPosition = 3
        
        let physics = CGPointMake(self.frame.width * 2 / 3 + bin_3.size.width/2, self.frame.height / 10 - bin_3.size.height/2)
        //bin_3.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(bin_3.size.width, bin_3.size.height))
        //bin_3.physicsBody = SKPhysicsBody(circleOfRadius: bin_3.size.width/4, center: physics)
        bin_3.physicsBody = SKPhysicsBody(circleOfRadius: bin_3.size.width)
        bin_3.physicsBody?.dynamic=false
        bin_3.physicsBody?.affectedByGravity = false
        bin_3.physicsBody?.categoryBitMask=PhysicsCategory.Bin
        bin_3.physicsBody?.collisionBitMask=PhysicsCategory.Shape
        bin_3.physicsBody?.contactTestBitMask=PhysicsCategory.Shape

        bin_3.name = "bin_3"
        
        //bin_4.size = CGSize(width: 100, height: 100)
        //bottom left
        bin_4.anchorPoint = CGPointZero
        bin_4.size = CGSize(width: bin_4.size.width / 2, height: bin_4.size.height/2)
        bin_4.position = CGPointMake(0, 0)
        bin_4.zPosition = 3
        //bin_4.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(bin_4.size.width, bin_4.size.height))
        bin_4.physicsBody = SKPhysicsBody(circleOfRadius: bin_4.size.width)
        bin_4.physicsBody?.dynamic=false
        bin_4.physicsBody?.affectedByGravity = false
        bin_4.physicsBody?.categoryBitMask=PhysicsCategory.Bin
        bin_4.physicsBody?.collisionBitMask=PhysicsCategory.Shape
        bin_4.physicsBody?.contactTestBitMask=PhysicsCategory.Shape

        bin_4.name = "bin_4"
        
        self.addChild(bin_1)
        self.addChild(bin_2)
        self.addChild(bin_3)
        self.addChild(bin_4)
        
        scoreLabel=SKLabelNode()
        scoreLabel.text="Score: "+String(score)
        scoreLabel.fontColor=UIColor.whiteColor()
        scoreLabel.position=CGPointMake(self.frame.width/2,self.frame.height/2)
        scoreLabel.zPosition=10
        self.addChild(scoreLabel)
        
        missedLabel = SKLabelNode()
        missedLabel.text = "Missed: " + String(missedCounter)
        missedLabel.fontColor = UIColor.redColor()
        missedLabel.position = CGPointMake(self.frame.width/2, self.frame.height/3)
        missedLabel.zPosition = 10
        self.addChild(missedLabel)

        gameOver = false
        //self.view?.backgroundColor = UIColor.blackColor();
        
    }
    
    func perfectFlick(shape: SKNode) {
        // increment score
        // do some lovely animation of shape exploding into pixels 
        // play audio 
        //shape.removeFromParent();
        print("successful flick")
    }
    
    func failedFlick(){
        // play sad audio
        // end game
        // some animation symbolizing something bad 
//        self.removeAllChildren();
//        self.addChild(bgImage);
        print("failed flick")
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if !gameOver {
            let firstBody=contact.bodyA
            let secondBody=contact.bodyB
            //print("BIN:",PhysicsCategory.Bin)
            //print("SHAPE:",PhysicsCategory.Shape)
            //print("FIRST BODY:",firstBody.categoryBitMask)
            //print("SECOND BODY",secondBody.categoryBitMask)
        
            if(firstBody.categoryBitMask==PhysicsCategory.Bin && secondBody.categoryBitMask==PhysicsCategory.Shape){
                //do something
                //check if collision is correct
                //remove shape
                //print("Collision by shape and bin")
            
                secondBody.node?.removeFromParent();
            
                //change to only increase score if it hits correct bin
                score++;
                scoreLabel.text="Score:"+String(score)
                //firstBody.node?.removeAllChildren();
            }
            else if (firstBody.categoryBitMask==PhysicsCategory.Shape && secondBody.categoryBitMask==PhysicsCategory.Bin){
                //print("Collision by shape and bin")
            
                firstBody.node?.removeFromParent();
            
                //change to only increase score if it hits correct bin
                score++;
                scoreLabel.text="Score:"+String(score)
            
            }
        }
        
//        if flicked into wrong bin {
//            missedCounter += 1
//            missedLabel.text = "Missed: " + String(missedCounter)
//        }
        /*
        print(contact.bodyA.node?.name);
        print(contact.bodyB.node?.name);
        if ((contact.bodyA.node!.name == shapes[0] && contact.bodyB.node!.name == bins[0]) || (
        contact.bodyA.node!.name == shapes[1] && contact.bodyB.node!.name == bins[1]) || (
        contact.bodyA.node!.name == shapes[2] && contact.bodyB.node!.name == bins[2]) || (
        contact.bodyA.node!.name == shapes[3] && contact.bodyB.node!.name == bins[3])){
            perfectFlick(contact.bodyA.node!)
        } else if ((contact.bodyB.node!.name == shapes[0] && contact.bodyA.node!.name == bins[0]) || (
        contact.bodyB.node!.name == shapes[1] && contact.bodyA.node!.name == bins[1]) || (
        contact.bodyB.node!.name == shapes[2] && contact.bodyA.node!.name == bins[2]) || (
        contact.bodyB.node!.name == shapes[3] && contact.bodyA.node!.name == bins[3])) {
            perfectFlick(contact.bodyB.node!)
        } else {
            failedFlick();
        }
        */
    }
    
    override func update(currentTime: CFTimeInterval) {
        if currentTime - time >= 2  {
            shapeToAdd = self.shapeController.spawnShape();
            shapeToAdd.position = CGPointMake(self.size.width/2, self.size.height/2);
            
            //print(shapeToAdd.physicsBody?.velocity);
            self.addChild(shapeToAdd);
            //shapeToAdd.physicsBody?.applyImpulse(CGVectorMake(shapeController.dx, shapeController.dy))
            //self.addChild(self.shapeController.spawnShape());
            time = currentTime;
            self.shapeController.speedUpVelocity(10);
        }
        removeOffScreenNodes()
        if missedCounter == NUMBEROFLIFES {
            createRestartBTN()
        }
    }
    
     // increment when shape goes off screen or when flicked into wrong bin
    func removeOffScreenNodes() {
        if !gameOver {
            for shape in shapes {
                self.enumerateChildNodesWithName(shape, usingBlock: {
                    node, stop in
                    let sprite = node as! SKSpriteNode
                    if (sprite.position.y < 0 || sprite.position.x < 0 || sprite.position.x > self.size.width || sprite.position.y > self.size.height) {
                        node.removeFromParent();
                        self.missedCounter += 1;
                        self.missedLabel.text = "Missed: " + String(self.missedCounter)
                    }
                })
            }
        }
    }
    
    
    
//        let spawn = SKAction.runBlock({
//            () in
//            self.addChild(self.shapeController.spawnShape())
//        })
//        let delay = SKAction.waitForDuration(2)
//        let spawnDelay = SKAction.sequence([spawn,delay])
//        let spawnDelayForever = SKAction.repeatActionForever(spawnDelay)
//        self.runAction(spawnDelayForever)
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.locationInNode(self)
        // Save start location and time
        start = location
        startTime = touch.timestamp
        let touchedNode=self.nodeAtPoint(start)
        oldVelocities[touchedNode]=touchedNode.physicsBody?.velocity;
        touchedNode.physicsBody?.velocity=CGVectorMake(0, 0)
        if restartBTN.containsPoint(location) {
            restartScene()
        }
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
            print(start)
            //make it move
            //touchedNode.physicsBody?.velocity=CGVectorMake(0.0, 0.0)
            
            //change these values to make the flick go faster/slower
            //touchedNode.physicsBody?.velocity=CGVectorMake(0, 0)
            touchedNode.physicsBody?.applyImpulse(CGVectorMake(100*dx, 100*dy))
        }
        else{
            let touchedNode=self.nodeAtPoint(start)
            if(oldVelocities[touchedNode] != nil){
                touchedNode.physicsBody?.velocity=oldVelocities[touchedNode]!
            }
        }
    }
    
    func createRestartBTN() {
        scoreLabel.text = ""
        missedLabel.text = ""
        restartBTN = SKSpriteNode(color: SKColor.blueColor(), size: CGSize(width: self.size.width/2, height: self.size.height/8))
        restartBTN.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        restartBTN.zPosition = 6
        self.addChild(restartBTN);
        gameOver = true
    }
    
    func restartScene() {
        // makes bins smaller
        restartBTN = SKSpriteNode() // stopped being able to click when not there
        self.removeAllActions()
        self.removeAllChildren()
        gameOver = false;
        score = 0
        missedCounter = 0
        createScene()
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
        
    }
}