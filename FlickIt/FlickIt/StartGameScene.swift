
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
import FBSDKShareKit

class StartGameScene: SKScene, SKPhysicsContactDelegate, GKGameCenterControllerDelegate {
    var NUMBEROFLIFES = 3
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let red: UIColor = UIColor(red: 164/255, green: 84/255, blue: 80/255, alpha: 1)
    let blue: UIColor = UIColor(red: 85/255, green: 135/255, blue: 141/255, alpha: 1)
    let green: UIColor = UIColor(red: 147/255, green: 158/255, blue: 106/255, alpha: 1)
    let purple: UIColor = UIColor(red: 99/255, green: 103/255, blue: 211/255, alpha: 1)
    let yellow: UIColor = UIColor(red: 250/255, green: 235/255, blue: 83/255, alpha: 1)
    
    var bomb = SKSpriteNode(imageNamed: "bomb.png")
    var hand = SKSpriteNode(imageNamed: "hand_icon")
    var showHand = 0;
    var touching = false
    var playingGame = false
    let restart_star = SKShapeNode()
    
    var justSpawnedDouble = false

    var bin_1_pos = 1
    var bin_1 = SKShapeNode()
    var bin_2 = SKShapeNode()
    var bin_3 = SKShapeNode()
    var bin_4 = SKShapeNode()
    
    var bin_1_shape = SKSpriteNode(imageNamed: "pentagonOutline-1") //change this to differently oriented triangles
    var bin_2_shape = SKSpriteNode(imageNamed: "squareOutline-1")
    var bin_3_shape = SKSpriteNode(imageNamed: "circleOutline-1")
    var bin_4_shape = SKSpriteNode(imageNamed: "triangleOutline-1")
    
    var bin_3_shape_width = CGFloat(2048)
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
    var bin_shape_image_names = ["pentagonOutline-1", "squareOutline-1", "circleOutline-1","triangleOutline-1"]
    let bins = ["bin_1", "bin_2", "bin_3", "bin_4"]
    
    var start=CGPoint();
    var startTimeOfTouch=TimeInterval()
    let kMinDistance=CGFloat(20)
    let kMinDuration=CGFloat(0)
    let kMaxSpeed=CGFloat(200)
    var scoreLabel=SKLabelNode()
    var livesLabel = SKLabelNode()
    var time : CFTimeInterval = 2
    var shapeToAdd = SKNode()
    var touched:Bool = false
    var shapeController: SpawnShape!
    var gameSceneController: GameScene!
    var restartBTN = SKSpriteNode()
    var gameOver = false; // SET THESE
    var oldVelocities = [SKNode: CGVector]()
    var binWidth = CGFloat(0)
    var shapeScaleFactor = CGFloat(0)
    var audioPlayer = AVAudioPlayer()
    var audioPlayer2 = AVAudioPlayer()
    var audioPlayer3 = AVAudioPlayer()
    var arePaused = false
    var pausedShapeVelocities = [SKNode: CGVector]()
    var aud2exists: Bool = false
    var aud3exists: Bool = false
    let sizeRect = UIScreen.main.applicationFrame;
    var line = SKShapeNode()
    var touchedNode=SKNode()
    let fbshare = FBSDKShareButton()
    var fbsend = FBSDKSendButton()
    let content = FBSDKShareLinkContent()
    var gradient_colors = [CGColor]()

    var backgroundNode = SKSpriteNode()
    var doubleShapeProbability = 600
    
    var timeBegan = Date()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Actual dimensions of the screen
    var sceneHeight = CGFloat(0)
    var sceneWidth = CGFloat(0)
    
    override init() {
        super.init()
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        shapeController = SpawnShape()
        gameSceneController = GameScene()
        lives = NUMBEROFLIFES
        sceneHeight = sizeRect.size.height * UIScreen.main.scale;
        sceneWidth = sizeRect.size.width * UIScreen.main.scale;
        let radius = self.size.height/6
        shapeScaleFactor = 0.14 * self.size.width/bin_3_shape_width
        binShapeScaleFactor = 0.24 * self.size.width/radius
        
        playMusic("bensound-cute", type: "mp3")
        
        addCurvedLines(bin_1, dub1: 0, dub2: M_PI/2, bol: true, arch: Double(self.size.height/2 + radius), radi: radius, color: red)
        //curve down shape
        addCurvedLines(bin_2, dub1: M_PI/2, dub2: M_PI, bol: true, arch: Double(self.size.height/2 - radius), radi: radius, color: green)
        addCurvedLines(bin_3, dub1: M_PI, dub2: M_PI*3/2, bol: true, arch: Double(self.size.height/2 - radius), radi: radius, color: blue)
        addCurvedLines(bin_4, dub1: M_PI*3/2, dub2: M_PI*2, bol: true, arch: Double(self.size.height/2 - radius), radi: radius, color: purple)
        
        func setUpBinsPhysicsBody(_ bin: SKShapeNode) {
            bin.physicsBody?.isDynamic=false
            bin.physicsBody?.affectedByGravity = false
            bin.physicsBody?.categoryBitMask=PhysicsCategory.Bin
            bin.physicsBody?.collisionBitMask=PhysicsCategory.Shape
            bin.physicsBody?.contactTestBitMask=PhysicsCategory.Shape
        }
        func setupGradientColors(){
            let gradient_blue = UIColor(red: 171/255.0, green: 232/255.0, blue: 243/255.0, alpha: 1.0).cgColor
            let gradient_red = UIColor(red: 246/255.0, green: 204/255.0, blue: 208/255.0, alpha: 1.0).cgColor
            let gradient_yellow = UIColor(red: 244/255.0, green: 216/255.0, blue: 178/255.0, alpha: 1.0).cgColor
            gradient_colors.append(gradient_blue)
            gradient_colors.append(gradient_red)
            gradient_colors.append(gradient_yellow)
            
        }
        setupGradientColors()
        bin_1.position = CGPoint(x: self.size.width, y: self.size.height)
        bin_1.zPosition = 3
        bin_1.physicsBody = SKPhysicsBody(circleOfRadius: bin_1.frame.size.width)
        setUpBinsPhysicsBody(bin_1)
        bin_1.name = shapes[0] //set bin names to name of shapes they take

        bin_2.position = CGPoint(x: 0, y: self.size.height)
        bin_2.zPosition = 3
        bin_2.physicsBody = SKPhysicsBody(circleOfRadius: bin_2.frame.size.width)
        setUpBinsPhysicsBody(bin_2)

        bin_2.name = shapes[1] //set bin names to name of shapes they take
        
        bin_3.position = CGPoint(x: 0, y: 0)
        bin_3.zPosition = 3
        bin_3.physicsBody = SKPhysicsBody(circleOfRadius: bin_3.frame.size.width)
        setUpBinsPhysicsBody(bin_3)
        
        bin_3.name = shapes[2] //set bin names to name of shapes they take
        
        bin_4.position = CGPoint(x: self.size.width, y: 0)
        bin_4.zPosition = 3
        bin_4.physicsBody = SKPhysicsBody(circleOfRadius: bin_4.frame.size.width)
        setUpBinsPhysicsBody(bin_4)
        
        bin_4.name = shapes[3] //set bin names to name of shapes they take
        
        self.addChild(bin_1)
        self.addChild(bin_2)
        self.addChild(bin_3)
        self.addChild(bin_4)
        
        fbshare.frame = CGRect(x: UIScreen.main.bounds.width/2-UIScreen.main.bounds.width/4-15, y: UIScreen.main.bounds.height*4/5, width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.height/14)
        fbsend.frame = CGRect(x: UIScreen.main.bounds.width/2+15, y: UIScreen.main.bounds.height*4/5, width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.height/14)
        
        createScene()
    }
    
    func createBackground(color1: CGColor, color2: CGColor){
        let size = CGSize(width: screenWidth, height: screenHeight)
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        layer.colors = [color1, color2] // start color
        UIGraphicsBeginImageContext(size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let bg = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        UIGraphicsEndImageContext()
        let back = SKTexture.init(cgImage: bg!)
        backgroundNode = SKSpriteNode(texture: back, size: size)
        backgroundNode.zPosition = 0
        backgroundNode.position = CGPoint(x:screenWidth/2,y:screenHeight/2)
        self.addChild(backgroundNode)
    }
    func changeBackground(scorediv20: Int){
        //if score is 40, use the 40 / 20 = 2 and 3 elements of array
        let first = scorediv20 % gradient_colors.count
        var second = first+1
        //it cycles if we don't have enought colors.
        if(second >= gradient_colors.count){
            second = 0
        }
        backgroundNode.removeFromParent()
        createBackground(color1: gradient_colors[first] , color2: gradient_colors[second] )
    }
    func playMusic(_ path: String, type: String) {
        let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: path, ofType: type)!)
        //print(alertSound)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            try audioPlayer = AVAudioPlayer(contentsOf: alertSound)
        }
        catch {
            
        }
        audioPlayer.prepareToPlay()
        checkMute()
        audioPlayer.play()
        audioPlayer.numberOfLoops = -1
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
    
    func checkMute3() {
        if (appDelegate.muted == true) {
            self.audioPlayer3.volume = 0
        }
        else {
            self.audioPlayer3.volume = 1
        }
    }
    
    func playMusic2(_ path: String, type: String) {
        let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: path, ofType: type)!)
        //print(alertSound)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            try audioPlayer2 = AVAudioPlayer(contentsOf: alertSound)
        }
        catch {
            
        }
        audioPlayer2.prepareToPlay()
        checkMute2()
        audioPlayer2.play()
        audioPlayer2.numberOfLoops = -1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createScene() {
        doneCounter = [0,0,0]
        playingGame = true
        timeBegan = Date()
        self.physicsWorld.contactDelegate = self
        //bgImage.size = CGSize(width: self.size.width, height: self.size.height);
        //bgImage.position = CGPoint(x: self.size.width/2, y: self.size.height/2);
        //bgImage.zPosition = 1
        //self.addChild(bgImage);
        let radius = self.size.height/6
        //adds bins on all 4 corners of screen with name, zposition and size
        //bin_1.size = CGSize(width: 100, height: 100)
        // top right
        createBackground(color1: gradient_colors[0],color2: gradient_colors[1])
        bin_1_shape.anchorPoint = CGPoint(x: 1, y: 1)
        bin_1_shape.setScale(binShapeScaleFactor)
        bin_1_shape.position = CGPoint(x: self.size.width - radius / 16, y: self.size.height - radius/16)
        bin_1_shape.zPosition = 4;
        bin_1_shape.texture = SKTexture(imageNamed: "pentagonOutline-1")
        
        bin_2_shape.anchorPoint = CGPoint(x: 0, y: 1)
        bin_2_shape.setScale(binShapeScaleFactor)
        bin_2_shape.position = CGPoint(x: radius / 16, y: self.size.height - radius / 16)
        bin_2_shape.zPosition = 4;
        bin_2_shape.texture = SKTexture(imageNamed: "squareOutline-1")

        bin_3_shape.anchorPoint = CGPoint(x: 0, y: 0)
        bin_3_shape.setScale(binShapeScaleFactor)
        bin_3_shape.position = CGPoint(x: radius / 16, y: radius / 16)
        bin_3_shape.zPosition = 4;
        bin_3_shape.texture = SKTexture(imageNamed: "circleOutline-1")

        bin_4_shape.anchorPoint = CGPoint(x: 1, y: 0)
        bin_4_shape.setScale(binShapeScaleFactor)
        bin_4_shape.position = CGPoint(x: self.size.width - radius / 16, y: radius / 16)
        bin_4_shape.zPosition = 4;
        bin_4_shape.texture = SKTexture(imageNamed: "triangleOutline-1")

        self.addChild(bin_1_shape)
        self.addChild(bin_2_shape)
        self.addChild(bin_3_shape)
        self.addChild(bin_4_shape)
        
        scoreLabel=SKLabelNode()
        scoreLabel.text="Score: "+String(score)
        scoreLabel.fontColor=UIColor.yellow
        scoreLabel.position=CGPoint(x: self.frame.width/2,y: self.frame.height * 7.5/9)
        scoreLabel.zPosition=2
        scoreLabel.fontName = "BigNoodleTitling"
        self.addChild(scoreLabel)
        
        livesLabel = SKLabelNode()
        livesLabel.text = "Lives: " + String(lives)
        livesLabel.fontColor = UIColor.red
        livesLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.5/9)
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
        pauseButton.position = CGPoint(x: self.size.width / 2, y: 15*self.size.height/16)
        self.addChild(pauseButton)
        
        track()
    }
    
    func track() {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Game Screen")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker?.send(builder?.build() as? [AnyHashable: Any] ?? [:])
        let event = GAIDictionaryBuilder.createEvent(withCategory: "Action", action: "Play Game", label: nil, value: nil)
        tracker?.send(event?.build() as? [AnyHashable: Any] ?? [:])
    }
    var isRotating = false
    
    func setRotatingTrue() {
        isRotating = true
    }
    func setRotatingFalse() {
        isRotating = false
    }
    
    // will randomly rotate the bins
    func rotateBins(_ randInt: Int) {
        let animationDuration: Double = 0.5 // THIS NEEDS TO BE UPDATED to be accurate
        let freezeSequence = SKAction.sequence([SKAction.run(setRotatingTrue), SKAction.run(freezeShapes), SKAction.wait(forDuration: animationDuration), SKAction.run(unfreezeShapes), SKAction.run(setRotatingFalse)])
        run(freezeSequence)
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
            
            let rotate = SKAction.rotate(toAngle: -(CGFloat(M_PI_2)), duration: 0.5, shortestUnitArc: true)
            let action1 = SKAction.move(to: CGPoint(x: 0, y: self.size.height), duration: 0.5)
            let action2 = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.5)
            let action3 = SKAction.move(to: CGPoint(x: self.size.width, y: 0), duration: 0.5)
            let action4 = SKAction.move(to: CGPoint(x: self.size.width, y: self.size.height), duration: 0.5)
            
            bin_1.run(rotate)
            bin_1.run(action1)
            
            bin_2.run(rotate)
            bin_2.run(action2)
            
            bin_3.run(rotate)
            bin_3.run(action3)
            
            bin_4.run(rotate)
            bin_4.run(action4)
            
            bin_1_pos = 2
        }
        
        else if ((bin_1_pos == 1 && randInt == 2) || (bin_1_pos == 2 && randInt == 1) || (bin_1_pos == 4 && randInt == 3)) { // 1 to bottom left, 3 to top right, 2 to bottom right, 4 to top lef
            
            let rotate = SKAction.rotate(toAngle: 0, duration: 0.5, shortestUnitArc: true)
            let action1 = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.5)
            let action2 = SKAction.move(to: CGPoint(x: self.size.width, y: 0), duration: 0.5)
            let action3 = SKAction.move(to: CGPoint(x: self.size.width, y: self.size.height), duration: 0.5)
            let action4 = SKAction.move(to: CGPoint(x: 0, y: self.size.height), duration: 0.5)
            
            bin_1.run(rotate)
            bin_1.run(action1)
            
            bin_2.run(rotate)
            bin_2.run(action2)
            
            bin_3.run(rotate)
            bin_3.run(action3)
            
            bin_4.run(rotate)
            bin_4.run(action4)
            
            bin_1_pos = 3
        }
        
        else if ((bin_1_pos == 1 && randInt == 3) || (bin_1_pos == 2 && randInt == 2) || (bin_1_pos == 3 && randInt == 1)) { // 1 to bottom right, 2 to top right, 3 to top left, 4 to bottom lef
            
            let rotate = SKAction.rotate(toAngle: (CGFloat(M_PI_2)), duration: 0.5, shortestUnitArc: true)
            let action1 = SKAction.move(to: CGPoint(x: self.size.width, y: 0), duration: 0.5)
            let action2 = SKAction.move(to: CGPoint(x: self.size.width, y: self.size.height), duration: 0.5)
            let action3 = SKAction.move(to: CGPoint(x: 0, y: self.size.height), duration: 0.5)
            let action4 = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.5)
            
            bin_1.run(rotate)
            bin_1.run(action1)
            
            bin_2.run(rotate)
            bin_2.run(action2)
            
            bin_3.run(rotate)
            bin_3.run(action3)
            
            bin_4.run(rotate)
            bin_4.run(action4)
            
            bin_1_pos = 4
        }
        else if ((bin_1_pos == 2 && randInt == 3) || (bin_1_pos == 3 && randInt == 2) || (bin_1_pos == 4 && randInt == 1)) { // 1 to top right, 2 to top left, 3 to bottom left, 4 to bottom righ
            
            let rotate = SKAction.rotate(toAngle: (CGFloat(M_PI)), duration: 0.5, shortestUnitArc: true)
            let action1 = SKAction.move(to: CGPoint(x: self.size.width, y: self.size.height), duration: 0.5)
            let action2 = SKAction.move(to: CGPoint(x: 0, y: self.size.height), duration: 0.5)
            let action3 = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.5)
            let action4 = SKAction.move(to: CGPoint(x: self.size.width, y: 0), duration: 0.5)
            
            bin_1.run(rotate)
            bin_1.run(action1)
            
            bin_2.run(rotate)
            bin_2.run(action2)
            
            bin_3.run(rotate)
            bin_3.run(action3)
            
            bin_4.run(rotate)
            bin_4.run(action4)
            
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
    
    func addCurvedLines(_ curve: SKShapeNode, dub1: Double, dub2: Double, bol: Bool, arch: Double, radi: CGFloat, color: UIColor) {
        let circlePath : UIBezierPath = UIBezierPath(arcCenter: CGPoint(x: CGFloat(0), y: CGFloat(0)), radius: radi, startAngle: CGFloat(dub1), endAngle: CGFloat(dub2), clockwise: bol)
        curve.path = circlePath.cgPath
        curve.strokeColor = color
        curve.lineWidth = 3
        curve.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        curve.zRotation = CGFloat(M_PI)
    }
    
    func animateBinsAtStart() {
        let rotate = SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1.0);
        //bin_1.anchorPoint = CGPoint(x: 0, y: 1)
        bin_1.run(rotate)
        bin_1.run(SKAction.move(to: CGPoint(x: self.size.width, y: self.size.height), duration: 1.0))
        
        bin_2.run(rotate)
        bin_2.run(SKAction.move(to: CGPoint(x: 0, y: self.size.height), duration: 1.0))
        
        bin_3.run(rotate)
        bin_3.run(SKAction.move(to: CGPoint(x: 0, y: 0), duration: 1.0))
        
        bin_4.run(rotate)
        bin_4.run(SKAction.move(to: CGPoint(x: self.size.width, y: 0), duration: 1.0))
    }
    
    func animateBinsRestart() {
        let rotate = SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1.0);
        let move = SKAction.move(to: CGPoint(x: self.size.width / 2, y: self.size.height / 2), duration: 1.0)
        //bin_1.anchorPoint = CGPoint(x: 0, y: 1)
        bin_1.run(rotate)
        bin_1.run(move)
        
        bin_2.run(rotate)
        bin_2.run(move)
        
        bin_3.run(rotate)
        bin_3.run(move)
        
        bin_4.run(rotate)
        bin_4.run(move)
        delay(0.25) {
            self.animateBinsAtStart();
        }
    }
    
    func playSwoosh(_ which: String) {
        let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: which, ofType: "mp3")!)
        //print(alertSound)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            try audioPlayer3 = AVAudioPlayer(contentsOf: alertSound)
        }
        catch {
            
        }
        audioPlayer3.prepareToPlay()
        checkMute3()
        audioPlayer3.play()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
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
                        if(score % 5 == 0){
                            changeBackground(scorediv20: score / 5)
                        }
                        aud3exists = true
                        playSwoosh("swoosh")
                        aud3exists = false
                        if(score % 10 == 0){ // rotate bins every 10 points
                            self.rotateBins(Int(arc4random_uniform(2) + 1));
                        }
                    } else {
                        explosionEmitterNode?.particleColorSequence=SKKeyframeSequence(keyframeValues: [UIColor.red], times: [0])
                        aud3exists = true
                        playSwoosh("incorrectSound")
                        aud3exists = false
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
                    resetGameOverStar()
                    pressedHighScore()
                } else if (binName == "settings") {
                    pressedSettings()
                }
            }
        }
    }
    func pressedHighScore() {
        saveScore(score)
        showLeaderboard()
    }
    
    func resetGameOverStar() {
        self.restart_star.removeFromParent()
        self.restart_star.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        self.restart_star.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - self.gameOverLabel.frame.height*2);
        self.addChild(restart_star)
    }
    
    func pressedSettings() {
        resetGameOverStar()
        let scene = SettingScene(size: self.size)
        fbbutton.removeFromSuperview()
        let origScene = self
        scene.setOriginalScener(origScene)
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
    
    func goToHome() {
        let scene: SKScene = GameScene(size: self.size)
        fbshare.removeFromSuperview()
        fbsend.removeFromSuperview()
        // Configure the view.
        let skView = self.view as SKView!
        skView?.showsFPS = false
        skView?.showsNodeCount = false
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView?.ignoresSiblingOrder = true
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .aspectFill
        skView?.presentScene(scene)
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Home Screen")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker?.send(builder?.build() as? [AnyHashable: AnyObject] ?? [:])
        let event = GAIDictionaryBuilder.createEvent(withCategory: "Action", action: "Go To Home", label: nil, value: nil)
        tracker?.send(event?.build() as? [AnyHashable: Any] ?? [:])
    }
    
    var timeRequired = 1.6
    var firstTimeCount = 1
    var timeSpeedUpFactor = 0.15
    var minTimeRequired = 0.99
    var multiplicativeSpeedUpFactor = 1.0
    
    var jeffHandCounter = 0
    
    override func update(_ currentTime: TimeInterval) {
        
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
                    shapeToAdd = self.shapeController.spawnShape(score, lives: lives);
                    shapeToAdd.position = CGPoint(x: self.size.width/2, y: self.size.height/2);
                    self.addChild(shapeToAdd);
                    if (!justSpawnedDouble && score > 20) {
                        doubleShapeProbability = max(doubleShapeProbability - 4, 300)
                        /***
                         double spawns start at score 20
                         doubleShapeProbability starts at 600 and drops slowly to 300.
                         Pick random number from 0 to doubleShapeProbability and compare with 100
                         spawn two shapes 16.7% -> 33.3% of the time
                         delay of 0.1 seconds between the double spawn
                         
                         (Before, was after score of 10, delay of 0.2, probability 33% -> 67%)
                        ***/
                        let rand = Int(arc4random_uniform(UInt32(doubleShapeProbability)))
                        if(rand <= 100){
                            //change above value for difficulty purposes!!!!!!!!
                            delay(0.1) {
                                self.shapeToAdd = self.shapeController.spawnShape(self.score, lives: self.lives);
                                self.shapeToAdd.position = CGPoint(x: self.size.width/2, y: self.size.height/2);
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
                    
                    self.shapeController.specialShapeProbability = max(self.shapeController.specialShapeProbability - 4, self.shapeController.sShapeProbabilityBound)
                    multiplicativeSpeedUpFactor -= 0.005
                    applyFirstShapeLabel()
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
            self.enumerateChildNodes(withName: shape, using: {
                node, stop in
                let sprite = node
                if sprite.physicsBody != nil && sprite.physicsBody?.categoryBitMask != PhysicsCategory.Bin {
                    // CHECKS TO SEE IF ANY SHAPE IS ABOVE PAUSE
                    if self.pauseButton.contains(CGPoint(x: sprite.position.x, y: sprite.position.y)){
                        pauseBlocksShapeCounter += 1
                    }
                    if (sprite.position.y < 0 || sprite.position.x < 0 || sprite.position.x > self.size.width || sprite.position.y > self.size.height) {
                        node.removeFromParent();
                        if !self.gameOver {
                            if(node.name == "bomb" || node.name == "heart"){
                                return;
                            }
                            self.lives -= 1;
                            self.aud3exists = true
                            self.playSwoosh("incorrectSound")
                            self.aud3exists = false
                            let explosionEmitterNode = SKEmitterNode(fileNamed: "ExplosionEffect.sks")
                            explosionEmitterNode?.position=sprite.position
                            explosionEmitterNode?.zPosition=100
                            explosionEmitterNode?.particleColorSequence=SKKeyframeSequence(keyframeValues: [UIColor.red], times: [0])
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!touching){
            /* Called when a touch begins */
            let touch: UITouch = touches.first!
            let location: CGPoint = touch.location(in: self)
            
            // Save start location and time
            start = location
            startTimeOfTouch = touch.timestamp
            if arePaused {
                let currNode = self.atPoint(start)
                if currNode.name == "pauseButton" {
                    closePause()
                } else if muteLabel.contains(location) {
                    pressedMute()
                } else if (restartLabel.contains(location)) {
                    closePause()
                    pauseRestart = true
                    restartScene()
                } else if (homeLabel.contains(location)) {
                    goToHome()
                    closePause()
                } else if (themeSettingsLabel.contains(location)) {
                    print("go to settings")
                    closePause()
                } else if (newUnPauseLabel.contains(location)) {
                    closePause()
                }
            } else if !isRotating {
                touchedNode=self.atPoint(start)
                //print(touchedNode)
                if(touchedNode.name == nil){
                    var i=CGFloat(0)
                    var j=CGFloat(0)
                    while(touchedNode.name == nil && i < 5){
                        touchedNode=self.atPoint(CGPoint(x: start.x+i,y: start.y))
                        j=0
                        while(touchedNode.name == nil && j < 5){
                            touchedNode=self.atPoint(CGPoint(x: start.x,y: start.y+j))
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
                    let currBrightness = UIScreen.main.brightness
                    UIScreen.main.brightness = CGFloat(1)
                    let explosionEmitterNode = SKEmitterNode(fileNamed: "ExplosionEffect.sks")
                    explosionEmitterNode?.position=touchedNode.position
                    explosionEmitterNode?.zPosition=100
                    explosionEmitterNode?.particleColorSequence=SKKeyframeSequence(keyframeValues: [UIColor.red, UIColor.yellow], times: [0,1])
                    explosionEmitterNode?.particleLifetime=2.0
                    explosionEmitterNode?.numParticlesToEmit=50
                    explosionEmitterNode?.particleSpeed=200
                    delay(0.5){
                        UIScreen.main.brightness = currBrightness
                    }
                    
                    self.addChild(explosionEmitterNode!)
                    
                    touchedNode.removeFromParent()
                    let tracker = GAI.sharedInstance().defaultTracker
                    let event = GAIDictionaryBuilder.createEvent(withCategory: "Action", action: "Bombed", label: nil, value: nil)
                    tracker?.send(event?.build() as? [AnyHashable: Any] ?? [:])
                } else if(touchedNode.name == "heart"){
                    lives += 1;
                    livesLabel.text="Lives:" + String(lives)
                    let explosionEmitterNode = SKEmitterNode(fileNamed: "ExplosionEffect.sks")
                    explosionEmitterNode?.position=touchedNode.position
                    explosionEmitterNode?.zPosition=100
                    explosionEmitterNode?.particleColorSequence=SKKeyframeSequence(keyframeValues: [UIColor.yellow], times: [0])
                    self.addChild(explosionEmitterNode!)
                    touchedNode.removeFromParent()
                    let tracker = GAI.sharedInstance().defaultTracker
                    let event = GAIDictionaryBuilder.createEvent(withCategory: "Action", action: "Hearted", label: nil, value: nil)
                    tracker?.send(event?.build() as? [AnyHashable: Any] ?? [:])
                } else if (touchedNode.name == "pauseButton") {
                    openPause()
                }
                start=touchedNode.position;
                oldVelocities[touchedNode]=touchedNode.physicsBody?.velocity;
                touchedNode.physicsBody?.velocity=CGVector(dx: 0, dy: 0)
            }
            if gameOver {
                if bin_1_shape.contains(location) {
                    pressedHighScore()
                } else if bin_2_shape.contains(location) {
                    restartScene()
                } else if bin_3_shape.contains(location) {
                    self.removeAllChildren()
                    self.goToHome()
                } else if bin_4_shape.contains(location) {
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
    }
    
    func moveHand() {
        self.hand.removeFromParent()
        self.hand.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.hand.xScale = self.size.width / 5770
        self.hand.yScale = self.size.width / 5770
        self.hand.zPosition = 3
        self.addChild(self.hand)
        let move = SKAction.move(to: CGPoint(x: self.size.width * 1 / 8, y: self.size.height * 7 / 8), duration: 1.5)
        let remove = SKAction.removeFromParent()
        //self.hand.removeFromParent()
        self.hand.run(SKAction.sequence([move, remove]))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if ((!arePaused) && self.atPoint(start).name != nil && touching && self.atPoint(start).physicsBody?.categoryBitMask == PhysicsCategory.Shape) {
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
            touchedNode.physicsBody?.applyImpulse(CGVector(dx: speed*dx, dy: speed*dy))
        }
        else{
            touchedNode=self.atPoint(start)
            if(oldVelocities[touchedNode] != nil){
                touchedNode.physicsBody?.velocity=oldVelocities[touchedNode]!
            }
        }
        touching = false
        touchedNode = SKNode()
        
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
        
        self.removeChildren(in: [pauseButton])
        // add collision actions
        setUpLocalHighScore()
        GCHelper.sharedInstance.reportLeaderboardIdentifier("scoreLeaderboard", score:score)
        content.contentURL = URL(string: "https://itunes.apple.com/us/app/flick-it-xtreme/id1103070396?mt=8")!
        content.contentTitle = "Download FlickIt! (or else)"
        let prevHighScore: Int = UserDefaults.standard.integer(forKey: "score")
        content.contentDescription = "My high score is "+String(prevHighScore)
        fbshare.shareContent = content
        fbsend.shareContent = content
        self.view?.addSubview(fbshare)
        if(fbsend.isHidden){
            print("send is hidden")
        }else{
            self.view?.addSubview(fbsend)
        }
        gameOverTrack()
        putBackPhysicsBodyBin()
        playingGame = false
        self.removeChildren(in: [firstShapeLabel, firstBombLabel, firstHeartLabel])
    }
    
    
    func setUpLocalHighScore() {
        var prevHighScore: Int = UserDefaults.standard.integer(forKey: "score")
        if prevHighScore < score {
            // score from game just played is best
            UserDefaults.standard.set(score, forKey: "score")
            UserDefaults.standard.synchronize()
            prevHighScore = score
            gameOverHighScoreLabel.fontColor = UIColor.red
            gameOverHighScoreLabel.text = "* Your New High Score: " + String(prevHighScore) + " *"

        } else {
            gameOverHighScoreLabel.fontColor = UIColor.white
            gameOverHighScoreLabel.text = "Your High Score: " + String(prevHighScore)
        }
        if (self.children.contains(gameOverHighScoreLabel)) {
            self.removeChildren(in: [gameOverHighScoreLabel])
        }
        gameOverHighScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/3.9);
        gameOverHighScoreLabel.horizontalAlignmentMode = .center
        gameOverHighScoreLabel.fontName = "BigNoodleTitling"
        gameOverHighScoreLabel.fontSize = 20
        gameOverHighScoreLabel.zPosition = 5
        self.addChild(gameOverHighScoreLabel)
        
    }
    
    func gameOverTrack() {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Lose Screen")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker?.send(builder?.build() as? [AnyHashable: Any] ?? [:])
        let event = GAIDictionaryBuilder.createEvent(withCategory: "Action", action: "Lost", label: nil, value: nil)
        tracker?.send(event?.build() as? [AnyHashable: Any] ?? [:])
        tracker?.set(GAIFields.customMetric(for: 1), value: String(score))
        let timeElapsed = Date().timeIntervalSince(timeBegan)
        tracker?.set(GAIFields.customMetric(for: 2), value: String(timeElapsed))
    }
    
    func createStar() {
        let rect: CGRect = CGRect(x: 0, y: 0, width: self.size.width/6, height: self.size.width/6)
        restart_star.path = self.starPath(0, y: 0, radius: rect.size.width/3, sides: 5, pointyness: 2)
        restart_star.strokeColor = UIColor.black
        restart_star.fillColor = yellow
        restart_star.zPosition = 7
        restart_star.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - self.gameOverLabel.frame.height*2);
        // Set names for the launcher so that we can check what node is touched in the touchesEnded method
        restart_star.name = "gameOverStar";
        //could randomize rotation here
        let rotation = SKAction.rotate(byAngle: CGFloat(2 * M_PI), duration: 10)
        restart_star.run(SKAction.repeatForever(rotation))
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
    
    func setupStarPhysics() {
        restart_star.isUserInteractionEnabled = false
        restart_star.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: restart_star.frame.width, height: restart_star.frame.height))
        restart_star.physicsBody?.isDynamic = true
        restart_star.physicsBody?.affectedByGravity=false
        restart_star.physicsBody?.categoryBitMask = PhysicsCategory.Shape
        restart_star.physicsBody?.collisionBitMask=PhysicsCategory.Bin
        restart_star.physicsBody?.contactTestBitMask=PhysicsCategory.Bin
        
    }
    
    let gameOverHighScoreLabel = SKLabelNode(text: "")
    let gameOverLabel = SKLabelNode(text: "GAMEOVER")
    
    
    let gameOverScoreLabel = SKLabelNode(text: "")

    func setupGameOverLabels() {
        gameOverScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2);
        gameOverScoreLabel.horizontalAlignmentMode = .center
        gameOverScoreLabel.fontColor = UIColor.white
        gameOverScoreLabel.fontName = "BigNoodleTitling"
        gameOverScoreLabel.fontSize = 25
        gameOverScoreLabel.zPosition = 5
        gameOverScoreLabel.text = "Score " + String(score)
        self.addChild(gameOverScoreLabel)
        
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + gameOverScoreLabel.frame.height + 5);
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.fontColor = UIColor.yellow
        gameOverLabel.fontName = "BigNoodleTitling"
        gameOverLabel.fontSize = 30
        gameOverLabel.zPosition = 5
        self.addChild(gameOverLabel)
    }

    
    func restartScene() {
        // makes bins smaller
        restartBTN = SKSpriteNode() // stopped being able to click when not there
        fbshare.removeFromSuperview()
        fbsend.removeFromSuperview()
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
    var newUnPauseLabel = SKLabelNode()
    
    func openPause() {
        playingGame = false
        pauseButton.texture = SKTexture(imageNamed: "playButton")
        //bgImage.run(SKAction.fadeAlpha(to: 0.2, duration: 0.5));
        arePaused = true
        if appDelegate.muted == true {
            muteLabel.text = "Unmute"
        }
        else {
            muteLabel.text = "Mute"
        }
        muteLabel.fontColor=UIColor.white
        muteLabel.position=CGPoint(x: self.frame.width/2, y: 3.5*self.frame.height/12)
        muteLabel.fontName = "BigNoodleTitling"
        muteLabel.zPosition = 7
        self.addChild(muteLabel)
        
        newUnPauseLabel.text = "Resume"
        newUnPauseLabel.fontColor=UIColor.white
        newUnPauseLabel.position=CGPoint(x: self.frame.width/2, y: 8*self.frame.height/12)
        newUnPauseLabel.fontName = "BigNoodleTitling"
        newUnPauseLabel.zPosition = 7
        self.addChild(newUnPauseLabel)
        
        restartLabel.text = "Restart"
        restartLabel.fontColor=UIColor.white
        restartLabel.position=CGPoint(x: self.frame.width/2, y: 6.5*self.frame.height/12)
        restartLabel.fontName = "BigNoodleTitling"
        restartLabel.zPosition = 7
        self.addChild(restartLabel)
        
        homeLabel.text = "Home"
        homeLabel.fontColor=UIColor.white
        homeLabel.position=CGPoint(x: self.frame.width/2, y: 5*self.frame.height/12)
        homeLabel.fontName = "BigNoodleTitling"
        homeLabel.zPosition = 7
        self.addChild(homeLabel)
//        addThemeSettingLabel()
        pauseBackground = SKShapeNode(rectOf: CGSize(width: 11 * self.size.width/16, height: 8 * self.size.height/16))
        pauseBackground.fillColor = UIColor(red: 82/255, green: 167/255, blue: 178/255, alpha: 0.5)
        pauseBackground.position = CGPoint(x: self.size.width/2, y: self.size.height/2);
        pauseBackground.zPosition = 6
        self.addChild(pauseBackground)
        freezeShapes()
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Pause Screen")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker?.send(builder?.build() as? [AnyHashable: Any] ?? [:])
        let event = GAIDictionaryBuilder.createEvent(withCategory: "Action", action: "Pause", label: nil, value: nil)
        tracker?.send(event?.build() as? [AnyHashable: Any] ?? [:])
    }
    
    func addThemeSettingLabel() {
        themeSettingsLabel.text = "Pick a theme"
        themeSettingsLabel.fontColor=UIColor.white
        themeSettingsLabel.position=CGPoint(x: self.frame.width/2,y: self.frame.height/5)
        themeSettingsLabel.zPosition=5
        themeSettingsLabel.fontName = "BigNoodleTitling"
        self.addChild(themeSettingsLabel)
    }
    
    func freezeShapes() {
        for node in self.children {
            if node.physicsBody?.categoryBitMask == PhysicsCategory.Shape {
                pausedShapeVelocities[node] = node.physicsBody?.velocity
                node.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
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
        //bgImage.run(SKAction.fadeAlpha(to: 1.0, duration: 0.5));
        arePaused = false
        // manipulate touch end
        self.removeChildren(in: [muteLabel, restartLabel, homeLabel, themeSettingsLabel, pauseBackground, newUnPauseLabel])
        muteLabel = SKLabelNode()
        muteLabel.fontName = "BigNoodleTitling"
        restartLabel = SKLabelNode()
        restartLabel.fontName = "BigNoodleTitling"
        homeLabel = SKLabelNode()
        homeLabel.fontName = "BigNoodleTitling"
        themeSettingsLabel = SKLabelNode()
        themeSettingsLabel.fontName = "BigNoodleTitling"
        newUnPauseLabel = SKLabelNode()
        newUnPauseLabel.fontName = "BigNoodleTitling"
        unfreezeShapes()
        playingGame = true
        track()
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
        if audioPlayer.isPlaying {
            audioPlayer.volume = 0
        }
        if aud2exists {
            if audioPlayer2.isPlaying {
                audioPlayer2.volume = 0
            }
        }
        if aud3exists {
            if audioPlayer3.isPlaying {
                audioPlayer3.volume = 0
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
        if aud3exists {
            if audioPlayer3.volume == 0 {
                audioPlayer3.volume = 1
            }
        }
    }
    
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
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
    
    func createLine(_ end: CGPoint){
        line.lineWidth=1.5
        line.path = linePath(end)
        line.fillColor = UIColor.white
        line.strokeColor = UIColor.white
        line.zPosition=4
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController)
    {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func saveScore(_ score: Int) {
//        if GKLocalPlayer.localPlayer().authenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: "scoreLeaderboard")
            scoreReporter.value = Int64(score)
            let scoreArray : [GKScore] = [scoreReporter]
            GKScore.report(scoreArray, withCompletionHandler: {
                (NSError) in
                print(NSError)
                return
            })
//        }
    }
    
    func showLeaderboard() {
        let localPlayer = GKLocalPlayer.localPlayer()
        if !localPlayer.isAuthenticated {
            let alert = UIAlertController(title: "Not logged into GameCenter", message: "To see high scores, please log in to GameCenter via Settings", preferredStyle: UIAlertControllerStyle.actionSheet)
            alert.addAction(
                UIAlertAction(
                    title: "Cancel",
                    style: UIAlertActionStyle.cancel,
                    handler: nil
                )
            )
            self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
            
            // UIAlertView
            // open "Do you want to log in gamecenter?"
            // if wants to log in, open sign in sheet
            // if not, go back
        } else {
            let viewController = self.view!.window?.rootViewController
            let gameCenterVC: GKGameCenterViewController! = GKGameCenterViewController()
    //        let gameCenterVC: GKGameCenterViewController! = GKGameCenterViewController(rootViewController: viewController!)
            gameCenterVC.gameCenterDelegate = self
            viewController?.dismiss(animated: true, completion: nil)
            
            print(viewController?.presentedViewController) // thought this wasn't nil then can't put one vc on top of another
            viewController?.removeFromParentViewController()
            
            viewController!.present(gameCenterVC, animated: true, completion: nil)
            print(viewController?.presentedViewController)
        }
    }
    
    
//    deinit{
//        let vc = self.view!.window?.rootViewController
//        vc!.view.removeFromSuperview()
////        if let superView = vc!.view.superview
////        {
////            superView.removeFromSuperview()
////        }
//    }
    var doneCounter = [0,0,0]
    
    func applyFirstShapeLabel() {
        let shapeCounter = shapeController.getShapeCounter()
        // checks if the shape that appears is the first of its kind; if so, create a label
        let regShapeCounter = shapeCounter[0] + shapeCounter[1] + shapeCounter[2] + shapeCounter[3]
        if regShapeCounter == 1 && doneCounter[0] == 0 {
            self.removeChildren(in: [firstShapeLabel, firstBombLabel, firstHeartLabel])
            showShapeLabel()
            doneCounter[0] = 1
        }
        if shapeCounter[4] == 1 && doneCounter[1] == 0 {
            self.removeChildren(in: [firstShapeLabel, firstBombLabel, firstHeartLabel])
            showBombLabel()
            doneCounter[1] = 1
        }
        if shapeCounter[5] == 1 && doneCounter[2] == 0 {
            self.removeChildren(in: [firstShapeLabel, firstBombLabel, firstHeartLabel])
            showHeartLabel()
            doneCounter[2] = 1
        }
    }
    
    let delayTime = 1.5
    let firstShapeLabel=SKLabelNode()
    let firstBombLabel=SKLabelNode()
    let firstHeartLabel=SKLabelNode()

    func showShapeLabel() {
        firstShapeLabel.text = "Flick shape to its bin!"
        firstShapeLabel.fontColor=UIColor.yellow
        firstShapeLabel.position=CGPoint(x: self.size.width/2,y: self.size.height * 1.5/9)
        firstShapeLabel.zPosition=5
        firstShapeLabel.fontName = "BigNoodleTitling"
        let firstShapeLabelAddAction = SKAction.run({
            self.addChild(self.firstShapeLabel)
        })
        let delay = SKAction.wait(forDuration: delayTime)
        let firstShapeLabelRemoveAction = SKAction.run({
            self.removeChildren(in: [self.firstShapeLabel])
        })
        let showAction = SKAction.sequence([firstShapeLabelAddAction, delay, firstShapeLabelRemoveAction])
        run(showAction)
    }
    
    func showBombLabel() {
        firstBombLabel.text = "Don't touch the bombs"
        firstBombLabel.fontColor=UIColor.yellow
        firstBombLabel.position=CGPoint(x: self.size.width/2,y: self.size.height * 1.5/9)
        firstBombLabel.zPosition=5
        firstBombLabel.fontName = "BigNoodleTitling"
        
        let firstBombLabelAddAction = SKAction.run({
            self.addChild(self.firstBombLabel)
        })
        let delay = SKAction.wait(forDuration: delayTime)
        let firstBombLabelRemoveAction = SKAction.run({
            self.removeChildren(in: [self.firstBombLabel])
        })
        let showAction = SKAction.sequence([firstBombLabelAddAction, delay, firstBombLabelRemoveAction])
        run(showAction)
    }
    
    func showHeartLabel() {
        firstHeartLabel.text = "Touch hearts for extra live"
        firstHeartLabel.fontColor=UIColor.yellow
        firstHeartLabel.position=CGPoint(x: self.size.width/2,y: self.size.height * 1.5/9)
        firstHeartLabel.zPosition=5
        firstHeartLabel.fontName = "BigNoodleTitling"
        let firstHeartLabelAddAction = SKAction.run({
            self.addChild(self.firstHeartLabel)
        })
        let delay = SKAction.wait(forDuration: delayTime)
        let firstHeartLabelRemoveAction = SKAction.run({
            self.removeChildren(in: [self.firstHeartLabel])
        })
        let showAction = SKAction.sequence([firstHeartLabelAddAction, delay, firstHeartLabelRemoveAction])
        run(showAction)
    }
    
}

extension Array {
    func rotate(_ shift:Int) -> Array {
        var array = Array()
        if (self.count > 0) {
            array = self
            for _ in 1...abs(shift) {
                array.insert(array.remove(at: array.count-1),at:0)
            }
        }
        return array
    }
}
