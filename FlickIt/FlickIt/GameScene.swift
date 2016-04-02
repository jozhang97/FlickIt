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

func goToAbout() -> Void {
    print("About:")
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
    let curveUp = SKShapeNode()
    let curveDown = SKShapeNode()
    let triangle = SKShapeNode()
    let playButton = SKSpriteNode(imageNamed: "playNow.png")
    let muteButton = SKSpriteNode(imageNamed: "muteNow.png")
    let aboutButton = GGButton(defaultButtonText: "ABOUT", buttonAction: goToAbout)
    var curveUpAction = SKAction()
    var curveDownAction = SKAction()
    var audioPlayer = AVAudioPlayer()
    var mute = 0
    var pressedMute = false
    
    
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
    
    func createHomeScreen(){
        //create triangle SKShapeNode
        createTriangle()
        
        //setup Physics stuff of triangle SKShapeNode
        setupTrianglePhysics()
        
        // Create and add title to home screen
        setupTitleLabel()
        
        //curve up shape
        let radius = self.size.height/6
        addCurvedLines(curveUp, dub1: 1.5*M_PI, dub2: M_PI, bol: false, arch: Double(self.size.height/2 + radius), radi: radius)
        //curve down shape
        addCurvedLines(curveDown, dub1: M_PI/2, dub2: M_PI, bol: true, arch: Double(self.size.height/2 - radius), radi: radius)
        
        // Sets bg image to fill the entire screen
        bgImage.size = CGSize(width: self.size.width, height: self.size.height);
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        // Set up start Label
        setupStartLabel(radius)
        
        // Set up rules Label
        setupRulesLabel(radius)
        
        // Set up about Button
        aboutButton.position = CGPointMake(self.frame.width * 8/10, self.frame.height/12)
        
        //set up mute button features
        createMuteButton()
        
        //set Z-positions
        bgImage.zPosition = 1
        startLabel.zPosition = 2
        rulesLabel.zPosition = 2
        titleLabel.zPosition = 2
        aboutButton.zPosition = 2
        curveDown.zPosition = 3
        curveUp.zPosition = 3
        triangle.zPosition = 4
        muteButton.zPosition = 5
        
        // Add all the elements to the screen
        self.addChild(bgImage)
        self.addChild(triangle)
        self.addChild(curveUp)
        self.addChild(curveDown)
        self.addChild(titleLabel)
        self.addChild(rulesLabel)
        self.addChild(startLabel)
        self.addChild(aboutButton)
        self.addChild(muteButton);
        
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
    
    func addCurvedLines(curve: SKShapeNode, dub1: Double, dub2: Double, bol: Bool, arch: Double, radi: CGFloat) {
        let circlePath : UIBezierPath = UIBezierPath(arcCenter: CGPointMake(CGFloat(self.size.width/2), CGFloat(arch)), radius: radi, startAngle: CGFloat(dub1), endAngle: CGFloat(dub2), clockwise: bol)
        if curve == curveUp {
            curveUpAction = SKAction.followPath(circlePath.CGPath, asOffset: true, orientToPath: true, duration: 1)
        }
        else if curve == curveDown {
            curveDownAction = SKAction.followPath(circlePath.CGPath, asOffset: true, orientToPath: true, duration: 1)
        }
        curve.path = circlePath.CGPath
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
        let rect: CGRect = CGRectMake(0, 0, self.size.width/6, self.size.width/6)
        triangle.path = self.triangleInRect(rect)
        triangle.strokeColor = UIColor(red: 160/255, green: 80/255, blue: 76/255, alpha: 1)
        triangle.fillColor = UIColor(red: 160/255, green: 80/255, blue: 76/255, alpha: 1)
        triangle.position = CGPointMake(self.size.width/2 - triangle.frame.width/2, self.size.height/2);
        // Set names for the launcher so that we can check what node is touched in the touchesEnded method
        triangle.name = "launch triangle";
        //could randomize rotation here
        triangle.runAction(SKAction.rotateByAngle(CGFloat(M_PI/2), duration: 3))
    }
    
    func setupTrianglePhysics() {
        triangle.userInteractionEnabled = false
        triangle.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: triangle.frame.width, height: triangle.frame.height))
        triangle.physicsBody?.dynamic = true
        triangle.physicsBody?.affectedByGravity=false
    }
    
    func setupTitleLabel() {
        titleLabel.position = CGPointMake(self.size.width/2 + self.size.width/5, self.size.height/2 - titleLabel.frame.height/2);
        titleLabel.horizontalAlignmentMode = .Center
        titleLabel.fontColor = UIColor.whiteColor()
        titleLabel.fontName = "Futura"
        titleLabel.fontSize = 45
    }
    
    func setupStartLabel(rad: CGFloat) {
        startLabel.position = CGPointMake(self.size.width/2 - rad, self.size.height/2 + rad);
        startLabel.horizontalAlignmentMode = .Center
        startLabel.fontColor = UIColor.whiteColor()
        startLabel.fontName = "Futura"
        startLabel.fontSize = 30
    }
    
    func setupRulesLabel(rad: CGFloat) {
        rulesLabel.position = CGPointMake(self.size.width/2 - rad, self.size.height/2 - (rad + rulesLabel.frame.height));
        rulesLabel.horizontalAlignmentMode = .Center
        rulesLabel.fontColor = UIColor.whiteColor()
        rulesLabel.fontName = "Futura"
        rulesLabel.fontSize = 30
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
            pressedMute = true
            if mute == 0 {  //MUTE IT
                audioPlayer.volume = 0.01
                muteButton.texture = SKTexture(imageNamed: "playNow.png")
                mute = 1
            }
            else if mute == 1 { //UNMUTE IT
                audioPlayer.volume = 1
                muteButton.texture = SKTexture(imageNamed: "muteNow.png")
                mute = 0
                
            }
        }
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (!pressedMute) {
            audioPlayer.numberOfLoops = 0
            playMusic("swoosh", type: "mp3")
        }
        else {
            pressedMute = false
        }
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.locationInNode(self)
        // Determine distance from the starting point
        var dx: CGFloat = location.x - start.x
        var dy: CGFloat = location.y - start.y
        let magnitude: CGFloat = sqrt(dx * dx + dy * dy)
        
        //doesn't recognize About Button location! need to fix!
        if aboutButton.containsPoint(location) {
            print("here")
            aboutButton.action()
        }
        
        
        if (magnitude >= self.kMinDistance){
            // Determine time difference from start of the gesture
            dx = dx / magnitude
            dy = dy / magnitude
            let touchedNode=self.nodeAtPoint(start)
            //make it move
            touchedNode.physicsBody?.velocity=CGVectorMake(0.0, 0.0)
            let radiu = self.size.height/6
            if (touchedNode.name == "launch triangle" && dy > 0){
                //move on the curve up path
                
                let circle = UIBezierPath(arcCenter: CGPointMake(0, radiu), radius: radiu, startAngle: CGFloat(1.5*M_PI), endAngle: CGFloat(M_PI), clockwise: false)
                let test = SKAction.followPath(circle.CGPath, asOffset: true, orientToPath: true, duration: 3)
                triangle.runAction(test)
                //touchedNode.physicsBody?.applyImpulse(CGVectorMake(0, 100*dy))
            }
            if (touchedNode.name == "launch triangle" && dy < 0){
                //move on the curve down path
                let circle = UIBezierPath(arcCenter: CGPointMake(0, -1*radiu), radius: radiu, startAngle: CGFloat(M_PI/2), endAngle: CGFloat(M_PI), clockwise: true)
                let test = SKAction.followPath(circle.CGPath, asOffset: true, orientToPath: true, duration: 3)
                triangle.runAction(test)
                //triangle.runAction(curveDownAction)
                //touchedNode.physicsBody?.applyImpulse(CGVectorMake(0, 100*dy))
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
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if (triangle.position.y >= startLabel.position.y - 20){
            // call method to start game
            // for now just remove all the elements to show something has happened
            self.removeAllChildren();
            self.startGame();
            triangle.position.y = 0
        }
        
        if (triangle.position.y <= rulesLabel.position.y + rulesLabel.frame.height + 20){
            // call method to show Rules
            // for now just remove all the elements to show something has happened
            self.removeAllChildren();
            triangle.position.y = 0
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
}
