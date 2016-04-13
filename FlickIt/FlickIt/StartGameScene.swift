
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
    var NUMBEROFLIFES = 3

    let red: UIColor = UIColor(red: 164/255, green: 84/255, blue: 80/255, alpha: 1)
    let blue: UIColor = UIColor(red: 85/255, green: 135/255, blue: 141/255, alpha: 1)
    let green: UIColor = UIColor(red: 147/255, green: 158/255, blue: 106/255, alpha: 1)
    let purple: UIColor = UIColor(red: 99/255, green: 103/255, blue: 211/255, alpha: 1)
    let yellow: UIColor = UIColor(red: 250/255, green: 235/255, blue: 83/255, alpha: 1)
    
    var bomb = SKSpriteNode(imageNamed: "bomb.png")
    var hand = SKSpriteNode(imageNamed: "hand_icon")
    var showHand = 0;
    var touching = false;
    
    var bgImage = SKSpriteNode(imageNamed: "background.png");

    var bin_1_pos = 1;
    
    //var bin_1 = SKSpriteNode(imageNamed: "blue_bin_t.png"); // all bins are facing bottom right corner
    //var bin_2 = SKSpriteNode(imageNamed: "red_bin_t.png");
    //var bin_3 = SKSpriteNode(imageNamed: "green_bin_t.png");
    //var bin_4 = SKSpriteNode(imageNamed: "purple_bin_t.png");
    var bin_1 = SKShapeNode()
    var bin_2 = SKShapeNode()
    var bin_3 = SKShapeNode()
    var bin_4 = SKShapeNode()
    
    var bin_1_shape = SKSpriteNode(imageNamed: "blue_star-1"); //change this to differently oriented triangles
    var bin_2_shape = SKSpriteNode(imageNamed: "blue_square-1");
    var bin_3_shape = SKSpriteNode(imageNamed: "blue_circle-1");
    var bin_4_shape = SKSpriteNode(imageNamed: "blue_triangle-1");
    
    var bin_3_shape_width = CGFloat(1024)
    var bin_1_width = CGFloat(85)
    var bin_2_width = CGFloat(85)
    var bin_3_width = CGFloat(85)
    var bin_4_width = CGFloat(85)

    var pauseButton = SKSpriteNode(imageNamed: "pauseButton")
    var score = 0;
    var lives = 3;
    
    let shapes = ["pentagon", "square","circle","triangle", "gameOverStar", "bomb"]
    var bin_shape_image_names = ["blue_pentagon-1", "blue_square-1", "blue_circle-1","blue_triangle-1"]
    let bins = ["bin_1", "bin_2", "bin_3", "bin_4"]
    
    var start=CGPoint();
    var startTimeOfTouch=NSTimeInterval();
    let kMinDistance=CGFloat(20)
    let kMinDuration=CGFloat(0)
    let kMaxSpeed=CGFloat(200)
    var scoreLabel=SKLabelNode()
    var livesLabel = SKLabelNode()
    var time : CFTimeInterval = 2;
    var shapeToAdd = SKNode();
    var touched:Bool = false;
    var shapeController = SpawnShape();
    var gameSceneController = GameScene();
    var restartBTN = SKSpriteNode();
    var gameOver = false; // SET THESE
    var oldVelocities = [SKNode: CGVector]()
    var binWidth = CGFloat(0);
    var shapeScaleFactor = CGFloat(0);
    var audioPlayer = AVAudioPlayer()
    var audioPlayer2 = AVAudioPlayer()
    var arePaused = false
    var pausedShapeVelocities = [SKNode: CGVector]()
    var aud2exists: Bool = false
    let sizeRect = UIScreen.mainScreen().applicationFrame;
    var line = SKShapeNode()
    var touchedNode=SKNode();
    
    var timeBegan = NSDate()
    
    // Actual dimensions of the screen
    var sceneHeight = CGFloat(0);
    var sceneWidth = CGFloat(0);
    
    override init(size: CGSize) {
        super.init(size: size)
        lives = NUMBEROFLIFES
        sceneHeight = sizeRect.size.height * UIScreen.mainScreen().scale;
        sceneWidth = sizeRect.size.width * UIScreen.mainScreen().scale;
        shapeScaleFactor = 0.14*self.size.width/bin_3_shape_width
        
        playMusic("spectre", type: "mp3")
        
        let radius = self.size.height/6
        
        addCurvedLines(bin_1, dub1: 0, dub2: M_PI/2, bol: true, arch: Double(self.size.height/2 + radius), radi: radius, color: red)
        //curve down shape
        addCurvedLines(bin_2, dub1: M_PI/2, dub2: M_PI, bol: true, arch: Double(self.size.height/2 - radius), radi: radius, color: blue)
        addCurvedLines(bin_3, dub1: M_PI, dub2: M_PI*3/2, bol: true, arch: Double(self.size.height/2 - radius), radi: radius, color: green)
        addCurvedLines(bin_4, dub1: M_PI*3/2, dub2: M_PI*2, bol: true, arch: Double(self.size.height/2 - radius), radi: radius, color: purple)
        
        //bin_1.anchorPoint = CGPoint(x: 1, y: 0)
        //bin_1.setScale(0.264*self.size.width/bin_1_width) // see Ashwin's paper for scaling math
        bin_1.position = CGPointMake(self.size.width, self.size.height)
        //bin_1.zRotation = CGFloat(-M_PI_2)
        bin_1.zPosition = 3
        //bin_1.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(bin_1.size.width, bin_1.size.height))
        bin_1.physicsBody = SKPhysicsBody(circleOfRadius: bin_1.frame.size.width)
        bin_1.physicsBody?.dynamic=false
        bin_1.physicsBody?.affectedByGravity = false
        bin_1.physicsBody?.categoryBitMask=PhysicsCategory.Bin
        bin_1.physicsBody?.collisionBitMask=PhysicsCategory.Shape
        bin_1.physicsBody?.contactTestBitMask=PhysicsCategory.Shape
        //        bin_1.name = "bin_1"
        bin_1.name = shapes[0] //set bin names to name of shapes they take

        
        //bin_2.size = CGSize(width: 100, height: 100)
        // top left
        //bin_2.anchorPoint = CGPoint(x: 1, y: 0)
        //bin_2.zRotation = 0
        //bin_2.setScale(0.264*self.size.width/bin_2_width)
        bin_2.position = CGPointMake(0, self.size.height)
        // don't rotate this bin
        bin_2.zPosition = 3
        //bin_2.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(bin_2.size.width, bin_2.size.height))
        bin_2.physicsBody = SKPhysicsBody(circleOfRadius: bin_2.frame.size.width)
        bin_2.physicsBody?.dynamic=false
        bin_2.physicsBody?.affectedByGravity = false
        bin_2.physicsBody?.categoryBitMask=PhysicsCategory.Bin
        bin_2.physicsBody?.collisionBitMask=PhysicsCategory.Shape
        bin_2.physicsBody?.contactTestBitMask=PhysicsCategory.Shape
        //        bin_2.name = "bin_2"
        bin_2.name = shapes[1] //set bin names to name of shapes they take
        
        //bin_3.size = CGSize(width: 100, height: 100)
        // bottom right
        //bin_3.anchorPoint = CGPoint(x: 1, y: 0)
        bin_3.position = CGPointMake(0, 0)
        //bin_3.setScale(0.264*self.size.width/bin_3_width)
        //bin_3.zRotation = CGFloat(M_PI)
        bin_3.zPosition = 3
        
        //let physics = CGPointMake(self.frame.width * 2 / 3 + bin_3.size.width/2, self.frame.height / 10 - bin_3.size.height/2)
        //bin_3.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(bin_3.size.width, bin_3.size.height))
        //bin_3.physicsBody = SKPhysicsBody(circleOfRadius: bin_3.size.width/4, center: physics)
        bin_3.physicsBody = SKPhysicsBody(circleOfRadius: bin_3.frame.size.width)
        bin_3.physicsBody?.dynamic=false
        bin_3.physicsBody?.affectedByGravity = false
        bin_3.physicsBody?.categoryBitMask=PhysicsCategory.Bin
        bin_3.physicsBody?.collisionBitMask=PhysicsCategory.Shape
        bin_3.physicsBody?.contactTestBitMask=PhysicsCategory.Shape
        //        bin_3.name = "bin_3"
        bin_3.name = shapes[2] //set bin names to name of shapes they take
        
        //bin_4.size = CGSize(width: 100, height: 100)
        //bottom left
        //bin_4.anchorPoint = CGPoint(x: 1, y: 0)
        //bin_4.setScale(0.264*self.size.width/bin_4_width)
        bin_4.position = CGPointMake(self.size.width, 0)
        //bin_4.zRotation = CGFloat(M_PI_2)
        bin_4.zPosition = 3
        //bin_4.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(bin_4.size.width, bin_4.size.height))
        bin_4.physicsBody = SKPhysicsBody(circleOfRadius: bin_4.frame.size.width)
        bin_4.physicsBody?.dynamic=false
        bin_4.physicsBody?.affectedByGravity = false
        bin_4.physicsBody?.categoryBitMask=PhysicsCategory.Bin
        bin_4.physicsBody?.collisionBitMask=PhysicsCategory.Shape
        bin_4.physicsBody?.contactTestBitMask=PhysicsCategory.Shape
        //        bin_4.name = "bin_4"
        bin_4.name = shapes[3] //set bin names to name of shapes they take


        
        self.addChild(bin_1)
        self.addChild(bin_2)
        self.addChild(bin_3)
        self.addChild(bin_4)
        
        createScene()
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
    
    func playMusic2(path: String, type: String) {
        let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(path, ofType: type)!)
        print(alertSound)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            try audioPlayer2 = AVAudioPlayer(contentsOfURL: alertSound)
        }
        catch {
            
        }
        audioPlayer2.prepareToPlay()
        audioPlayer2.play()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createScene() {
        timeBegan = NSDate()
        self.physicsWorld.contactDelegate = self
        bgImage.size = CGSize(width: self.size.width, height: self.size.height);
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        bgImage.zPosition = 1
        self.addChild(bgImage);
        //adds bins on all 4 corners of screen with name, zposition and size
        //bin_1.size = CGSize(width: 100, height: 100)
        // top right
        
        bin_1_shape.anchorPoint = CGPoint(x: 1, y: 1)
        //bin_1_shape.setScale(shapeScaleFactor)
        bin_1_shape.setScale(0.05) //CHANGE THIS
        bin_1_shape.position = CGPointMake(self.size.width - binWidth/20, self.size.height - binWidth/20)
        bin_1_shape.zPosition = 4;
        bin_1_shape.texture = SKTexture(imageNamed: "blue_pentagon-1")
        
        
        
        bin_2_shape.anchorPoint = CGPoint(x: 0, y: 1)
        bin_2_shape.setScale(shapeScaleFactor)
        bin_2_shape.position = CGPointMake(binWidth / 20, self.size.height - binWidth/20)
        bin_2_shape.zPosition = 4;
        bin_2_shape.texture = SKTexture(imageNamed: "blue_square-1")

        //
        bin_3_shape.anchorPoint = CGPoint(x: 0, y: 0)
        bin_3_shape.setScale(shapeScaleFactor)
        bin_3_shape.position = CGPointMake(0, 0)
        bin_3_shape.zPosition = 4;
        bin_3_shape.texture = SKTexture(imageNamed: "blue_circle-1")

       
        
        
        bin_4_shape.anchorPoint = CGPoint(x: 1, y: 0)
        bin_4_shape.setScale(shapeScaleFactor)
        bin_4_shape.position = CGPointMake(self.size.width, 0)
        bin_4_shape.zPosition = 4;
        bin_4_shape.texture = SKTexture(imageNamed: "blue_triangle-1")

       
        self.addChild(bin_1_shape)
        self.addChild(bin_2_shape)
        self.addChild(bin_3_shape)
        self.addChild(bin_4_shape)
        
        scoreLabel=SKLabelNode()
        scoreLabel.text="Score: "+String(score)
        scoreLabel.fontColor=UIColor.whiteColor()
        scoreLabel.position=CGPointMake(self.frame.width/2,self.frame.height * 7.5/9)
        scoreLabel.zPosition=2
        scoreLabel.fontName = "Open Sans Cond Light"
        self.addChild(scoreLabel)
        
        livesLabel = SKLabelNode()
        livesLabel.text = "Lives: " + String(lives)
        livesLabel.fontColor = UIColor.redColor()
        livesLabel.position = CGPointMake(self.frame.width/2, self.frame.height * 0.5/9)
        livesLabel.zPosition = 2
        livesLabel.fontName = "Open Sans Cond Light"
        self.addChild(livesLabel)
        
        gameOver = false
        delay(0.25) {
            self.animateBinsRestart()
        }
//        delay(5) {
//            self.rotateBins()
//            
//        }
        pauseButton.zPosition = 5
        pauseButton.setScale(0.5)
        pauseButton.name = "pauseButton"
        pauseButton.position = CGPointMake(self.size.width / 2, 15*self.size.height/16)
        self.addChild(pauseButton)
        
        
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
        
        track()
    }
    
    func track() {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Game Screen")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        let event = GAIDictionaryBuilder.createEventWithCategory("Action", action: "Play Game", label: nil, value: nil)
        tracker.send(event.build() as [NSObject : AnyObject])
    }
    
    // will randomly rotate the bins
    func rotateBins(randInt: Int) {
        //let randInt = Int(arc4random_uniform(2) + 1)
        bin_shape_image_names = bin_shape_image_names.rotate(randInt)
        bin_1_shape.texture = SKTexture(imageNamed: bin_shape_image_names[0])
        bin_2_shape.texture = SKTexture(imageNamed: bin_shape_image_names[1])
        bin_3_shape.texture = SKTexture(imageNamed: bin_shape_image_names[2])
        bin_4_shape.texture = SKTexture(imageNamed: bin_shape_image_names[3])
        
        let body1 = bin_1.physicsBody
        let body2 = bin_2.physicsBody
        let body3 = bin_3.physicsBody
        let body4 = bin_4.physicsBody
        
        bin_1.physicsBody = nil
        bin_2.physicsBody = nil
        bin_3.physicsBody = nil
        bin_4.physicsBody = nil
        
        if ((randInt == 1 && bin_1_pos == 1) || (randInt == 3 && bin_1_pos == 3) || (randInt == 2 && bin_1_pos == 4)) { // 3 to bottom right, 2 to bottom left, 1 to top left, 4 to top right
            
            let rotate = SKAction.rotateToAngle(-(CGFloat(M_PI_2)), duration: 0.5, shortestUnitArc: true)
            let action1 = SKAction.moveTo(CGPoint(x: 0, y: self.size.height), duration: 0.5)
            let action2 = SKAction.moveTo(CGPoint(x: 0, y: 0), duration: 0.5)
            let action3 = SKAction.moveTo(CGPoint(x: self.size.width, y: 0), duration: 0.5)
            let action4 = SKAction.moveTo(CGPoint(x: self.size.width, y: self.size.height), duration: 0.5)
            
            bin_1.runAction(rotate)
            bin_1.runAction(action1)
            
            bin_2.runAction(rotate)
            bin_2.runAction(action2)
            
            bin_3.runAction(rotate)
            bin_3.runAction(action3)
            
            bin_4.runAction(rotate)
            bin_4.runAction(action4)
            
            bin_1_pos = 2
        }
        
        else if ((bin_1_pos == 1 && randInt == 2) || (bin_1_pos == 2 && randInt == 1) || (bin_1_pos == 4 && randInt == 3)) { // 1 to bottom left, 3 to top right, 2 to bottom right, 4 to top lef
            
            let rotate = SKAction.rotateToAngle(0, duration: 0.5, shortestUnitArc: true)
            let action1 = SKAction.moveTo(CGPoint(x: 0, y: 0), duration: 0.5)
            let action2 = SKAction.moveTo(CGPoint(x: self.size.width, y: 0), duration: 0.5)
            let action3 = SKAction.moveTo(CGPoint(x: self.size.width, y: self.size.height), duration: 0.5)
            let action4 = SKAction.moveTo(CGPoint(x: 0, y: self.size.height), duration: 0.5)
            
            bin_1.runAction(rotate)
            bin_1.runAction(action1)
            
            bin_2.runAction(rotate)
            bin_2.runAction(action2)
            
            bin_3.runAction(rotate)
            bin_3.runAction(action3)
            
            bin_4.runAction(rotate)
            bin_4.runAction(action4)
            
            bin_1_pos = 3
        }
        
        else if ((bin_1_pos == 1 && randInt == 3) || (bin_1_pos == 2 && randInt == 2) || (bin_1_pos == 3 && randInt == 1)) { // 1 to bottom right, 2 to top right, 3 to top left, 4 to bottom lef
            
            let rotate = SKAction.rotateToAngle((CGFloat(M_PI_2)), duration: 0.5, shortestUnitArc: true)
            let action1 = SKAction.moveTo(CGPoint(x: self.size.width, y: 0), duration: 0.5)
            let action2 = SKAction.moveTo(CGPoint(x: self.size.width, y: self.size.height), duration: 0.5)
            let action3 = SKAction.moveTo(CGPoint(x: 0, y: self.size.height), duration: 0.5)
            let action4 = SKAction.moveTo(CGPoint(x: 0, y: 0), duration: 0.5)
            
            bin_1.runAction(rotate)
            bin_1.runAction(action1)
            
            bin_2.runAction(rotate)
            bin_2.runAction(action2)
            
            bin_3.runAction(rotate)
            bin_3.runAction(action3)
            
            bin_4.runAction(rotate)
            bin_4.runAction(action4)
            
            bin_1_pos = 4
        }
        else if ((bin_1_pos == 2 && randInt == 3) || (bin_1_pos == 3 && randInt == 2) || (bin_1_pos == 4 && randInt == 1)) { // 1 to top right, 2 to top left, 3 to bottom left, 4 to bottom righ
            
            let rotate = SKAction.rotateToAngle((CGFloat(M_PI)), duration: 0.5, shortestUnitArc: true)
            let action1 = SKAction.moveTo(CGPoint(x: self.size.width, y: self.size.height), duration: 0.5)
            let action2 = SKAction.moveTo(CGPoint(x: 0, y: self.size.height), duration: 0.5)
            let action3 = SKAction.moveTo(CGPoint(x: 0, y: 0), duration: 0.5)
            let action4 = SKAction.moveTo(CGPoint(x: self.size.width, y: 0), duration: 0.5)
            
            bin_1.runAction(rotate)
            bin_1.runAction(action1)
            
            bin_2.runAction(rotate)
            bin_2.runAction(action2)
            
            bin_3.runAction(rotate)
            bin_3.runAction(action3)
            
            bin_4.runAction(rotate)
            bin_4.runAction(action4)
            
            bin_1_pos = 1
        }
        
        delay(0.6) {
            //self.disableBinsPhysicsBody = false;
            self.bin_1.physicsBody = body1
            self.bin_2.physicsBody = body2
            self.bin_3.physicsBody = body3
            self.bin_4.physicsBody = body4
        }
    }
    
    func addCurvedLines(curve: SKShapeNode, dub1: Double, dub2: Double, bol: Bool, arch: Double, radi: CGFloat, color: UIColor) {
        let circlePath : UIBezierPath = UIBezierPath(arcCenter: CGPointMake(CGFloat(0), CGFloat(0)), radius: radi, startAngle: CGFloat(dub1), endAngle: CGFloat(dub2), clockwise: bol)
        curve.path = circlePath.CGPath
        curve.strokeColor = color
        curve.lineWidth = 3
        curve.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        curve.zRotation = CGFloat(M_PI)
    }
    
    func animateBinsAtStart() {
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI), duration: 1.0);
        //bin_1.anchorPoint = CGPoint(x: 0, y: 1)
        bin_1.runAction(rotate)
        bin_1.runAction(SKAction.moveTo(CGPoint(x: self.size.width, y: self.size.height), duration: 1.0))
        
        bin_2.runAction(rotate)
        bin_2.runAction(SKAction.moveTo(CGPoint(x: 0, y: self.size.height), duration: 1.0))
        
        bin_3.runAction(rotate)
        bin_3.runAction(SKAction.moveTo(CGPoint(x: 0, y: 0), duration: 1.0))
        
        bin_4.runAction(rotate)
        bin_4.runAction(SKAction.moveTo(CGPoint(x: self.size.width, y: 0), duration: 1.0))
        //bin_2.runAction(SKAction.group([rotate, SKAction.moveTo(CGPoint(x: 0, y: self.size.height), duration: 1.0)]))
        //bin_3.runAction(SKAction.group([rotate, SKAction.moveTo(CGPoint(x: self.size.width, y: 0), duration: 1.0)]))
        //bin_4.runAction(SKAction.group([rotate, SKAction.moveTo(CGPoint(x: 0, y: 0), duration: 1.0)]))
    }
    
    func animateBinsRestart() {
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI), duration: 1.0);
        let move = SKAction.moveTo(CGPoint(x: self.size.width / 2, y: self.size.height / 2), duration: 1.0)
        //bin_1.anchorPoint = CGPoint(x: 0, y: 1)
        bin_1.runAction(rotate)
        bin_1.runAction(move)
        
        bin_2.runAction(rotate)
        bin_2.runAction(move)
        
        bin_3.runAction(rotate)
        bin_3.runAction(move)
        
        bin_4.runAction(rotate)
        bin_4.runAction(move)
        delay(0.25) {
            self.animateBinsAtStart();
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody=contact.bodyA
        var secondBody=contact.bodyB
        if(firstBody.categoryBitMask==PhysicsCategory.Bin && secondBody.categoryBitMask==PhysicsCategory.Shape){
            firstBody=contact.bodyB
            secondBody=contact.bodyA
        }
        if !gameOver && !arePaused {
            if (firstBody.categoryBitMask==PhysicsCategory.Shape && secondBody.categoryBitMask==PhysicsCategory.Bin){
                if(firstBody.node!.name=="bomb"){
                    firstBody.node?.removeFromParent()
                }
                else{
                    let explosionEmitterNode = SKEmitterNode(fileNamed:"ExplosionEffect.sks")
                    explosionEmitterNode!.position = contact.contactPoint
                    explosionEmitterNode?.zPosition=100
                    if (firstBody.node?.name == secondBody.node?.name) {
                        score += 1
                    } else {
                        explosionEmitterNode?.particleColorSequence=SKKeyframeSequence(keyframeValues: [UIColor.redColor()], times: [0])
                        lives -= 1
                    }
                    self.addChild(explosionEmitterNode!)
                    scoreLabel.text="Score: "+String(score)
                    livesLabel.text = "Lives: " + String(lives)
                    firstBody.node?.removeFromParent();
                    if(score % 3 == 0){
                        self.rotateBins(Int(arc4random_uniform(2) + 1));
                    }

                }
            }
        }
        else {
            if (firstBody.categoryBitMask==PhysicsCategory.Shape && secondBody.categoryBitMask==PhysicsCategory.Bin){
                let shapeName = firstBody.node?.name
                if (shapeName != "gameOverStar") {
                    return;
                }
                let binName = secondBody.node?.name
                if (binName == "restart") {
                    restartScene()
                } else if (binName == "home") {
                    self.removeAllChildren()
                    self.goToHome()
                } else if (binName == "highScore") {
                    print("go to high")
                } else if (binName == "settings") {
                    print("go to settings")
                }
            }
        }
    }
    
    func goToHome() {
        let scene: SKScene = GameScene(size: self.size)
        // Configure the view.
        let skView = self.view as SKView!
        skView.showsFPS = false
        skView.showsNodeCount = false
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Home Screen")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        let event = GAIDictionaryBuilder.createEventWithCategory("Action", action: "Go To Home", label: nil, value: nil)
        tracker.send(event.build() as [NSObject : AnyObject])
    }
    
    var timeRequired = 2.0
    var firstTimeCount = 1
    var timeSpeedUpFactor = 0.05
    var minTimeRequired = 0.75
    var multiplicativeSpeedUpFactor = 1.0
    
    override func update(currentTime: CFTimeInterval) {
        
        let didRemoveGameover = removeOffScreenNodes()
        if arePaused {
            time = currentTime
        } else if gameOver {
            if didRemoveGameover {
                gameOverStar.removeFromParent()
                setUpGameOverStar()
            }
        } else {
            if currentTime - time >= timeRequired {
                if (firstTimeCount > 0) {
                    time = currentTime;
                    firstTimeCount -= 1
                } else {
                    shapeToAdd = self.shapeController.spawnShape();
                    shapeToAdd.position = CGPointMake(self.size.width/2, self.size.height/2);
                    self.addChild(shapeToAdd);
                    if(score > 50 && Int(arc4random_uniform(3)) == 0){
                        //change above value for difficulty purposes!!!!!!!!
                        shapeToAdd = self.shapeController.spawnShape();
                        shapeToAdd.position = CGPointMake(self.size.width/2, self.size.height/2);
                        self.addChild(shapeToAdd);
                    }
                    //shapeToAdd.physicsBody?.applyImpulse(CGVectorMake(shapeController.dx, shapeController.dy))
                    //self.addChild(self.shapeController.spawnShape());
                    time = currentTime;
                    self.shapeController.speedUpVelocity(5);
                    //            timeRequired = max(timeRequired - timeSpeedUpFactor, minTimeRequired)
                    timeRequired = max(timeRequired * multiplicativeSpeedUpFactor, minTimeRequired)
                    //                self.shapeController.specialShapeProbability = max(Int(multiplicativeSpeedUpFactor * Double( self.shapeController.specialShapeProbability)), self.shapeController.sShapeProbabilityBound)
                    self.shapeController.specialShapeProbability = max(self.shapeController.specialShapeProbability - 4, self.shapeController.sShapeProbabilityBound)
                    multiplicativeSpeedUpFactor -= 0.005
                }
            }
            if lives == 0 {
                createRestartBTN()
            }
        }
    }

    // increment when shape goes off screen or when flicked into wrong bin
    // also kills pause button when theres another shape there
    func removeOffScreenNodes() -> Bool {
        var pauseBlocksShapeCounter = 0
        var didRemoveGameOver = false
        for shape in shapes {
            self.enumerateChildNodesWithName(shape, usingBlock: {
                node, stop in
                let sprite = node
                // CHECKS TO SEE IF ANY SHAPE IS ABOVE PAUSE
                if self.pauseButton.containsPoint(CGPointMake(sprite.position.x, sprite.position.y)){
                    pauseBlocksShapeCounter += 1
                }
                if (sprite.position.y < 0 || sprite.position.x < 0 || sprite.position.x > self.size.width || sprite.position.y > self.size.height) {
                    node.removeFromParent();
                    if !self.gameOver {
                        if node.name == "bomb" {
                            return;
                        }
                        self.lives -= 1;
                        let explosionEmitterNode = SKEmitterNode(fileNamed: "ExplosionEffect.sks")
                        explosionEmitterNode?.position=sprite.position
                        explosionEmitterNode?.zPosition=100
                        explosionEmitterNode?.particleColorSequence=SKKeyframeSequence(keyframeValues: [UIColor.redColor()], times: [0])
                        explosionEmitterNode?.particleLifetime=0.3
                        self.addChild(explosionEmitterNode!)
                        self.livesLabel.text = "Lives: " + String(self.lives)
                    } else {
                        if (node.name == "gameOverStar") {
                            didRemoveGameOver = true
                        }
                    }
                }
            })
        }
        if pauseBlocksShapeCounter == 0 {
            pauseButton.alpha = 1
        } else {
            pauseButton.alpha = 0
        }
        return didRemoveGameOver
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
        startTimeOfTouch = touch.timestamp
        
        
        if !arePaused {
            touchedNode=self.nodeAtPoint(start)
            if(touchedNode.name != nil){
                touching = true
            }
            /* This is for touching nodes within a range of 5 of your touch
            var i=CGFloat(0)
            var j=CGFloat(0)
            while(touchedNode != SKNode() && i < 5){
                touchedNode=self.nodeAtPoint(CGPoint(x: start.x+i,y: start.y))
                j=0
                while(touchedNode != SKNode() && j < 5){
                    touchedNode=self.nodeAtPoint(CGPoint(x: start.x,y: start.y+j))
                    j+=1
                }
                i+=1
            }
 */
            if(touchedNode.name=="bomb"){
                aud2exists = true
                playMusic2("bombSound", type: "mp3")
                lives=0;
                livesLabel.text="Lives:" + String(lives)
                let explosionEmitterNode = SKEmitterNode(fileNamed: "ExplosionEffect.sks")
                explosionEmitterNode?.position=touchedNode.position
                explosionEmitterNode?.zPosition=100
                explosionEmitterNode?.particleColorSequence=SKKeyframeSequence(keyframeValues: [UIColor.redColor()], times: [0])
                explosionEmitterNode?.particleLifetime=5.0
                explosionEmitterNode?.numParticlesToEmit=200
                explosionEmitterNode?.particleSpeed=100
                
                self.addChild(explosionEmitterNode!)
                touchedNode.removeFromParent()
                let tracker = GAI.sharedInstance().defaultTracker
                let event = GAIDictionaryBuilder.createEventWithCategory("Action", action: "Bombed", label: nil, value: nil)
                tracker.send(event.build() as [NSObject : AnyObject])
            } else if (touchedNode.name == "pauseButton") {
                openPause()
            }
            start=touchedNode.position;
            oldVelocities[touchedNode]=touchedNode.physicsBody?.velocity;
            touchedNode.physicsBody?.velocity=CGVectorMake(0, 0)
        } else {
            if unPausedLabel.containsPoint(location) {
                closePause()
            } else if muteLabel.containsPoint(location) {
                pressedMute()
            } else if (restartLabel.containsPoint(location)) {
                closePause()
                restartScene()
            } else if (homeLabel.containsPoint(location)) {
                goToHome()
                closePause()
            } else if (themeSettingsLabel.containsPoint(location)) {
                print("go to settings")
                closePause()
            }
            
        }
        delay(0.5) {
            if (self.gameOver && self.showHand > 2) {
                self.showHand = 0
                self.hand.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
                self.hand.xScale = 0.30
                self.hand.yScale = 0.30
                self.hand.zPosition = 3
                self.addChild(self.hand)
                let move = SKAction.moveTo(CGPoint(x: self.size.width * 3 / 8, y: self.size.height * 5 / 8), duration: 0.4)
                let remove = SKAction.removeFromParent()
                //self.hand.removeFromParent()
                self.hand.runAction(SKAction.sequence([move, remove]))
                print("entered this")
            }
        }
        showHand += 1;
    
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if ((!arePaused) && self.nodeAtPoint(start).name != nil && touching) {
            for touch in touches{
                self.removeChildrenInArray([line])
                let currentLocation=touch.locationInNode(self)
                createLine(currentLocation)
                self.addChild(line)
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.removeChildrenInArray([line])
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.locationInNode(self)
        // Determine distance from the starting point
        var dx: CGFloat = location.x - start.x
        var dy: CGFloat = location.y - start.y
        let timeOfTouch=touch.timestamp-startTimeOfTouch
        let magnitude: CGFloat = sqrt(dx * dx + dy * dy)
        if (magnitude >= kMinDistance){
            // Determine time difference from start of the gesture
            dx = dx / magnitude
            dy = dy / magnitude
            var speed=(magnitude/CGFloat(timeOfTouch))/5;
            if(speed > kMaxSpeed){
                speed = kMaxSpeed
            }
           
            //make it move
            //touchedNode.physicsBody?.velocity=CGVectorMake(0.0, 0.0)
            //change these values to make the flick go faster/slower
            //touchedNode.physicsBody?.velocity=CGVectorMake(0, 0)
            touchedNode.physicsBody?.applyImpulse(CGVectorMake(speed*dx, speed*dy))
        }
        else{
            let touchedNode=self.nodeAtPoint(start)
            if(oldVelocities[touchedNode] != nil){
                touchedNode.physicsBody?.velocity=oldVelocities[touchedNode]!
            }
        }
        touching = false
        
    }
    
    func createRestartBTN() {
        scoreLabel.text = ""
        livesLabel.text = ""
        gameOver = true
        playMusic("loser_goodbye", type: "mp3") // change to some lose song
        // change bin displays
        
        if (bin_1_pos == 2) {
            rotateBins(3)
        } else if (bin_1_pos == 3) {
            rotateBins(2)
        } else if (bin_1_pos == 4) {
            rotateBins(1)
        }
        
        bin_1_shape.texture = SKTexture(imageNamed:"graphs")
        bin_2_shape.texture = SKTexture(imageNamed:"refreshArrow")
        bin_3_shape.texture = SKTexture(imageNamed:"house")
        bin_4_shape.texture = SKTexture(imageNamed:"settingsPic")
        
        bin_1.name = "highScore"
        bin_2.name = "restart"
        bin_3.name = "settings"
        bin_4.name = "home"
        // Add gameover label and star node
        setupGameOverLabels()
        setUpGameOverStar()
        self.removeChildrenInArray([pauseButton])
        // add collision actions
        
        gameOverTrack()
    }
    
    func gameOverTrack() {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Lose Screen")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        let event = GAIDictionaryBuilder.createEventWithCategory("Action", action: "Lost", label: nil, value: nil)
        tracker.send(event.build() as [NSObject : AnyObject])
        tracker.set(GAIFields.customMetricForIndex(1), value: String(score))
        let timeElapsed = NSDate().timeIntervalSinceDate(timeBegan)
        tracker.set(GAIFields.customMetricForIndex(2), value: String(timeElapsed))
    }

    let gameOverLabel = SKLabelNode(text: "GAMEOVER")
    var gameOverStar = SKSpriteNode(imageNamed: "blue_star-1")
    let gameOverScoreLabel = SKLabelNode(text: "")

    func setupGameOverLabels() {
        gameOverLabel.position = CGPointMake(self.size.width/2, self.size.height/2);
        gameOverLabel.horizontalAlignmentMode = .Center
        gameOverLabel.fontColor = UIColor.whiteColor()
        gameOverLabel.fontName = "Open Sans Cond Light"
        gameOverLabel.fontSize = 22
        gameOverLabel.zPosition = 5
        self.addChild(gameOverLabel)
        gameOverScoreLabel.position = CGPointMake(self.size.width/2, self.size.height/2 + gameOverLabel.frame.height);
        gameOverScoreLabel.horizontalAlignmentMode = .Center
        gameOverScoreLabel.fontColor = UIColor.whiteColor()
        gameOverScoreLabel.fontName = "Open Sans Cond Light"
        gameOverScoreLabel.fontSize = 25
        gameOverScoreLabel.zPosition = 5
        gameOverScoreLabel.text = "Score " + String(score)
        self.addChild(gameOverScoreLabel)
    }
    
    func setUpGameOverStar() {
        self.shapeController.setUpSpecialShape(gameOverStar, scale: shapeScaleFactor)
        gameOverStar.position = CGPointMake(self.size.width/2, self.size.height/2 - self.gameOverLabel.frame.height);
        gameOverStar.name = "gameOverStar"
        self.addChild(gameOverStar)
    }
    
    
    func restartScene() {
        // makes bins smaller
        restartBTN = SKSpriteNode() // stopped being able to click when not there
        self.removeAllActions()
        self.removeAllChildren()
        
        self.addChild(bin_1)
        bin_1.position = CGPoint(x: self.size.width, y: self.size.height)
        bin_1.name = shapes[0]
        
        self.addChild(bin_2)
        bin_2.position = CGPoint(x: 0, y: self.size.height)
        bin_2.name = shapes[1]
        
        self.addChild(bin_3)
        bin_3.position = CGPoint(x: self.size.width, y: 0)
        bin_3.name = shapes[2]
        
        self.addChild(bin_4)
        bin_4.position = CGPoint(x: 0, y: 0)
        bin_4.name = shapes[3]
        
        animateBinsRestart()
        
        showHand = 0;
        gameOver = false;
        score = 0
        firstTimeCount = 1
        lives = NUMBEROFLIFES
        timeRequired = 2.0
        multiplicativeSpeedUpFactor = 1.0
        self.shapeController.resetVelocityBounds()
        createScene()
        self.shapeController.resetSpecialShapeProbability()
        self.shapeController.shapeCounter = [0,0,0,0,0]
        playMusic("spectre", type: "mp3")
    }
    
    var unPausedLabel = SKLabelNode()
    var muteLabel = SKLabelNode()
    var restartLabel = SKLabelNode()
    var homeLabel = SKLabelNode()
    var themeSettingsLabel = SKLabelNode()
    var pauseBackground = SKShapeNode()
    
    
    func openPause() {
        bgImage.runAction(SKAction.fadeAlphaTo(0.2, duration: 0.5));
        unPausedLabel.text = "Unpause"
        unPausedLabel.fontColor=UIColor.whiteColor()
        unPausedLabel.position=CGPointMake(self.frame.width/2, 9 * self.frame.height / 12)
        unPausedLabel.zPosition=5
        unPausedLabel.fontName = "Open Sans Cond Light"
        self.addChild(unPausedLabel)
        arePaused = true
        muteLabel.text = "Mute"
        muteLabel.fontColor=UIColor.whiteColor()
        muteLabel.position=CGPointMake(self.frame.width/2,3.5*self.frame.height/5)
        muteLabel.zPosition=5
        muteLabel.fontName = "Open Sans Cond Light"
        self.addChild(muteLabel)
        restartLabel.text = "Restart Game"
        restartLabel.fontColor=UIColor.whiteColor()
        restartLabel.position=CGPointMake(self.frame.width/2, 3*self.frame.height/5)
        restartLabel.zPosition=5
        restartLabel.fontName = "Open Sans Cond Light"
        self.addChild(restartLabel)
        homeLabel.text = "Go Home"
        homeLabel.fontColor=UIColor.whiteColor()
        homeLabel.position=CGPointMake(self.frame.width/2, 2*self.frame.height/5)
        homeLabel.zPosition=5
        homeLabel.fontName = "Open Sans Cond Light"
        self.addChild(homeLabel)
        themeSettingsLabel.text = "Pick a theme"
        themeSettingsLabel.fontColor=UIColor.whiteColor()
        themeSettingsLabel.position=CGPointMake(self.frame.width/2,self.frame.height/5)
        themeSettingsLabel.zPosition=5
        themeSettingsLabel.fontName = "Open Sans Cond Light"
        self.addChild(themeSettingsLabel)
        pauseBackground = SKShapeNode(rectOfSize: CGSize(width: 11 * self.size.width/16, height: 12 * self.size.height/16))
        pauseBackground.fillColor = UIColor(red: 70/255, green: 80/255, blue: 160/255, alpha: 0.5)
        pauseBackground.position = CGPointMake(self.size.width/2, self.size.height/2);
        pauseBackground.zPosition = 4
        self.addChild(pauseBackground)
        stopShapes()
        self.removeChildrenInArray([pauseButton])
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Pause Screen")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        let event = GAIDictionaryBuilder.createEventWithCategory("Action", action: "Pause", label: nil, value: nil)
        tracker.send(event.build() as [NSObject : AnyObject])
    }
    
    func stopShapes() {
        for node in self.children {
            if node.physicsBody?.categoryBitMask == PhysicsCategory.Shape {
                pausedShapeVelocities[node] = node.physicsBody?.velocity
                node.physicsBody?.velocity = CGVectorMake(0, 0)
            }
        }
    }
    
    func closePause() {
        bgImage.runAction(SKAction.fadeAlphaTo(1.0, duration: 0.5));
        arePaused = false
        // manipulate touch end
        self.removeChildrenInArray([muteLabel, restartLabel, homeLabel, themeSettingsLabel, unPausedLabel, pauseBackground])
        muteLabel = SKLabelNode()
        muteLabel.fontName = "Open Sans Cond Light"
        restartLabel = SKLabelNode()
        restartLabel.fontName = "Open Sans Cond Light"
        homeLabel = SKLabelNode()
        homeLabel.fontName = "Open Sans Cond Light"
        themeSettingsLabel = SKLabelNode()
        themeSettingsLabel.fontName = "Open Sans Cond Light"
        unPausedLabel = SKLabelNode()
        unPausedLabel.fontName = "Open Sans Cond Light"
        for node in pausedShapeVelocities.keys {
            node.physicsBody?.velocity = pausedShapeVelocities[node]!
        }
        pausedShapeVelocities.removeAll()
        self.addChild(pauseButton)
    }
    
    func pressedMute() {
        if muteLabel.text == "Unmute" {
            muteLabel.text = "Mute"
            unMuteThis()
            
        } else {
            muteLabel.text = "Unmute"
            muteThis()
        }
    }
    
    func muteThis() {
        if audioPlayer.playing {
            audioPlayer.volume = 0.01
        }
        if aud2exists {
            if audioPlayer2.playing {
                
            }
        }
    }
    
    func unMuteThis() {
        if audioPlayer.volume == 0.01 {
            audioPlayer.volume = 1
        }
        if aud2exists {
            if audioPlayer2.volume == 0.01 {
                audioPlayer2.volume = 1
            }
        }
    }
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    func linePath(end: CGPoint) -> CGPath {
        let path = UIBezierPath()
        for i in 0...1 {
            if i == 0 {
                path.moveToPoint(start)
            } else {
                path.addLineToPoint(end)
            }
        }
        path.closePath()
        return path.CGPath
    }
    func createLine(end: CGPoint){
        line.lineWidth=1.5
        line.path = linePath(end)
        line.strokeColor = UIColor.whiteColor()
        line.zPosition=4
    }
}

extension Array {
    func rotate(shift:Int) -> Array {
        var array = Array()
        if (self.count > 0) {
            array = self
            for i in 1...abs(shift) {
                array.insert(array.removeAtIndex(array.count-1),atIndex:0)
            }
        }
        return array
    }
}