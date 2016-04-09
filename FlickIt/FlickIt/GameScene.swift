//
//  GameScene.swift
//  FlickIt
//
//  Created by Jeffrey Zhang on 2/13/16.
//  Copyright (c) 2016 Abhi_Shaili_Jeffrey_Rohan_Ashwin. All rights reserved.
//

import SpriteKit
import AVFoundation

struct PhysicsCategory {
    static let Bin : UInt32 = 0x1 << 1
    static let Shape : UInt32 = 0x1 << 2
}

class GameScene: SKScene {
    //variables needed for flicking
    var start = CGPoint()
    var startTime = NSTimeInterval()
    let kMinDistance = CGFloat(50)
    let kMinDuration = CGFloat(0)
    let kMinSpeed = CGFloat(100)
    let kMaxSpeed = CGFloat(500)
    
    //variables that construct the Home Game Scene
    let bgImage = SKSpriteNode(imageNamed: "flickitbg.png")
    let startLabel = SKLabelNode(text: "START")
    let rulesLabel = SKLabelNode(text: "RULES")
    let titleLabel = SKLabelNode(text: "FLICK IT")
    let topLeft = SKShapeNode()
    let topRight = SKShapeNode()
    let bottomLeft = SKShapeNode()
    let bottomRight = SKShapeNode()
    let star = SKShapeNode()
    let muteButton = SKSpriteNode(imageNamed: "playNow.png")
    let aboutButton = SKLabelNode(text: "ABOUT")
    var audioPlayer = AVAudioPlayer()
    var audioPlayer2 = AVAudioPlayer()
    var mute = 0
    let red: UIColor = UIColor(red: 164/255, green: 84/255, blue: 80/255, alpha: 1)
    let blue: UIColor = UIColor(red: 85/255, green: 135/255, blue: 141/255, alpha: 1)
    let green: UIColor = UIColor(red: 147/255, green: 158/255, blue: 106/255, alpha: 1)
    let purple: UIColor = UIColor(red: 99/255, green: 103/255, blue: 211/255, alpha: 1)
    let yellow: UIColor = UIColor(red: 250/255, green: 235/255, blue: 83/255, alpha: 1)
    
    override func didMoveToView(view: SKView) {
        createHomeScreen()
        playMusic("intromusic", type: "mp3")
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
        audioPlayer.numberOfLoops = -1
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
    
    func trackHome() {
        // JEFFREY look into trackers
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Home Screen")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        let event = GAIDictionaryBuilder.createEventWithCategory("Action", action: "Open App", label: nil, value: nil)
        tracker.send(event.build() as [NSObject : AnyObject])
    }
    
    func createHomeScreen(){
        trackHome()
        
        //create triangle SKShapeNode
        createStar()
        
        //setup Physics stuff of triangle SKShapeNode
        setupStarPhysics()
        
        // Create and add title to home screen
        setupTitleLabel()
        
        //curve up shape
        
        let radius = self.size.height/6
        
        addCurvedLines(topRight, dub1: 0, dub2: M_PI/2, bol: true, arch: Double(self.size.height/2 + radius), radi: radius, color: red)
        //curve down shape
        addCurvedLines(topLeft, dub1: M_PI/2, dub2: M_PI, bol: true, arch: Double(self.size.height/2 - radius), radi: radius, color: blue)
        addCurvedLines(bottomLeft, dub1: M_PI, dub2: M_PI*3/2, bol: true, arch: Double(self.size.height/2 - radius), radi: radius, color: green)
        addCurvedLines(bottomRight, dub1: M_PI*3/2, dub2: M_PI*2, bol: true, arch: Double(self.size.height/2 - radius), radi: radius, color: purple)
        
        
        // Sets bg image to fill the entire screen
        bgImage.size = CGSize(width: self.size.width, height: self.size.height);
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        // Set up start Label
        setupStartLabel(radius)
        
        // Set up rules Label
        setupRulesLabel(radius)
        
        // Set up about Button
        setupAboutLabel()
        
        //set up mute button features
        createMuteButton()
        
        //set Z-positions
        bgImage.zPosition = 1
        startLabel.zPosition = 2
        rulesLabel.zPosition = 2
        titleLabel.zPosition = 2
        aboutButton.zPosition = 2
        topLeft.zPosition = 3
        topRight.zPosition = 3
        bottomLeft.zPosition = 3
        bottomRight.zPosition = 3
        star.zPosition = 4
        muteButton.zPosition = 5
        
        // Add all the elements to the screen
        self.addChild(bgImage)
        self.addChild(star)
        self.addChild(topRight)
        self.addChild(topLeft)
        self.addChild(bottomLeft)
        self.addChild(bottomRight)
        self.addChild(titleLabel)
        self.addChild(rulesLabel)
        self.addChild(startLabel)
        self.addChild(aboutButton)
        self.addChild(muteButton);
        delay(1) {
            self.animateBinsAtStart()
        }
        // Have triangle first shoot up quickly, then slower and slower.
        /*
        triangle.runAction(SKAction.sequence([
            SKAction.moveBy(CGVectorMake(0, self.size.height / 15), duration: 1),
            SKAction.moveBy(CGVectorMake(0, self.size.height / 15), duration: 15),
            SKAction.moveBy(CGVectorMake(0, self.size.height / 20), duration: 50)
            ])
        )
        */
    }
    
    func setupAboutLabel() {
        aboutButton.position = CGPointMake(self.size.width - rulesLabel.frame.width/2, self.size.height - 2 * startLabel.frame.height)
        aboutButton.horizontalAlignmentMode = .Center
        aboutButton.fontColor = UIColor.whiteColor()
        aboutButton.fontName = "Open Sans Cond Light"
        aboutButton.fontSize = 20
    }
    
    func addCurvedLines(curve: SKShapeNode, dub1: Double, dub2: Double, bol: Bool, arch: Double, radi: CGFloat, color: UIColor) {
        let circlePath : UIBezierPath = UIBezierPath(arcCenter: CGPointMake(CGFloat(0), CGFloat(0)), radius: radi, startAngle: CGFloat(dub1), endAngle: CGFloat(dub2), clockwise: bol)
        curve.path = circlePath.CGPath
        curve.strokeColor = color
        curve.lineWidth = 3
        curve.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
    }
    
    private func pointFrom(angle: CGFloat, radius: CGFloat, offset: CGPoint) -> CGPoint {
        return CGPoint(x: radius * cos(angle) + offset.x, y: radius * sin(angle) + offset.y)
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
            i--;
        }
        return points
    }
    
    func starPath(x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, pointyness:CGFloat) -> CGPathRef {
        let adjustment = 360/sides/2
        let path = CGPathCreateMutable()
        let points = polygonPointArray(sides,x: x,y: y,radius: radius)
        var cpg = points[0]
        let points2 = polygonPointArray(sides,x: x,y: y,radius: radius*pointyness,adjustment:CGFloat(adjustment))
        var i = 0
        CGPathMoveToPoint(path, nil, cpg.x, cpg.y)
        for p in points {
            CGPathAddLineToPoint(path, nil, points2[i].x, points2[i].y)
            CGPathAddLineToPoint(path, nil, p.x, p.y)
            i++
        }
        CGPathCloseSubpath(path)
        return path
    }
    
    func createStar() {
        let rect: CGRect = CGRectMake(0, 0, self.size.width/6, self.size.width/6)
        star.path = self.starPath(0, y: 0, radius: rect.size.width/3, sides: 5, pointyness: 2)
        star.strokeColor = yellow
        star.fillColor = yellow
        star.position = CGPointMake(self.size.width/2, self.size.height/2);
        // Set names for the launcher so that we can check what node is touched in the touchesEnded method
        star.name = "launch star";
        //could randomize rotation here
        star.runAction(SKAction.rotateByAngle(CGFloat(M_PI/2), duration: 1.5))
    }
    
    func setupStarPhysics() {
        star.userInteractionEnabled = false
        star.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: star.frame.width, height: star.frame.height))
        star.physicsBody?.dynamic = true
        star.physicsBody?.affectedByGravity=false
    }
    
    func setupTitleLabel() {
        titleLabel.position = CGPointMake(self.size.width/2, self.size.height - titleLabel.frame.height - 20);
        titleLabel.horizontalAlignmentMode = .Center
        titleLabel.fontColor = UIColor.whiteColor()
        titleLabel.fontName = "Open Sans Cond Light"
        titleLabel.fontSize = 30
    }
    
    func setupStartLabel(rad: CGFloat) {
        startLabel.position = CGPointMake(startLabel.frame.width/2, self.size.height - 2 * startLabel.frame.height);
        startLabel.horizontalAlignmentMode = .Center
        startLabel.fontColor = UIColor.whiteColor()
        startLabel.fontName = "Open Sans Cond Light"
        startLabel.fontSize = 20
    }
    
    func setupRulesLabel(rad: CGFloat) {
        rulesLabel.position = CGPointMake(self.size.width - rulesLabel.frame.width/2, rulesLabel.frame.height);
        rulesLabel.horizontalAlignmentMode = .Center
        rulesLabel.fontColor = UIColor.whiteColor()
        rulesLabel.fontName = "Open Sans Cond Light"
        rulesLabel.fontSize = 20
    }
    
    func createMuteButton() {
        muteButton.position = CGPoint(x: self.size.width/10, y: self.size.height/10)
        muteButton.size = CGSize(width: self.size.width/5, height: self.size.height/10);
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.locationInNode(self)
        // Save start location and time
        start = location
        startTime = touch.timestamp
        
        //let touchedNode = self.nodeAtPoint(start)
        //oldVelocities[touchedNode]=touchedNode.physicsBody?.velocity;
        //touchedNode.physicsBody?.velocity=CGVectorMake(0, 0)
        if muteButton.containsPoint(location) {
            if mute == 0 {  //MUTE IT
                muteIt()
            }
            else if mute == 1 { //UNMUTE IT
                unmuteIt()
            }
        } else if aboutButton.containsPoint(location) {//doesn't recognize AboutButton location need to fix!
            startAbout()
        } else if startLabel.containsPoint(location) {
            startGame()
        } else if rulesLabel.containsPoint(location) {
            goToRules()
        }   
    }
    
    func muteIt() {
        audioPlayer.volume = 0.0
        muteButton.texture = SKTexture(imageNamed: "muteNow.png")
        mute = 1
    }
    
    func unmuteIt() {
        audioPlayer.volume = 1
        muteButton.texture = SKTexture(imageNamed: "playNow.png")
        mute = 0
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
            
            if (mute != 1 && touchedNode.name == "launch star") {
                playMusic2("swoosh", type: "mp3")
            }
            
            touchedNode.physicsBody?.applyImpulse(CGVectorMake(100*dx, 100*dy))
        }
    }
    
    /*
    
    func followSemicircleUp() {
        let radiu = self.size.height/6
        //move on the curve up path
        let circle = UIBezierPath(arcCenter: CGPointMake(0, radiu), radius: radiu, startAngle: CGFloat(1.5*M_PI), endAngle: CGFloat(M_PI), clockwise: false)
        let test = SKAction.followPath(circle.CGPath, asOffset: true, orientToPath: true, duration: 1.5)
        triangle.runAction(test)
    }
    
    func followSemicircleDown() {
        let radiu = self.size.height/6
        //move on the curve down path
        let circle = UIBezierPath(arcCenter: CGPointMake(0, -1*radiu), radius: radiu, startAngle: CGFloat(M_PI/2), endAngle: CGFloat(M_PI), clockwise: true)
        let test = SKAction.followPath(circle.CGPath, asOffset: true, orientToPath: true, duration: 1.5)
        triangle.runAction(test)
    }

    */
    
    func startAbout() {
        let scene: SKScene = AboutScene(size: self.size)
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
    
    func animateBinsAtStart() {
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI), duration: 1.0);
        //bin_1.anchorPoint = CGPoint(x: 0, y: 1)
        topRight.runAction(rotate)
        topRight.runAction(SKAction.moveTo(CGPoint(x: self.size.width, y: self.size.height), duration: 1.0))
        
        topLeft.runAction(rotate)
        topLeft.runAction(SKAction.moveTo(CGPoint(x: 0, y: self.size.height), duration: 1.0))
        
        bottomLeft.runAction(rotate)
        bottomLeft.runAction(SKAction.moveTo(CGPoint(x: 0, y: 0), duration: 1.0))
        
        bottomRight.runAction(rotate)
        bottomRight.runAction(SKAction.moveTo(CGPoint(x: self.size.width, y: 0), duration: 1.0))
        //bin_2.runAction(SKAction.group([rotate, SKAction.moveTo(CGPoint(x: 0, y: self.size.height), duration: 1.0)]))
        //bin_3.runAction(SKAction.group([rotate, SKAction.moveTo(CGPoint(x: self.size.width, y: 0), duration: 1.0)]))
        //bin_4.runAction(SKAction.group([rotate, SKAction.moveTo(CGPoint(x: 0, y: 0), duration: 1.0)]))
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if (star.position.y >= startLabel.position.y - 20 && star.position.x <= startLabel.position.x){
            // call method to start game
            // for now just remove all the elements to show something has happened
            self.removeAllChildren();
            self.startGame();
            star.position.y = 0
        }
        else if ((star.position.y >= startLabel.position.y - 20) && (star.position.x >= aboutButton.position.x)){
                // call method to start game
                // for now just remove all the elements to show something has happened
            self.removeAllChildren();
            self.startAbout();
            star.position.y = 0
        } else if (star.position.y <= rulesLabel.position.y + rulesLabel.frame.height + 20){
            // call method to show Rules
            // for now just remove all the elements to show something has happened
            self.removeAllChildren();
            self.goToRules();
            star.position.y = 0
        }
        removeOffScreenNodes()
    }
    
    func goToRules() {
        let scene: SKScene = RulesScene(size: self.size)
        let skView = self.view as SKView!
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    func removeOffScreenNodes() {
        for shape in ["launch star"] {
            self.enumerateChildNodesWithName(shape, usingBlock: {
                node, stop in
                let sprite = node 
                if (sprite.position.y < 0 || sprite.position.x < 0 || sprite.position.x > self.size.width || sprite.position.y > self.size.height) {
                    self.star.position = CGPointMake(self.size.width/2, self.size.height/2);
                    self.star.physicsBody?.velocity = CGVectorMake(0, 0)
                }
            })
        }
    }
}
