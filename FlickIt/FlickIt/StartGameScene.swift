
//
//  startGame.swift
//  FlickIt
//
//  Created by Apple on 2/20/16.
//  Copyright © 2016 Abhi_Shaili_Jeffrey_Rohan_Ashwin. All rights reserved.
//
import AVFoundation
import SpriteKit
import GameKit
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
    var playingGame = false
    let restart_star = SKShapeNode()
    
    var justSpawnedDouble = false
    
    var bgImage = SKSpriteNode(imageNamed: "background.png")

    var bin_1_pos = 1
    
    //var bin_1 = SKSpriteNode(imageNamed: "blue_bin_t.png"); // all bins are facing bottom right corner
    //var bin_2 = SKSpriteNode(imageNamed: "red_bin_t.png");
    //var bin_3 = SKSpriteNode(imageNamed: "green_bin_t.png");
    //var bin_4 = SKSpriteNode(imageNamed: "purple_bin_t.png");
    var bin_1 = SKShapeNode()
    var bin_2 = SKShapeNode()
    var bin_3 = SKShapeNode()
    var bin_4 = SKShapeNode()
    
    var bin_1_shape = SKSpriteNode(imageNamed: "pentagonOutline") //change this to differently oriented triangles
    var bin_2_shape = SKSpriteNode(imageNamed: "squareOutline")
    var bin_3_shape = SKSpriteNode(imageNamed: "circleOutline")
    var bin_4_shape = SKSpriteNode(imageNamed: "triangleOutline")
    
    var bin_3_shape_width = CGFloat(1024)
    var bin_1_width = CGFloat(85)
    var bin_2_width = CGFloat(85)
    var bin_3_width = CGFloat(85)
    var bin_4_width = CGFloat(85)
    
    var binShapeScaleFactor = CGFloat(0)

    var pauseButton = SKSpriteNode(imageNamed: "pauseButton")
    var score = 0;
    var lives = 3;
    
    var pauseRestart = false
    
    let shapes = ["pentagon", "square","circle","triangle", "gameOverStar", "bomb", "heart"]
    var bin_shape_image_names = ["pentagonOutline", "squareOutline", "circleOutline","triangleOutline"]
    let bins = ["bin_1", "bin_2", "bin_3", "bin_4"]
    
    var start=CGPoint();
    var startTimeOfTouch=NSTimeInterval()
    let kMinDistance=CGFloat(20)
    let kMinDuration=CGFloat(0)
    let kMaxSpeed=CGFloat(200)
    var scoreLabel=SKLabelNode()
    var livesLabel = SKLabelNode()
    var time : CFTimeInterval = 2
    var shapeToAdd = SKNode()
    var touched:Bool = false
    var shapeController = SpawnShape()
    var gameSceneController = GameScene()
    var restartBTN = SKSpriteNode()
    var gameOver = false; // SET THESE
    var oldVelocities = [SKNode: CGVector]()
    var binWidth = CGFloat(0)
    var shapeScaleFactor = CGFloat(0)
    var audioPlayer = AVAudioPlayer()
    var audioPlayer2 = AVAudioPlayer()
    var arePaused = false
    var pausedShapeVelocities = [SKNode: CGVector]()
    var aud2exists: Bool = false
    let sizeRect = UIScreen.mainScreen().applicationFrame;
    var line = SKShapeNode()
    var touchedNode=SKNode()
    
    var doubleShapeProbability = 300
    
    var timeBegan = NSDate()
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    // Actual dimensions of the screen
    var sceneHeight = CGFloat(0)
    var sceneWidth = CGFloat(0)
    
    override init() {
        super.init()
    }
    override init(size: CGSize) {
        super.init(size: size)
        lives = NUMBEROFLIFES
        sceneHeight = sizeRect.size.height * UIScreen.mainScreen().scale;
        sceneWidth = sizeRect.size.width * UIScreen.mainScreen().scale;
        let radius = self.size.height/6
        shapeScaleFactor = 0.14 * self.size.width/bin_3_shape_width
        binShapeScaleFactor = 0.29 * self.size.width/radius
        
        playMusic("bensound-cute", type: "mp3")
        
        addCurvedLines(bin_1, dub1: 0, dub2: M_PI/2, bol: true, arch: Double(self.size.height/2 + radius), radi: radius, color: red)
        //curve down shape
        addCurvedLines(bin_2, dub1: M_PI/2, dub2: M_PI, bol: true, arch: Double(self.size.height/2 - radius), radi: radius, color: green)
        addCurvedLines(bin_3, dub1: M_PI, dub2: M_PI*3/2, bol: true, arch: Double(self.size.height/2 - radius), radi: radius, color: blue)
        addCurvedLines(bin_4, dub1: M_PI*3/2, dub2: M_PI*2, bol: true, arch: Double(self.size.height/2 - radius), radi: radius, color: purple)
        
        func setUpBinsPhysicsBody(bin: SKShapeNode) {
            bin.physicsBody?.dynamic=false
            bin.physicsBody?.affectedByGravity = false
            bin.physicsBody?.categoryBitMask=PhysicsCategory.Bin
            bin.physicsBody?.collisionBitMask=PhysicsCategory.Shape
            bin.physicsBody?.contactTestBitMask=PhysicsCategory.Shape
        }
        
        bin_1.position = CGPointMake(self.size.width, self.size.height)
        bin_1.zPosition = 3
        bin_1.physicsBody = SKPhysicsBody(circleOfRadius: bin_1.frame.size.width)
        setUpBinsPhysicsBody(bin_1)
        bin_1.name = shapes[0] //set bin names to name of shapes they take

        bin_2.position = CGPointMake(0, self.size.height)
        bin_2.zPosition = 3
        bin_2.physicsBody = SKPhysicsBody(circleOfRadius: bin_2.frame.size.width)
        setUpBinsPhysicsBody(bin_2)

        bin_2.name = shapes[1] //set bin names to name of shapes they take
        
        bin_3.position = CGPointMake(0, 0)
        bin_3.zPosition = 3
        bin_3.physicsBody = SKPhysicsBody(circleOfRadius: bin_3.frame.size.width)
        setUpBinsPhysicsBody(bin_3)
        
        bin_3.name = shapes[2] //set bin names to name of shapes they take
        
        bin_4.position = CGPointMake(self.size.width, 0)
        bin_4.zPosition = 3
        bin_4.physicsBody = SKPhysicsBody(circleOfRadius: bin_4.frame.size.width)
        setUpBinsPhysicsBody(bin_4)
        
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
        checkMute()
        audioPlayer.play()
    }
    
    func checkMute() {
        if (appDelegate.muted == true) {
            self.audioPlayer.volume = 0
        }
        else {
            self.audioPlayer.volume = 1
        }
    }
    
    func checkMute2() {
        if (appDelegate.muted == true) {
            self.audioPlayer2.volume = 0
        }
        else {
            self.audioPlayer2.volume = 1
        }
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
        checkMute2()
        audioPlayer2.play()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createScene() {
        playingGame = true
        timeBegan = NSDate()
        self.physicsWorld.contactDelegate = self
        bgImage.size = CGSize(width: self.size.width, height: self.size.height);
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        bgImage.zPosition = 1
        self.addChild(bgImage);
        let radius = self.size.height/6
        //adds bins on all 4 corners of screen with name, zposition and size
        //bin_1.size = CGSize(width: 100, height: 100)
        // top right
        
        bin_1_shape.anchorPoint = CGPoint(x: 1, y: 1)
        bin_1_shape.setScale(binShapeScaleFactor)
        bin_1_shape.position = CGPointMake(self.size.width - radius / 16, self.size.height - radius/16)
        bin_1_shape.zPosition = 4;
        bin_1_shape.texture = SKTexture(imageNamed: "pentagonOutline")
        
        bin_2_shape.anchorPoint = CGPoint(x: 0, y: 1)
        bin_2_shape.setScale(binShapeScaleFactor)
        bin_2_shape.position = CGPointMake(radius / 16, self.size.height - radius / 16)
        bin_2_shape.zPosition = 4;
        bin_2_shape.texture = SKTexture(imageNamed: "squareOutline")

        bin_3_shape.anchorPoint = CGPoint(x: 0, y: 0)
        bin_3_shape.setScale(binShapeScaleFactor)
        bin_3_shape.position = CGPointMake(radius / 16, radius / 16)
        bin_3_shape.zPosition = 4;
        bin_3_shape.texture = SKTexture(imageNamed: "circleOutline")

        bin_4_shape.anchorPoint = CGPoint(x: 1, y: 0)
        bin_4_shape.setScale(binShapeScaleFactor)
        bin_4_shape.position = CGPointMake(self.size.width - radius / 16, radius / 16)
        bin_4_shape.zPosition = 4;
        bin_4_shape.texture = SKTexture(imageNamed: "triangleOutline")

        self.addChild(bin_1_shape)
        self.addChild(bin_2_shape)
        self.addChild(bin_3_shape)
        self.addChild(bin_4_shape)
        
        scoreLabel=SKLabelNode()
        scoreLabel.text="Score: "+String(score)
        scoreLabel.fontColor=UIColor.yellowColor()
        scoreLabel.position=CGPointMake(self.frame.width/2,self.frame.height * 7.5/9)
        scoreLabel.zPosition=2
        scoreLabel.fontName = "BigNoodleTitling"
        self.addChild(scoreLabel)
        
        livesLabel = SKLabelNode()
        livesLabel.text = "Lives: " + String(lives)
        livesLabel.fontColor = UIColor.redColor()
        livesLabel.position = CGPointMake(self.frame.width/2, self.frame.height * 0.5/9)
        livesLabel.zPosition = 2
        livesLabel.fontName = "BigNoodleTitling"
        self.addChild(livesLabel)
        
        gameOver = false
        if (pauseRestart) {
            pauseRestart = false
        } else {
            delay(0.25) {
                self.animateBinsRestart()
            }
        }

        pauseButton.zPosition = 5
        pauseButton.setScale(0.075)
        pauseButton.name = "pauseButton"
        pauseButton.position = CGPointMake(self.size.width / 2, 15*self.size.height/16)
        self.addChild(pauseButton)
        
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
    var isRotating = false
    
    func setRotatingTrue() {
        isRotating = true
    }
    func setRotatingFalse() {
        isRotating = false
    }
    
    // will randomly rotate the bins
    func rotateBins(randInt: Int) {
        let animationDuration: Double = 0.5 // THIS NEEDS TO BE UPDATED to be accurate
        let freezeSequence = SKAction.sequence([SKAction.runBlock(setRotatingTrue), SKAction.runBlock(freezeShapes), SKAction.waitForDuration(animationDuration), SKAction.runBlock(unfreezeShapes), SKAction.runBlock(setRotatingFalse)])
        runAction(freezeSequence)
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

        delay(0.5) {
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
                if(firstBody.node!.name=="bomb" || firstBody.node?.name=="heart"){
                    firstBody.node?.removeFromParent()
                }
                else{
                    let explosionEmitterNode = SKEmitterNode(fileNamed:"ExplosionEffect.sks")
                    explosionEmitterNode!.position = contact.contactPoint
                    explosionEmitterNode?.zPosition=100
                    if (firstBody.node?.name == secondBody.node?.name) {
                        score += 1
                        if(score % 10 == 0){ // rotate bins every 10 points
                            self.rotateBins(Int(arc4random_uniform(2) + 1));
                        }
                    } else {
                        explosionEmitterNode?.particleColorSequence=SKKeyframeSequence(keyframeValues: [UIColor.redColor()], times: [0])
                        lives -= 1
                    }
                    self.addChild(explosionEmitterNode!)
                    scoreLabel.text="Score: "+String(score)
                    livesLabel.text = "Lives: " + String(lives)
                    firstBody.node?.removeFromParent();
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
                    pressedHighScore()
//                    showLeaderboard()
                } else if (binName == "settings") {
                    pressedSettings()
                }
            }
        }
    }
    func pressedHighScore() {
        self.restart_star.removeFromParent()
        self.restart_star.physicsBody?.velocity = CGVectorMake(0, 0)
        self.restart_star.position = CGPointMake(self.size.width/2, self.size.height/2 - self.gameOverLabel.frame.height*2);
        let alert = UIAlertController(title: "Global High Scores", message: "Coming soon!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        let vc = self.view!.window?.rootViewController
        vc!.presentViewController(alert, animated: true, completion: nil)
         self.addChild(restart_star)
    }
    func pressedSettings() {
        self.restart_star.removeFromParent()
        self.restart_star.physicsBody?.velocity = CGVectorMake(0, 0)
        self.restart_star.position = CGPointMake(self.size.width/2, self.size.height/2 - self.gameOverLabel.frame.height*2);
        let alert = UIAlertController(title: "Settings", message: "Coming soon!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        let vc = self.view!.window?.rootViewController
        vc!.presentViewController(alert, animated: true, completion: nil)
        self.addChild(restart_star)
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
    
    var timeRequired = 1.6
    var firstTimeCount = 1
    var timeSpeedUpFactor = 0.15
    var minTimeRequired = 0.99
    var multiplicativeSpeedUpFactor = 1.0
    
    var jeffHandCounter = 0
    
    override func update(currentTime: CFTimeInterval) {
        
        let didRemoveGameover = removeOffScreenNodes()
        if isRotating || arePaused {
            time = currentTime
        } else if gameOver {
            if didRemoveGameover {
                restart_star.removeFromParent()
                createStar()
                setupStarPhysics()
                self.addChild(restart_star)
            }
            if currentTime - time >= 5 {
                if jeffHandCounter > 0 {
                    moveHand()
                } else {
                    jeffHandCounter += 1
                }
                time = currentTime
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
                    if (!justSpawnedDouble && score > 25) {
                        doubleShapeProbability = max(doubleShapeProbability - 4, 200)
                        
                        if(Int(arc4random_uniform(UInt32(doubleShapeProbability))) <= 100){
                            //change above value for difficulty purposes!!!!!!!!
                            delay(0.2) { // spawning at exactly the same time was too hard
                                self.shapeToAdd = self.shapeController.spawnShape();
                                self.shapeToAdd.position = CGPointMake(self.size.width/2, self.size.height/2);
                                self.addChild(self.shapeToAdd);
                            }
                            justSpawnedDouble = true;
                        }
                    } else {
                        justSpawnedDouble = false;
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
            if lives <= 0 {
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
                if sprite.physicsBody != nil && sprite.physicsBody?.categoryBitMask != PhysicsCategory.Bin {
                    // CHECKS TO SEE IF ANY SHAPE IS ABOVE PAUSE
                    if self.pauseButton.containsPoint(CGPointMake(sprite.position.x, sprite.position.y)){
                        pauseBlocksShapeCounter += 1
                    }
                    if (sprite.position.y < 0 || sprite.position.x < 0 || sprite.position.x > self.size.width || sprite.position.y > self.size.height) {
                        node.removeFromParent();
                        if !self.gameOver {
                            if(node.name == "bomb" || node.name == "heart"){
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
                } else {
                    
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.locationInNode(self)
        
        // Save start location and time
        start = location
        startTimeOfTouch = touch.timestamp
        if arePaused {
            let currNode = self.nodeAtPoint(start)
            if currNode.name == "pauseButton" {
                closePause()
            } else if muteLabel.containsPoint(location) {
                pressedMute()
            } else if (restartLabel.containsPoint(location)) {
                closePause()
                pauseRestart = true
                restartScene()
            } else if (homeLabel.containsPoint(location)) {
                goToHome()
                closePause()
            } else if (themeSettingsLabel.containsPoint(location)) {
                print("go to settings")
                closePause()
            }
        } else if !isRotating {
            touchedNode=self.nodeAtPoint(start)
            print(touchedNode)
            if(touchedNode.name == nil){
                var i=CGFloat(0)
                var j=CGFloat(0)
                while(touchedNode.name == nil && i < 5){
                    touchedNode=self.nodeAtPoint(CGPoint(x: start.x+i,y: start.y))
                    j=0
                    while(touchedNode.name == nil && j < 5){
                        touchedNode=self.nodeAtPoint(CGPoint(x: start.x,y: start.y+j))
                        j+=1
                    }
                    i+=1
                }
            }

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
                let currBrightness = UIScreen.mainScreen().brightness
                UIScreen.mainScreen().brightness = CGFloat(1)
                let explosionEmitterNode = SKEmitterNode(fileNamed: "ExplosionEffect.sks")
                explosionEmitterNode?.position=touchedNode.position
                explosionEmitterNode?.zPosition=100
                explosionEmitterNode?.particleColorSequence=SKKeyframeSequence(keyframeValues: [UIColor.redColor(), UIColor.yellowColor()], times: [0,1])
                explosionEmitterNode?.particleLifetime=2.0
                explosionEmitterNode?.numParticlesToEmit=50
                explosionEmitterNode?.particleSpeed=200
                delay(0.5){
                    UIScreen.mainScreen().brightness = currBrightness
                }
                
                self.addChild(explosionEmitterNode!)
                
                touchedNode.removeFromParent()
                let tracker = GAI.sharedInstance().defaultTracker
                let event = GAIDictionaryBuilder.createEventWithCategory("Action", action: "Bombed", label: nil, value: nil)
                tracker.send(event.build() as [NSObject : AnyObject])
            } else if(touchedNode.name == "heart"){
                lives += 1;
                livesLabel.text="Lives:" + String(lives)
                let explosionEmitterNode = SKEmitterNode(fileNamed: "ExplosionEffect.sks")
                explosionEmitterNode?.position=touchedNode.position
                explosionEmitterNode?.zPosition=100
                explosionEmitterNode?.particleColorSequence=SKKeyframeSequence(keyframeValues: [UIColor.yellowColor()], times: [0])
                self.addChild(explosionEmitterNode!)
                touchedNode.removeFromParent()
                let tracker = GAI.sharedInstance().defaultTracker
                let event = GAIDictionaryBuilder.createEventWithCategory("Action", action: "Hearted", label: nil, value: nil)
                tracker.send(event.build() as [NSObject : AnyObject])
            } else if (touchedNode.name == "pauseButton") {
                openPause()
            }
            start=touchedNode.position;
            oldVelocities[touchedNode]=touchedNode.physicsBody?.velocity;
            touchedNode.physicsBody?.velocity=CGVectorMake(0, 0)
        }
        if gameOver {
            if bin_1_shape.containsPoint(location) {
                pressedHighScore()
            } else if bin_2_shape.containsPoint(location) {
                restartScene()
            } else if bin_3_shape.containsPoint(location) {
                self.removeAllChildren()
                self.goToHome()
            } else if bin_4_shape.containsPoint(location) {
                pressedSettings()
            }
        }
        delay(0.5) {
            if (self.gameOver && self.showHand > 2) {
                self.showHand = 0
                self.moveHand()
            }
        }
        showHand += 1;
    }
    
    func moveHand() {
        self.hand.removeFromParent()
        self.hand.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.hand.xScale = self.size.width / 5770
        self.hand.yScale = self.size.width / 5770
        self.hand.zPosition = 3
        self.addChild(self.hand)
        let move = SKAction.moveTo(CGPoint(x: self.size.width * 1 / 8, y: self.size.height * 7 / 8), duration: 1.5)
        let remove = SKAction.removeFromParent()
        //self.hand.removeFromParent()
        self.hand.runAction(SKAction.sequence([move, remove]))
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if ((!arePaused) && self.nodeAtPoint(start).name != nil && touching && self.nodeAtPoint(start).physicsBody?.categoryBitMask != PhysicsCategory.Bin) {
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
    
    func putBackPhysicsBodyBin() {
        self.bin_1.physicsBody?.categoryBitMask = PhysicsCategory.Bin
        self.bin_1.physicsBody?.collisionBitMask = PhysicsCategory.Shape
        self.bin_2.physicsBody?.categoryBitMask = PhysicsCategory.Bin
        self.bin_2.physicsBody?.collisionBitMask = PhysicsCategory.Shape
        self.bin_3.physicsBody?.categoryBitMask = PhysicsCategory.Bin
        self.bin_3.physicsBody?.collisionBitMask = PhysicsCategory.Shape
        self.bin_4.physicsBody?.categoryBitMask = PhysicsCategory.Bin
        self.bin_4.physicsBody?.collisionBitMask = PhysicsCategory.Shape
    }
    
    func returnBinsToOriginal() {
        if (bin_1_pos == 2) {
            rotateBins(3)
        } else if (bin_1_pos == 3) {
            rotateBins(2)
        } else if (bin_1_pos == 4) {
            rotateBins(1)
        }
    }
    
    func createRestartBTN() {
        scoreLabel.text = ""
        livesLabel.text = ""
        gameOver = true
        playMusic("bensound-sadday", type: "mp3") // change to some lose song
        // change bin displays
        
        returnBinsToOriginal()
        
        bin_1_shape.texture = SKTexture(imageNamed:"highScore")
        bin_2_shape.texture = SKTexture(imageNamed:"refreshArrow")
        bin_3_shape.texture = SKTexture(imageNamed:"house")
        bin_4_shape.texture = SKTexture(imageNamed:"settings")
        
        bin_1.name = "highScore"
        bin_2.name = "restart"
        bin_3.name = "home"
        bin_4.name = "settings"
        // Add gameover label and star node
        setupGameOverLabels()
        
        createStar()
        setupStarPhysics()
        
        self.addChild(restart_star)
        
        //setUpGameOverStar()
        self.removeChildrenInArray([pauseButton])
        // add collision actions
        saveScore(score);
        setUpLocalHighScore()
        gameOverTrack()
        putBackPhysicsBodyBin()
        playingGame = false
    }
    
    
    func setUpLocalHighScore() {
        var prevHighScore: Int = NSUserDefaults.standardUserDefaults().integerForKey("score")
        if prevHighScore < score {
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "score")
            NSUserDefaults.standardUserDefaults().synchronize()
            prevHighScore = score
        }
        gameOverHighScoreLabel.position = CGPointMake(self.size.width/2, self.size.height/3.9);
        gameOverHighScoreLabel.horizontalAlignmentMode = .Center
        gameOverHighScoreLabel.fontColor = UIColor.whiteColor()
        gameOverHighScoreLabel.fontName = "BigNoodleTitling"
        gameOverHighScoreLabel.fontSize = 20
        gameOverHighScoreLabel.zPosition = 5
        gameOverHighScoreLabel.text = "Your High Score: " + String(prevHighScore)
        self.addChild(gameOverHighScoreLabel)
        
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
    
    func createStar() {
        let rect: CGRect = CGRectMake(0, 0, self.size.width/6, self.size.width/6)
        restart_star.path = self.starPath(0, y: 0, radius: rect.size.width/3, sides: 5, pointyness: 2)
        restart_star.strokeColor = yellow
        restart_star.fillColor = yellow
        restart_star.zPosition = 7
        restart_star.position = CGPointMake(self.size.width/2, self.size.height/2 - self.gameOverLabel.frame.height*2);
        // Set names for the launcher so that we can check what node is touched in the touchesEnded method
        restart_star.name = "gameOverStar";
        //could randomize rotation here
        let rotation = SKAction.rotateByAngle(CGFloat(2 * M_PI), duration: 10)
        restart_star.runAction(SKAction.repeatActionForever(rotation))
    }
    
    func degree2radian(a:CGFloat)->CGFloat {
        let b = CGFloat(M_PI) * a/180
        return b
    }
    
    func polygonPointArray(sides:Int,x:CGFloat,y:CGFloat,radius:CGFloat,adjustment:CGFloat=0)->[CGPoint] {
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
    
    func starPath(x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, pointyness:CGFloat) -> CGPathRef {
        let adjustment = 360/sides/2
        let path = CGPathCreateMutable()
        let points = polygonPointArray(sides,x: x,y: y,radius: radius)
        let cpg = points[0]
        let points2 = polygonPointArray(sides,x: x,y: y,radius: radius*pointyness,adjustment:CGFloat(adjustment))
        var i = 0
        CGPathMoveToPoint(path, nil, cpg.x, cpg.y)
        for p in points {
            CGPathAddLineToPoint(path, nil, points2[i].x, points2[i].y)
            CGPathAddLineToPoint(path, nil, p.x, p.y)
            i += 1
        }
        CGPathCloseSubpath(path)
        return path
    }
    
    func setupStarPhysics() {
        restart_star.userInteractionEnabled = false
        restart_star.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: restart_star.frame.width, height: restart_star.frame.height))
        restart_star.physicsBody?.dynamic = true
        restart_star.physicsBody?.affectedByGravity=false
        restart_star.physicsBody?.categoryBitMask = PhysicsCategory.Shape
        restart_star.physicsBody?.collisionBitMask=PhysicsCategory.Bin
        restart_star.physicsBody?.contactTestBitMask=PhysicsCategory.Bin
        
    }
    
    let gameOverHighScoreLabel = SKLabelNode(text: "")
    let gameOverLabel = SKLabelNode(text: "GAMEOVER")
    
    
    let gameOverScoreLabel = SKLabelNode(text: "")

    func setupGameOverLabels() {
        gameOverScoreLabel.position = CGPointMake(self.size.width/2, self.size.height/2);
        gameOverScoreLabel.horizontalAlignmentMode = .Center
        gameOverScoreLabel.fontColor = UIColor.whiteColor()
        gameOverScoreLabel.fontName = "BigNoodleTitling"
        gameOverScoreLabel.fontSize = 25
        gameOverScoreLabel.zPosition = 5
        gameOverScoreLabel.text = "Score " + String(score)
        self.addChild(gameOverScoreLabel)
        
        gameOverLabel.position = CGPointMake(self.size.width/2, self.size.height/2 + gameOverScoreLabel.frame.height + 5);
        gameOverLabel.horizontalAlignmentMode = .Center
        gameOverLabel.fontColor = UIColor.yellowColor()
        gameOverLabel.fontName = "BigNoodleTitling"
        gameOverLabel.fontSize = 30
        gameOverLabel.zPosition = 5
        self.addChild(gameOverLabel)
    }

    
    func restartScene() {
        // makes bins smaller
        restartBTN = SKSpriteNode() // stopped being able to click when not there
        
        self.removeAllActions()
        self.removeAllChildren()
        
        self.addChild(bin_1)
        bin_1.name = shapes[0]
        
        self.addChild(bin_2)
        bin_2.name = shapes[1]
        
        self.addChild(bin_3)
        bin_3.name = shapes[2]
        
        self.addChild(bin_4)
        bin_4.name = shapes[3]
        
        returnBinsToOriginal()
        
        arePaused = false
        showHand = 0;
        gameOver = false;
        score = 0
        firstTimeCount = 1
        lives = NUMBEROFLIFES
        timeRequired = 2.0
        jeffHandCounter = 0
        multiplicativeSpeedUpFactor = 1.0
        self.shapeController.resetVelocityBounds()
        createScene()
        
        self.shapeController.resetSpecialShapeProbability()
        setRotatingFalse()
        self.shapeController.shapeCounter = [0,0,0,0,0,0]
        playMusic("bensound-cute", type: "mp3")
    }
    
    var muteLabel = SKLabelNode()
    var restartLabel = SKLabelNode()
    var homeLabel = SKLabelNode()
    var themeSettingsLabel = SKLabelNode()
    var pauseBackground = SKShapeNode()
    
    func openPause() {
        playingGame = false
        pauseButton.texture = SKTexture(imageNamed: "playButton")
        bgImage.runAction(SKAction.fadeAlphaTo(0.2, duration: 0.5));
        arePaused = true
        if appDelegate.muted == true {
            muteLabel.text = "Unmute"
        }
        else {
            muteLabel.text = "Mute"
        }
        muteLabel.fontColor=UIColor.whiteColor()
        muteLabel.position=CGPointMake(self.frame.width/2, 8*self.frame.height/12)
        muteLabel.fontName = "BigNoodleTitling"
        muteLabel.zPosition = 7
        self.addChild(muteLabel)
        restartLabel.text = "Restart"
        restartLabel.fontColor=UIColor.whiteColor()
        restartLabel.position=CGPointMake(self.frame.width/2, 4*self.frame.height/12)
        restartLabel.fontName = "BigNoodleTitling"
        restartLabel.zPosition = 7
        self.addChild(restartLabel)
        homeLabel.text = "Home"
        homeLabel.fontColor=UIColor.whiteColor()
        homeLabel.position=CGPointMake(self.frame.width/2, 6*self.frame.height/12)
        homeLabel.fontName = "BigNoodleTitling"
        homeLabel.zPosition = 7
        self.addChild(homeLabel)
//        addThemeSettingLabel()
        pauseBackground = SKShapeNode(rectOfSize: CGSize(width: 11 * self.size.width/16, height: 8 * self.size.height/16))
        pauseBackground.fillColor = UIColor(red: 82/255, green: 167/255, blue: 178/255, alpha: 0.5)
        pauseBackground.position = CGPointMake(self.size.width/2, self.size.height/2);
        pauseBackground.zPosition = 6
        self.addChild(pauseBackground)
        freezeShapes()
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Pause Screen")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        let event = GAIDictionaryBuilder.createEventWithCategory("Action", action: "Pause", label: nil, value: nil)
        tracker.send(event.build() as [NSObject : AnyObject])
    }
    
    func addThemeSettingLabel() {
        themeSettingsLabel.text = "Pick a theme"
        themeSettingsLabel.fontColor=UIColor.whiteColor()
        themeSettingsLabel.position=CGPointMake(self.frame.width/2,self.frame.height/5)
        themeSettingsLabel.zPosition=5
        themeSettingsLabel.fontName = "BigNoodleTitling"
        self.addChild(themeSettingsLabel)
    }
    
    func freezeShapes() {
        for node in self.children {
            if node.physicsBody?.categoryBitMask == PhysicsCategory.Shape {
                pausedShapeVelocities[node] = node.physicsBody?.velocity
                node.physicsBody?.velocity = CGVectorMake(0, 0)
            }
        }
    }
    
    func unfreezeShapes() {
        for node in pausedShapeVelocities.keys {
            node.physicsBody?.velocity = pausedShapeVelocities[node]!
        }
        pausedShapeVelocities.removeAll()
    }
    
    func closePause() {
        pauseButton.texture = SKTexture(imageNamed: "pauseButton")
        bgImage.runAction(SKAction.fadeAlphaTo(1.0, duration: 0.5));
        arePaused = false
        // manipulate touch end
        self.removeChildrenInArray([muteLabel, restartLabel, homeLabel, themeSettingsLabel, pauseBackground])
        muteLabel = SKLabelNode()
        muteLabel.fontName = "BigNoodleTitling"
        restartLabel = SKLabelNode()
        restartLabel.fontName = "BigNoodleTitling"
        homeLabel = SKLabelNode()
        homeLabel.fontName = "BigNoodleTitling"
        themeSettingsLabel = SKLabelNode()
        themeSettingsLabel.fontName = "BigNoodleTitling"
        unfreezeShapes()
        playingGame = true
    }
    
    func pressedMute() {
        if appDelegate.muted == true {
            muteLabel.text = "Mute"
            unMuteThis()
            
        } else {
            muteLabel.text = "Unmute"
            muteThis()
        }
    }
    
    func muteThis() {
        appDelegate.muted = true
        if audioPlayer.playing {
            audioPlayer.volume = 0
        }
        if aud2exists {
            if audioPlayer2.playing {
                audioPlayer2.volume = 0
            }
        }
    }
    
    func unMuteThis() {
        appDelegate.muted = false
        if audioPlayer.volume == 0 {
            audioPlayer.volume = 1
        }
        if aud2exists {
            if audioPlayer2.volume == 0 {
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
        path.moveToPoint(end)
        path.addLineToPoint(CGPointMake(end.x - 5, end.y))
        path.addLineToPoint(CGPointMake(end.x, end.y + 7))
        path.addLineToPoint(CGPointMake(end.x + 5, end.y))
        path.closePath()
        return path.CGPath
    }
    
    func createLine(end: CGPoint){
        line.lineWidth=1.5
        line.path = linePath(end)
        line.fillColor = UIColor.whiteColor()
        line.strokeColor = UIColor.whiteColor()
        line.zPosition=4
    }
    
    func saveScore(score: Int) {
        if GKLocalPlayer.localPlayer().authenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: "This")
            scoreReporter.value = Int64(score)
            let scoreArray : [GKScore] = [scoreReporter]
            GKScore.reportScores(scoreArray, withCompletionHandler: nil)
        }
    }
    
//    func showLeaderboard() {
//        let viewController = self.view!.window?.rootViewController
//        let gameCenterVC = GKGameCenterViewController()
//        gameCenterVC.gameCenterDelegate = self
//        viewController!.presentViewController(gameCenterVC, animated: true, completion: nil)
//    }
    
//    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
//        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
//    
//    }
    
    
}

extension Array {
    func rotate(shift:Int) -> Array {
        var array = Array()
        if (self.count > 0) {
            array = self
            for _ in 1...abs(shift) {
                array.insert(array.removeAtIndex(array.count-1),atIndex:0)
            }
        }
        return array
    }
}