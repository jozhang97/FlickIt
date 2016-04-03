
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

    let red: UIColor = UIColor(red: 160/255, green: 80/255, blue: 76/255, alpha: 1)
    let blue: UIColor = UIColor(red: 85/255, green: 135/255, blue: 76/255, alpha: 1)
    let green: UIColor = UIColor(red: 144/255, green: 155/255, blue: 103/255, alpha: 1)
    let purple: UIColor = UIColor(red: 99/255, green: 103/255, blue: 211/255, alpha: 1)
    let yellow: UIColor = UIColor(red: 249/255, green: 234/255, blue: 82/255, alpha: 1)
    
    var bomb = SKSpriteNode(imageNamed: "bomb.png")

    var bgImage = SKSpriteNode(imageNamed: "background.png");

    
    var bin_1 = SKSpriteNode(imageNamed: "blue_bin_t.png"); // all bins are facing bottom right corner
    var bin_2 = SKSpriteNode(imageNamed: "red_bin_t.png");
    var bin_3 = SKSpriteNode(imageNamed: "green_bin_t.png");
    var bin_4 = SKSpriteNode(imageNamed: "purple_bin_t.png");
    
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
    
    let shapes = ["blue_triangle-1", "blue_square-1", "blue_circle-1","blue_star-1", "gameOverStar"]
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
    
    // Actual dimensions of the screen
    var sceneHeight = CGFloat(0);
    var sceneWidth = CGFloat(0);
    override init(size: CGSize) {
        super.init(size: size)
        lives = NUMBEROFLIFES
        bin_1_width = bin_1.size.width
        bin_2_width = bin_2.size.width
        bin_3_width = bin_3.size.width
        bin_4_width = bin_4.size.width
        bin_3_shape_width = bin_3_shape.size.width
        binWidth = bin_1.size.width
        sceneHeight = sizeRect.size.height * UIScreen.mainScreen().scale;
        sceneWidth = sizeRect.size.width * UIScreen.mainScreen().scale;
        shapeScaleFactor = 0.14*self.size.width/bin_3_shape_width
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
        self.physicsWorld.contactDelegate = self
        
        bgImage.size = CGSize(width: self.size.width, height: self.size.height);
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        bgImage.zPosition = 1
        self.addChild(bgImage);
        //adds bins on all 4 corners of screen with name, zposition and size
        //bin_1.size = CGSize(width: 100, height: 100)
        // top right
        bin_1.anchorPoint = CGPoint(x: 1, y: 0)
        bin_1.setScale(0.264*self.size.width/bin_1_width) // see Ashwin's paper for scaling math
        bin_1.position = CGPointMake(self.size.width / 2, self.size.height / 2)
        bin_1.zRotation = CGFloat(-M_PI_2)
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
        bin_1_shape.texture = SKTexture(imageNamed: "blue_star-1")
        
        bin_1.name = shapes[3] //set bin names to name of shapes they take
        
        //bin_2.size = CGSize(width: 100, height: 100)
        // top left
        bin_2.anchorPoint = CGPoint(x: 1, y: 0)
        bin_2.zRotation = 0
        bin_2.setScale(0.264*self.size.width/bin_2_width)
        bin_2.position = CGPointMake(self.size.width / 2, self.size.height / 2)
        // don't rotate this bin
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
        bin_2_shape.texture = SKTexture(imageNamed: "blue_square-1")

        bin_2.name = shapes[1] //set bin names to name of shapes they take
        
        //bin_3.size = CGSize(width: 100, height: 100)
        // bottom right
        bin_3.anchorPoint = CGPoint(x: 1, y: 0)
        bin_3.position = CGPointMake(self.size.width / 2, self.size.height / 2)
        bin_3.setScale(0.264*self.size.width/bin_3_width)
        bin_3.zRotation = CGFloat(M_PI)
        bin_3.zPosition = 3
        
        //let physics = CGPointMake(self.frame.width * 2 / 3 + bin_3.size.width/2, self.frame.height / 10 - bin_3.size.height/2)
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
        bin_3_shape.texture = SKTexture(imageNamed: "blue_circle-1")

        bin_3.name = shapes[2] //set bin names to name of shapes they take
        
        //bin_4.size = CGSize(width: 100, height: 100)
        //bottom left
        bin_4.anchorPoint = CGPoint(x: 1, y: 0)
        bin_4.setScale(0.264*self.size.width/bin_4_width)
        bin_4.position = CGPointMake(self.size.width / 2, self.size.height / 2)
        bin_4.zRotation = CGFloat(M_PI_2)
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
        bin_4_shape.texture = SKTexture(imageNamed: "blue_triangle-1")

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
        delay(0.5) {
            self.animateBinsAtStart();
        }
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
        
        
    }
    
    func animateBinsAtStart() {
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI), duration: 1.0);
        //bin_1.anchorPoint = CGPoint(x: 0, y: 1)
        bin_1.runAction(rotate)
        bin_1.runAction(SKAction.moveTo(CGPoint(x: self.size.width, y: self.size.height), duration: 1.0))
        
        bin_2.runAction(rotate)
        bin_2.runAction(SKAction.moveTo(CGPoint(x: 0, y: self.size.height), duration: 1.0))
        
        bin_3.runAction(rotate)
        bin_3.runAction(SKAction.moveTo(CGPoint(x: self.size.width, y: 0), duration: 1.0))
        
        bin_4.runAction(rotate)
        bin_4.runAction(SKAction.moveTo(CGPoint(x: 0, y: 0), duration: 1.0))
        //bin_2.runAction(SKAction.group([rotate, SKAction.moveTo(CGPoint(x: 0, y: self.size.height), duration: 1.0)]))
        //bin_3.runAction(SKAction.group([rotate, SKAction.moveTo(CGPoint(x: self.size.width, y: 0), duration: 1.0)]))
        //bin_4.runAction(SKAction.group([rotate, SKAction.moveTo(CGPoint(x: 0, y: 0), duration: 1.0)]))
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody=contact.bodyA
        var secondBody=contact.bodyB
        if(firstBody.categoryBitMask==PhysicsCategory.Bin && secondBody.categoryBitMask==PhysicsCategory.Shape){
            firstBody=contact.bodyB
            secondBody=contact.bodyA
        }
        if !gameOver {
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
                    scoreLabel.text="Score:"+String(score)
                    livesLabel.text = "Lives:" + String(lives)
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
    }
    
    var timeRequired = 2.0
    var firstTimeCount = 1
    var timeSpeedUpFactor = 0.05
    var minTimeRequired = 1.0
    var multiplicativeSpeedUpFactor = 1.0
    
    override func update(currentTime: CFTimeInterval) {
        let didRemoveGameover = removeOffScreenNodes()
        
        if !gameOver && !arePaused {
            if currentTime - time >= timeRequired {

                if (firstTimeCount > 0) {
                    time = currentTime;
                    firstTimeCount -= 1
                } else {
                    shapeToAdd = self.shapeController.spawnShape();
                    shapeToAdd.position = CGPointMake(self.size.width/2, self.size.height/2);
                    self.addChild(shapeToAdd);
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
        else {
            if didRemoveGameover {
                gameOverStar.removeFromParent()
                setUpGameOverStar()
            }
        }
    }


    // increment when shape goes off screen or when flicked into wrong bin
    func removeOffScreenNodes() -> Bool {
        var didRemoveGameOver = false
            for shape in shapes {
                self.enumerateChildNodesWithName(shape, usingBlock: {
                    node, stop in
                    let sprite = node as! SKSpriteNode
                    if (sprite.position.y < 0 || sprite.position.x < 0 || sprite.position.x > self.size.width || sprite.position.y > self.size.height) {
                        node.removeFromParent();
                        if !self.gameOver {
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
        startTime = touch.timestamp
        let touchedNode=self.nodeAtPoint(start)
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
        } else if (touchedNode.name == "pauseButton") {
            openPause()
        }
        oldVelocities[touchedNode]=touchedNode.physicsBody?.velocity;
        touchedNode.physicsBody?.velocity=CGVectorMake(0, 0)
//        if restartBTN.containsPoint(location) {
//            restartScene()
//        }
        
        if arePaused {
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
//        restartBTN = SKSpriteNode(imageNamed: "restartBTN")
//        restartBTN.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
//        restartBTN.zPosition = 6
//        self.addChild(restartBTN);
        gameOver = true
        playMusic("loser_goodbye", type: "mp3") // change to some lose song
        // change bin displays
        bin_1_shape.texture = SKTexture(imageNamed:"graphs")
        bin_2_shape.texture = SKTexture(imageNamed:"refreshArrow")
        bin_3_shape.texture = SKTexture(imageNamed:"settingsPic")
        bin_4_shape.texture = SKTexture(imageNamed:"house")
        bin_1.name = "highScore"
        bin_2.name = "restart"
        bin_3.name = "settings"
        bin_4.name = "home"
        // Add gameover label and star node
        setupGameOverLabels()
        setUpGameOverStar()
        self.removeChildrenInArray([pauseButton])
        // add collision actions 
        // readd star node if flicked off screen
    }
    let gameOverLabel = SKLabelNode(text: "GAMEOVER")
    var gameOverStar = SKSpriteNode(imageNamed: "blue_star-1")
    let gameOverScoreLabel = SKLabelNode(text: "")

    func setupGameOverLabels() {
        gameOverLabel.position = CGPointMake(self.size.width/2, self.size.height/2);
        gameOverLabel.horizontalAlignmentMode = .Center
        gameOverLabel.fontColor = UIColor.whiteColor()
        gameOverLabel.fontName = "Futura"
        gameOverLabel.fontSize = 22
        gameOverLabel.zPosition = 5
        self.addChild(gameOverLabel)
        gameOverScoreLabel.position = CGPointMake(self.size.width/2, self.size.height/2 + gameOverLabel.frame.height);
        gameOverScoreLabel.horizontalAlignmentMode = .Center
        gameOverScoreLabel.fontColor = UIColor.whiteColor()
        gameOverScoreLabel.fontName = "Futura"
        gameOverScoreLabel.fontSize = 25
        gameOverScoreLabel.zPosition = 5
        gameOverScoreLabel.text = "Score " + String(score)
        self.addChild(gameOverScoreLabel)
    }
    
    func setUpGameOverStar() {
        self.shapeController.setUpShape(gameOverStar, scale: shapeScaleFactor)
        gameOverStar.position = CGPointMake(self.size.width/2, self.size.height/2 - self.gameOverLabel.frame.height);
        gameOverStar.name = "gameOverStar"
        self.addChild(gameOverStar)
    }
    
    
    func restartScene() {
        // makes bins smaller
        restartBTN = SKSpriteNode() // stopped being able to click when not there
        self.removeAllActions()
        self.removeAllChildren()
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
        unPausedLabel.text = "Unpause"
        unPausedLabel.fontColor=UIColor.whiteColor()
        unPausedLabel.position=CGPointMake(self.frame.width/2, 5 * self.frame.height / 6)
        unPausedLabel.zPosition=5
        self.addChild(unPausedLabel)
        arePaused = true
        muteLabel.text = "Mute"
        muteLabel.fontColor=UIColor.whiteColor()
        muteLabel.position=CGPointMake(self.frame.width/2,3.5*self.frame.height/5)
        muteLabel.zPosition=5
        self.addChild(muteLabel)
        restartLabel.text = "Restart Game"
        restartLabel.fontColor=UIColor.whiteColor()
        restartLabel.position=CGPointMake(self.frame.width/2, 3*self.frame.height/5)
        restartLabel.zPosition=5
        self.addChild(restartLabel)
        homeLabel.text = "Go Home"
        homeLabel.fontColor=UIColor.whiteColor()
        homeLabel.position=CGPointMake(self.frame.width/2, 2*self.frame.height/5)
        homeLabel.zPosition=5
        self.addChild(homeLabel)
        themeSettingsLabel.text = "Pick a new theme"
        themeSettingsLabel.fontColor=UIColor.whiteColor()
        themeSettingsLabel.position=CGPointMake(self.frame.width/2,self.frame.height/5)
        themeSettingsLabel.zPosition=5
        self.addChild(themeSettingsLabel)
        pauseBackground = SKShapeNode(rectOfSize: CGSize(width: 11 * self.size.width/16, height: 11 * self.size.height/16))
        pauseBackground.fillColor = UIColor(red: 70/255, green: 80/255, blue: 160/255, alpha: 0.5)
        pauseBackground.position = CGPointMake(self.size.width/2, self.size.height/2);
        pauseBackground.zPosition = 4
        self.addChild(pauseBackground)
        stopShapes()
        self.removeChildrenInArray([pauseButton])
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
        arePaused = false
        // manipulate touch end
        self.removeChildrenInArray([muteLabel, restartLabel, homeLabel, themeSettingsLabel, unPausedLabel, pauseBackground])
        muteLabel = SKLabelNode()
        restartLabel = SKLabelNode()
        homeLabel = SKLabelNode()
        themeSettingsLabel = SKLabelNode()
        unPausedLabel = SKLabelNode()
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
}