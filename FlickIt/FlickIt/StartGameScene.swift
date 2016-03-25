
//
//  startGame.swift
//  FlickIt
//
//  Created by Apple on 2/20/16.
//  Copyright © 2016 Abhi_Shaili_Jeffrey_Rohan_Ashwin. All rights reserved.
//
import AVFoundation
import SpriteKit

class StartGameScene: SKScene, SKPhysicsContactDelegate {
    var bgImage = SKSpriteNode(imageNamed: "neon_circle.jpg");
    var startSquare = SKSpriteNode(imageNamed: "start_square.jpg");
    var launchSquare = SKSpriteNode(imageNamed: "launch_square.jpg");
    var rulesCircle = SKSpriteNode(imageNamed: "rules_circle.jpg");
    var launchCircle = SKSpriteNode(imageNamed: "launch_circle.jpg");
    
    var bin_1 = SKSpriteNode(imageNamed: "topRightBin.png"); //change this to differently oriented triangles
    var bin_2 = SKSpriteNode(imageNamed: "topLeftBin.png");
    var bin_3 = SKSpriteNode(imageNamed: "lowerRightBin.png");
    var bin_4 = SKSpriteNode(imageNamed: "lowerLeftBin.png");
    
    var bin_1_shape = SKSpriteNode(imageNamed: "blue_star-1"); //change this to differently oriented triangles
    var bin_2_shape = SKSpriteNode(imageNamed: "blue_square-1");
    var bin_3_shape = SKSpriteNode(imageNamed: "blue_circle-1");
    var bin_4_shape = SKSpriteNode(imageNamed: "blue_triangle-1");
    
    var score = 0;
    var lives = 3;
    
    let shapes = ["blue_triangle-1", "blue_square-1", "blue_circle-1","blue_star-1"]
    let bins = ["bin_1", "bin_2", "bin_3", "bin_4"]
    
    var start=CGPoint();
    var startTime=NSTimeInterval();
    let kMinDistance=CGFloat(50)
    let kMinDuration=CGFloat(0)
    let kMinSpeed=CGFloat(100)
    let kMaxSpeed=CGFloat(500)
    var scoreLabel=SKLabelNode()
    var livesLabel = SKLabelNode()
    var time : CFTimeInterval = 2;
    var shapeToAdd = SKSpriteNode();
    var touched:Bool = false;
    var shapeController = SpawnShape();
    var restartBTN = SKSpriteNode();
    var gameOver = false; // SET THESE
    var oldVelocities = [SKNode: CGVector]()
    var binWidth = CGFloat(0);
    var shapeScaleFactor = CGFloat(0);
    var audioPlayer = AVAudioPlayer()
    
    let sizeRect = UIScreen.mainScreen().applicationFrame;
    // Actual dimensions of the screen
    var sceneHeight = CGFloat(0);
    var sceneWidth = CGFloat(0);
    
    override init(size: CGSize) {
        super.init(size: size)
        createScene()
        playMusic("spectre", type: "mp3")
    }
    
    func playMusic(path: String, type: String) {
        let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(path, ofType: type)!)
        print(alertSound)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            try audioPlayer = AVAudioPlayer(contentsOfURL: alertSound)
        }
        catch {
            
        }
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createScene() {
        self.physicsWorld.contactDelegate = self 
        sceneHeight = sizeRect.size.height * UIScreen.mainScreen().scale;
        sceneWidth = sizeRect.size.width * UIScreen.mainScreen().scale;
        // Sets the neon circle image to fill the entire screen
        bgImage.size = CGSize(width: self.size.width, height: self.size.height);
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        bgImage.zPosition = 1
        self.addChild(bgImage);
        
        print("Entered create scene")
        //print(self.size.width)
        //print(self.size.height)
        
        binWidth = bin_1.size.width;
        shapeScaleFactor = 0.14*self.size.width/bin_3_shape.size.width
        
        //adds bins on all 4 corners of screen with name, zposition and size
        //bin_1.size = CGSize(width: 100, height: 100)
        // top right
        bin_1.anchorPoint = CGPoint(x: 1, y: 1)
        bin_1.setScale(0.264*self.size.width/bin_1.size.width) // see Ashwin's paper for scaling math
        bin_1.position = CGPointMake(self.size.width, self.size.height)
        bin_1.zPosition = 3
        //bin_1.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(bin_1.size.width, bin_1.size.height))
        bin_1.physicsBody = SKPhysicsBody(circleOfRadius: bin_1.size.width)
        bin_1.physicsBody?.dynamic=false
        bin_1.physicsBody?.affectedByGravity = false
        bin_1.physicsBody?.categoryBitMask=PhysicsCategory.Bin
        bin_1.physicsBody?.collisionBitMask=PhysicsCategory.Shape
        bin_1.physicsBody?.contactTestBitMask=PhysicsCategory.Shape
        //        bin_1.name = "bin_1"
        
        bin_1_shape.anchorPoint = CGPoint(x: 1, y: 1)
        bin_1_shape.setScale(shapeScaleFactor)
        bin_1_shape.position = CGPointMake(self.size.width - binWidth/20, self.size.height - binWidth/20)
        bin_1_shape.zPosition = 4;
        
        bin_1.name = shapes[3] //set bin names to name of shapes they take
        
        //bin_2.size = CGSize(width: 100, height: 100)
        // top left
        bin_2.anchorPoint = CGPoint(x: 0, y: 1)
        bin_2.setScale(0.264*self.size.width/bin_2.size.width)
        bin_2.position = CGPointMake(0, self.size.height)
        bin_2.zPosition = 3
        //bin_2.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(bin_2.size.width, bin_2.size.height))
        bin_2.physicsBody = SKPhysicsBody(circleOfRadius: bin_2.size.width)
        bin_2.physicsBody?.dynamic=false
        bin_2.physicsBody?.affectedByGravity = false
        bin_2.physicsBody?.categoryBitMask=PhysicsCategory.Bin
        bin_2.physicsBody?.collisionBitMask=PhysicsCategory.Shape
        bin_2.physicsBody?.contactTestBitMask=PhysicsCategory.Shape
        //        bin_2.name = "bin_2"
        
        bin_2_shape.anchorPoint = CGPoint(x: 0, y: 1)
        bin_2_shape.setScale(shapeScaleFactor)
        bin_2_shape.position = CGPointMake(binWidth / 20, self.size.height - binWidth/20)
        bin_2_shape.zPosition = 4;
        
        bin_2.name = shapes[1] //set bin names to name of shapes they take
        
        //bin_3.size = CGSize(width: 100, height: 100)
        // bottom right
        bin_3.anchorPoint = CGPoint(x: 1, y: 0)
        bin_3.setScale(0.264*self.size.width/bin_3.size.width)
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
        //        bin_3.name = "bin_3"
        //
        bin_3_shape.anchorPoint = CGPoint(x: 1, y: 0)
        bin_3_shape.setScale(shapeScaleFactor)
        bin_3_shape.position = CGPointMake(self.size.width - binWidth/20, binWidth/20)
        bin_3_shape.zPosition = 4;
        
        bin_3.name = shapes[2] //set bin names to name of shapes they take
        
        //bin_4.size = CGSize(width: 100, height: 100)
        //bottom left
        bin_4.anchorPoint = CGPointZero
        bin_4.setScale(0.264*self.size.width/bin_4.size.width)
        bin_4.position = CGPointMake(0, 0)
        bin_4.zPosition = 3
        //bin_4.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(bin_4.size.width, bin_4.size.height))
        bin_4.physicsBody = SKPhysicsBody(circleOfRadius: bin_4.size.width)
        bin_4.physicsBody?.dynamic=false
        bin_4.physicsBody?.affectedByGravity = false
        bin_4.physicsBody?.categoryBitMask=PhysicsCategory.Bin
        bin_4.physicsBody?.collisionBitMask=PhysicsCategory.Shape
        bin_4.physicsBody?.contactTestBitMask=PhysicsCategory.Shape
        //        bin_4.name = "bin_4"
        
        bin_4_shape.anchorPoint = CGPoint(x: 0, y: 0)
        bin_4_shape.setScale(shapeScaleFactor)
        bin_4_shape.position = CGPointMake(binWidth/20, binWidth/20)
        bin_4_shape.zPosition = 4;
        
        bin_4.name = shapes[0] //set bin names to name of shapes they take
        
        self.addChild(bin_1)
        self.addChild(bin_2)
        self.addChild(bin_3)
        self.addChild(bin_4)
        
        self.addChild(bin_1_shape)
        self.addChild(bin_2_shape)
        self.addChild(bin_3_shape)
        self.addChild(bin_4_shape)
        
        scoreLabel=SKLabelNode()
        scoreLabel.text="Score: "+String(score)
        scoreLabel.fontColor=UIColor.whiteColor()
        scoreLabel.position=CGPointMake(self.frame.width/2,self.frame.height/2)
        scoreLabel.zPosition=10
        self.addChild(scoreLabel)
        
        livesLabel = SKLabelNode()
        livesLabel.text = "Lives: " + String(lives)
        livesLabel.fontColor = UIColor.redColor()
        livesLabel.position = CGPointMake(self.frame.width/2, self.frame.height/3)
        livesLabel.zPosition = 10
        self.addChild(livesLabel)
        
        gameOver = false
        //self.view?.backgroundColor = UIColor.blackColor();
        
        
        //RANDOMIZED SHAPE SELECTING CODE --> FIX THIS LATER
        //        var binList = [bin_1, bin_2, bin_3, bin_4] //list of bins
        //        var i = 0;
        //        var shapePickedlist = [Int] () //list of random numbers already chosen
        //
        //        while (i < 4) {
        //            let shapePicker = Int(arc4random_uniform(4))
        //            var j = 0;
        //            while (j < shapePickedlist.count) {
        //                if (shapePickedlist[j] == shapePicker) {
        //                    j = j+5
        //                }
        //                j = j+1
        //            }
        //            if (j == shapePickedlist.count){
        //                shapePickedlist.append(shapePicker)
        //                let binShape = SKSpriteNode(imageNamed: shapes[shapePicker])
        //                binList[shapePicker].name = shapes[shapePicker]
        //                binShape.position = binList[i].position
        //                self.addChild(binShape)
        //                i = i+1
        //            }
        //            else {}
        //        }
        
        
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
            
            if(firstBody.categoryBitMask==PhysicsCategory.Bin && secondBody.categoryBitMask==PhysicsCategory.Shape){
                //do something
                //check if collision is correct
                //remove shape
                //print("Collision by shape and bin")
                
                //check if shape name == bin name, correct shape
                //score changes
                if (firstBody.node?.name == secondBody.node?.name) {
                    score++
                    //explode secondBody
                    /*
                    let explosionEmitterNode = SKEmitterNode(fileNamed:"ExplosionEffect.sks")
                    explosionEmitterNode!.position = CGPointMake((secondBody.node?.position.x)!,(secondBody.node?.position.y)!)
                    let angle=atan2(secondBody.velocity.dy,secondBody.velocity.dx)
                    explosionEmitterNode?.emissionAngle=angle
                    explosionEmitterNode?.zPosition=100
                    self.addChild(explosionEmitterNode!)
                    */
                    
                } else {
                    lives--
                }
                scoreLabel.text="Score:"+String(score)
                livesLabel.text = "Lives:" + String(lives)
                secondBody.node?.removeFromParent();
                //firstBody.node?.removeAllChildren();
            }
            else if (firstBody.categoryBitMask==PhysicsCategory.Shape && secondBody.categoryBitMask==PhysicsCategory.Bin){
                //print("Collision by shape and bin")
            
                
                if (firstBody.node?.name == secondBody.node?.name) {
                    score++
                    let explosionEmitterNode = SKEmitterNode(fileNamed:"ExplosionEffect.sks")
                    
                    explosionEmitterNode!.position = contact.contactPoint
                    let angle=atan2(firstBody.velocity.dy,firstBody.velocity.dx)
                    explosionEmitterNode?.emissionAngle=angle*CGFloat(180/M_PI)
                    print("ADSADASd    ",angle*CGFloat(180/M_PI))
                    explosionEmitterNode?.zPosition=100
                    self.addChild(explosionEmitterNode!)
                } else {
                    lives--
                }
                scoreLabel.text="Score:"+String(score)
                livesLabel.text = "Lives:" + String(lives)
                firstBody.node?.removeFromParent();
            }
        }
        
        //        if flicked into wrong bin {
        //            missedCounter += 1
        //            livesLabel.text = "Missed: " + String(missedCounter)
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
        if lives == 0 {
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
                        self.lives -= 1;
                        self.livesLabel.text = "Lives: " + String(self.lives)
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
        livesLabel.text = ""
        restartBTN = SKSpriteNode(imageNamed: "restartBTN")
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
        lives = 3
        createScene()
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
        
    }
}