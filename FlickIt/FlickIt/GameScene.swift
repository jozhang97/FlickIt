//  GameScene.swift
//  FlickIt
//
//  Created by Jeffrey Zhang on 2/13/16.
//  Copyright (c) 2016 Abhi_Shaili_Jeffrey_Rohan_Ashwin. All rights reserved.
//

import SpriteKit
import AVFoundation
import GameKit

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
    
    var hand = SKSpriteNode(imageNamed: "hand_icon")
    
    //variables that construct the Home Game Scene
    let titleLabel = SKLabelNode(text: "FLICK IT")
    let startIcon = SKSpriteNode(imageNamed: "playIcon.png")
    let aboutIcon = SKSpriteNode(imageNamed: "aboutIcon.png")
    let rulesIcon = SKSpriteNode(imageNamed: "rulesIcon.png")
    let topLeft = SKShapeNode()
    let topRight = SKShapeNode()
    let bottomLeft = SKShapeNode()
    let bottomRight = SKShapeNode()
    let star = SKShapeNode()
    
    //colors
    let red: UIColor = UIColor(red: 164/255, green: 84/255, blue: 80/255, alpha: 1)
    let blue: UIColor = UIColor(red: 85/255, green: 135/255, blue: 141/255, alpha: 1)
    let green: UIColor = UIColor(red: 147/255, green: 158/255, blue: 106/255, alpha: 1)
    let purple: UIColor = UIColor(red: 99/255, green: 103/255, blue: 211/255, alpha: 1)
    let yellow: UIColor = UIColor(red: 250/255, green: 235/255, blue: 83/255, alpha: 1)
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var muteButton = SKSpriteNode(imageNamed: "playNow.png")
    var audioPlayer = AVAudioPlayer()
    var firstCounter = 0
    
    override func didMoveToView(view: SKView) {
        createHomeScreen()
        playMusic("intromusic", type: "mp3")
    }
    
    func checkMute() {
        if (appDelegate.muted == true) {
            self.audioPlayer.volume = 0
        }
        else {
            self.audioPlayer.volume = 1
        }
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
        checkMute()
        audioPlayer.play()
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
        if (appDelegate.muted == true) {
            muteButton = SKSpriteNode(imageNamed: "muteNow.png")
        }
        else {
            muteButton = SKSpriteNode(imageNamed: "playNow.png")
        }
        
        trackHome()
        
        //create triangle SKShapeNode
        createStar()
        
        //setup Physics stuff of triangle SKShapeNode
        setupStarPhysics()
        
        // Create and add title to home screen
        setupTitleLabel()
        
        //curve up shape
        
        let radius = self.size.height/6
        
        addCurvedLines(topRight, dub1: 0, dub2: M_PI/2, bol: true, arch: Double(self.view!.bounds.height/2 + radius), radi: radius, color: red)
        //curve down shape
        addCurvedLines(topLeft, dub1: M_PI/2, dub2: M_PI, bol: true, arch: Double(self.view!.bounds.height/2 - radius), radi: radius, color: blue)
        addCurvedLines(bottomLeft, dub1: M_PI, dub2: M_PI*3/2, bol: true, arch: Double(self.view!.bounds.height/2  - radius), radi: radius, color: green)
        addCurvedLines(bottomRight, dub1: M_PI*3/2, dub2: M_PI*2, bol: true, arch: Double(self.view!.bounds.height/2  - radius), radi: radius, color: purple)
        
        
        // Sets bg image to fill the entire screen
        self.view!.backgroundColor = UIColor.blackColor()
//        bgImage.size = CGSize(width: self.size.width, height: self.size.height);
//        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        // Set up start Label
        setupStartLabel(radius)
        
        // Set up rules Label
        setupRulesLabel(radius)
        
        // Set up about Button
        setupAboutLabel()
        
        //set up mute button features
        createMuteButton()
        
        //set Z-positions
        startIcon.zPosition = 3
        titleLabel.zPosition = 3
        topLeft.zPosition = 3
        topRight.zPosition = 3
        bottomLeft.zPosition = 3
        bottomRight.zPosition = 3
        aboutIcon.zPosition = 3
        muteButton.zPosition = 3
        star.zPosition = 4
        
        // Add all the elements to the screen
        self.addChild(star)
        self.addChild(topRight)
        self.addChild(topLeft)
        self.addChild(bottomLeft)
        self.addChild(bottomRight)
        self.addChild(titleLabel)
        self.addChild(rulesIcon)
        self.addChild(startIcon)
        self.addChild(muteButton)
        self.addChild(aboutIcon)
        delay(0.1) {
            self.animateBinsAtStart()
            self.delay(3) {
                let fadeAction = SKAction.fadeAlphaTo(1, duration: 2)
                let growAction = SKAction.scaleBy(1.5, duration: 1)
                let shrinkAction = SKAction.scaleBy(0.8333, duration: 1)
                let growAndShrink = SKAction.sequence([growAction, shrinkAction])
                var moveLabel: SKAction = SKAction.moveByX(0.0, y: -1*self.size.width*2.5/4, duration: 1.2)
                self.titleLabel.runAction(growAndShrink)
                self.titleLabel.runAction(fadeAction)
                self.titleLabel.runAction(moveLabel)
            }
        }
    }
    
    func setupAboutLabel() {
        aboutIcon.position = CGPointMake(self.size.width*9/10, self.size.height*18.5/20)
        aboutIcon.xScale = 0.10
        aboutIcon.yScale = 0.10
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
    
    func createStar() {
        let rect: CGRect = CGRectMake(0, 0, self.size.width/6, self.size.width/6)
        star.path = self.starPath(0, y: 0, radius: rect.size.width/3, sides: 5, pointyness: 2)
        star.strokeColor = yellow
        star.fillColor = yellow
        star.position = CGPointMake(self.size.width/2, self.size.height/2);
        // Set names for the launcher so that we can check what node is touched in the touchesEnded method
        star.name = "launch star";
        //could randomize rotation here
        star.runAction(SKAction.rotateByAngle(CGFloat(2*M_PI), duration: 5))
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
        titleLabel.fontName = "BigNoodleTitling"
        titleLabel.fontSize = 50
        let fadeAction = SKAction.fadeAlphaTo(0, duration: 0.1)
        titleLabel.runAction(fadeAction)
    }
    
    func setupStartLabel(rad: CGFloat) {
        startIcon.position = CGPointMake(self.size.width/8, self.size.height*18.5/20)
        startIcon.xScale = 0.30
        startIcon.yScale = 0.30
    }
    
    func setupRulesLabel(rad: CGFloat) {
        rulesIcon.position = CGPointMake(self.size.width*9/10, self.size.height*1/12)
        rulesIcon.xScale = 0.10
        rulesIcon.yScale = 0.10
    }
    
    func createMuteButton() {
        muteButton.position = CGPoint(x: self.size.width/10, y: self.size.height/12)
        muteButton.size = CGSize(width: self.size.width/5, height: self.size.height/10);
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.locationInNode(self)
        // Save start location and time
        start = location
        startTime = touch.timestamp
        
        if muteButton.containsPoint(location) {
            if appDelegate.muted == false {  //MUTE IT
                muteIt()
            }
            else if appDelegate.muted == true { //UNMUTE IT
                unmuteIt()
            }
        } else if aboutIcon.containsPoint(location) {
            startAbout()
        } else if startIcon.containsPoint(location) {
            startGame()
        } else if rulesIcon.containsPoint(location) {
            goToRules()
        }   
    }
    
    func muteIt() {
        appDelegate.muted = true
        muteButton.texture = SKTexture(imageNamed: "muteNow.png")
        checkMute()
    }
    
    func unmuteIt() {
        appDelegate.muted = false
        muteButton.texture = SKTexture(imageNamed: "playNow.png")
        checkMute()
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
            touchedNode.physicsBody?.applyImpulse(CGVectorMake(100*dx, 100*dy))
        }
    }
    
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
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI), duration: 0.3);
        //bin_1.anchorPoint = CGPoint(x: 0, y: 1)
        topRight.runAction(rotate)
        topRight.runAction(SKAction.moveTo(CGPoint(x: self.size.width, y: self.size.height), duration: 0.3))
        
        topLeft.runAction(rotate)
        topLeft.runAction(SKAction.moveTo(CGPoint(x: 0, y: self.size.height), duration: 0.3))
        
        bottomLeft.runAction(rotate)
        bottomLeft.runAction(SKAction.moveTo(CGPoint(x: 0, y: 0), duration: 0.3))
        
        bottomRight.runAction(rotate)
        bottomRight.runAction(SKAction.moveTo(CGPoint(x: self.size.width, y: 0), duration: 0.3))
    }
    
    let timeBeforeHandAppears = 5.0
    var time = 0.0
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        let bool1 = star.position.y + star.frame.height/2 >= startIcon.position.y - startIcon.frame.height/2
        let bool2 = star.position.x - star.frame.width/2 <= startIcon.position.x + startIcon.frame.width/2
        if (bool1 && bool2){
            // call method to start game
            // for now just remove all the elements to show something has happened
            self.removeAllChildren();
            self.startGame();
            star.position.y = 0
        } else if ((star.position.y >= startIcon.position.y - 20) && (star.position.x >= aboutIcon.position.x)){
                // call method to start game
                // for now just remove all the elements to show something has happened
            self.removeAllChildren();
            self.startAbout();
            star.position.y = 0
        } else if (star.position.y - star.frame.height/2 <= rulesIcon.position.y && star.position.x - star.frame.width/2 <= self.size.width && star.position.x + star.frame.width/2 >= rulesIcon.position.x - rulesIcon.frame.width/2){
            // call method to show Rules
            // for now just remove all the elements to show something has happened
            self.removeAllChildren();
            self.goToRules();
            star.position.y = 0
        } else if (star.position.y - star.frame.height/2 <= muteButton.position.y && star.position.x - star.frame.width/2 >= 0 && star.position.x + star.frame.width/2 <= muteButton.position.x + muteButton.frame.width){
            //then mute
            if appDelegate.muted == false {  //MUTE IT
                muteIt()
            }
            else if appDelegate.muted == true { //UNMUTE IT
                unmuteIt()
            }
            
        }
        removeOffScreenNodes()
        if (currentTime - time >= timeBeforeHandAppears) {
            moveHand()
            time = currentTime
        }
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
    
    func authPlayerGameCenter() {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {
            (view, error) in
            if view != nil {
                let vc = self.view!.window?.rootViewController
                vc!.presentViewController(view!, animated: true, completion: nil)
            }
            else {
                print(GKLocalPlayer.localPlayer().authenticated)
                
            }
        }
    }
    
    func moveHand() {
        if firstCounter == 0 {
            firstCounter += 1
            return;
        }
        self.hand.removeFromParent()
        self.hand.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.hand.xScale = 0.30
        self.hand.yScale = 0.30
        self.hand.zPosition = 3
        self.addChild(self.hand)
        let move = SKAction.moveTo(CGPoint(x: self.size.width * 6 / 8, y: self.size.height * 2 / 8), duration: 1)
        let remove = SKAction.removeFromParent()
        self.hand.runAction(SKAction.sequence([move, remove]))
    }
}
