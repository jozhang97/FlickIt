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

@available(iOS 10.0, *)
class GameScene: SKScene , SKPhysicsContactDelegate {
    //variables needed for flicking
    var start = CGPoint()
    var startTime = TimeInterval()
    let kMinDistance = CGFloat(50)
    let kMinDuration = CGFloat(0)
    let kMinSpeed = CGFloat(100)
    let kMaxSpeed = CGFloat(500)
    
    
    var hand = SKSpriteNode(imageNamed: "hand_icon")
    
    //variables that construct the Home Game Scene
    let titleLabel = SKLabelNode(text: "FLICK IT")
    let startLabel = SKLabelNode(text: "START")
    let aboutIcon = SKSpriteNode(imageNamed: "about1.png")
    let settingIcon = SKSpriteNode(imageNamed: "settings.png")
    let topLeft = SKShapeNode()
    let topRight = SKShapeNode()
    let bottomLeft = SKShapeNode()
    let bottomRight = SKShapeNode()
    let star = SKShapeNode()
    var line = SKShapeNode()
    var touching = false
    
    //colors
    let red: UIColor = UIColor(red: 164/255, green: 84/255, blue: 80/255, alpha: 1)
    let blue: UIColor = UIColor(red: 85/255, green: 135/255, blue: 141/255, alpha: 1)
    let green: UIColor = UIColor(red: 147/255, green: 158/255, blue: 106/255, alpha: 1)
    let purple: UIColor = UIColor(red: 99/255, green: 103/255, blue: 211/255, alpha: 1)
    let yellow: UIColor = UIColor(red: 250/255, green: 235/255, blue: 83/255, alpha: 1)
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var muteButton = SKSpriteNode(imageNamed: "playNow.png")
    var audioPlayer = AVAudioPlayer()
    var firstCounter = 0
    var collisionBool = false
    
    override func didMove(to view: SKView) {
        createHomeScreen()
        playMusic("bensound-straight", type: "mp3")
    }
    func checkMute() {
        if (appDelegate.muted == true) {
            self.audioPlayer.volume = 0
        }
        else {
            self.audioPlayer.volume = 1
        }
    }
    
    func playMusic(_ path: String, type: String) {
        let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: path, ofType: type)!)
        //print(alertSound)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)), mode: AVAudioSession.Mode.default)
            try AVAudioSession.sharedInstance().setActive(true)
            try audioPlayer = AVAudioPlayer(contentsOf: alertSound)
        }
        catch {
            
        }
        audioPlayer.prepareToPlay()
        audioPlayer.numberOfLoops = -1
        checkMute()
        audioPlayer.play()
    }
    
    func trackHome() {
        if Platform.testingOrNotSimulator {

        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Home Screen")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker?.send(builder?.build() as? [AnyHashable: Any] ?? [:])
        let event = GAIDictionaryBuilder.createEvent(withCategory: "Action", action: "Open App", label: nil, value: nil)
        tracker?.send(event?.build() as? [AnyHashable: Any] ?? [:])
        }
    }
    
    func createHomeScreen(){
        if (appDelegate.muted == true) {
            muteButton = SKSpriteNode(imageNamed: "muteNow.png")
        }
        else {
            muteButton = SKSpriteNode(imageNamed: "playNow.png")
        }
        
        self.physicsWorld.contactDelegate = self
        
        trackHome()
        
        //create star SKShapeNode
        createStar()
        
        //setup Physics stuff of triangle SKShapeNode
        
        // Create and add title to home screen
        setupTitleLabel()
        
        //curve up shape
        
        let radius = self.size.height/6
        
        addCurvedLines(topRight, dub1: 0, dub2: Double.pi/2, bol: true, arch: Double(self.view!.bounds.height/2 + radius), radi: radius, color: red)
        //curve down shape
        addCurvedLines(topLeft, dub1: Double.pi/2, dub2: Double.pi, bol: true, arch: Double(self.view!.bounds.height/2 - radius), radi: radius, color: blue)
        addCurvedLines(bottomLeft, dub1: Double.pi, dub2: Double.pi*3/2, bol: true, arch: Double(self.view!.bounds.height/2  - radius), radi: radius, color: green)
        addCurvedLines(bottomRight, dub1: Double.pi*3/2, dub2: Double.pi*2, bol: true, arch: Double(self.view!.bounds.height/2  - radius), radi: radius, color: purple)
        
        topRight.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        topLeft.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        bottomLeft.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        bottomRight.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        
        topRight.physicsBody?.affectedByGravity = false
        topLeft.physicsBody?.affectedByGravity = false
        bottomLeft.physicsBody?.affectedByGravity = false
        bottomRight.physicsBody?.affectedByGravity = false

        
        topRight.name = "topRight"
        topLeft.name = "topLeft"
        bottomRight.name = "bottomRight"
        bottomLeft.name = "bottomLeft"
        
        // Sets bg image to fill the entire screen
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let color1 = UIColor(red: 171/255.0, green: 232/255.0, blue: 243/255.0, alpha: 1.0).cgColor
        let color2 = UIColor(red: 246/255.0, green: 204/255.0, blue: 208/255.0, alpha: 1.0).cgColor
        //layer.zPosition = 0
        gradient.opacity = 1.0
        gradient.colors = [color1, color2]
        let nov = UIView()
        nov.layer.insertSublayer(gradient, at: 0)
        self.view?.addSubview(nov)
        //self.view?.layer.insertSublayer(layer,at: 0)
        //        self.view!.backgroundColor = UIColor.black
        //        bgImage.size = CGSize(width: self.size.width, height: self.size.height);
        //        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        
    //self.view!.backgroundColor = UIColor.black
//        bgImage.size = CGSize(width: self.size.width, height: self.size.height);
//        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        // Set up start Label
        setupStartLabel(radius)
        
        // Set up rules Label
        setupSettingIcon(radius)
        
        // Set up about Button
        setupAboutLabel()

        //set up mute button features
        createMuteButton()
        
        //set Z-positions
        titleLabel.zPosition = 3
        topLeft.zPosition = 3
        topRight.zPosition = 3
        bottomLeft.zPosition = 3
        bottomRight.zPosition = 3
        aboutIcon.zPosition = 3
        muteButton.zPosition = 3
        startLabel.zPosition = 3
        star.zPosition = 5
        self.addChild(startLabel)
        
        // Add all the elements to the screen
        self.addChild(star)
        self.addChild(topRight)
        self.addChild(topLeft)
        self.addChild(bottomLeft)
        self.addChild(bottomRight)
        self.addChild(titleLabel)
        self.addChild(settingIcon)
        self.addChild(muteButton)
        self.addChild(aboutIcon)
        delay(0.5) {
            self.animateBinsAtStart()
            self.delay(0.5) {
                let fadeAction = SKAction.fadeAlpha(to: 1, duration: 2)
                let growAction = SKAction.scale(by: 1.5, duration: 1)
                let shrinkAction = SKAction.scale(by: 0.8333, duration: 1)
                let growAndShrink = SKAction.sequence([growAction, shrinkAction])
                let moveLabel: SKAction = SKAction.moveBy(x: 0.0, y: -1*self.size.width*2.5/4, duration: 0.5)
                self.titleLabel.run(growAndShrink)
                self.titleLabel.run(fadeAction)
                self.titleLabel.run(moveLabel)
            }
        }
    }
    
    func setUpBinsPhysicsBody(_ bin: SKShapeNode) {
        bin.physicsBody?.isDynamic=false
        bin.physicsBody?.affectedByGravity = false
        bin.physicsBody?.categoryBitMask=PhysicsCategory.Bin
        bin.physicsBody?.collisionBitMask=PhysicsCategory.Shape
        bin.physicsBody?.contactTestBitMask=PhysicsCategory.Shape
    }
    
    func setupAboutLabel() {
        aboutIcon.position = CGPoint(x: self.size.width*9/10, y: self.size.height*18.5/20)
        aboutIcon.xScale = 0.17
        aboutIcon.yScale = 0.17
    }
    
    func addCurvedLines(_ curve: SKShapeNode, dub1: Double, dub2: Double, bol: Bool, arch: Double, radi: CGFloat, color: UIColor) {
        let circlePath : UIBezierPath = UIBezierPath(arcCenter: CGPoint(x: CGFloat(0), y: CGFloat(0)), radius: radi, startAngle: CGFloat(dub1), endAngle: CGFloat(dub2), clockwise: bol)
        curve.path = circlePath.cgPath
        curve.strokeColor = color
        curve.lineWidth = 3
        curve.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
    }
    
    fileprivate func pointFrom(_ angle: CGFloat, radius: CGFloat, offset: CGPoint) -> CGPoint {
        return CGPoint(x: radius * cos(angle) + offset.x, y: radius * sin(angle) + offset.y)
    }
    
    func degree2radian(_ a:CGFloat)->CGFloat {
        let b = CGFloat(Double.pi) * a/180
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
    

    func createStar() {
        let rect: CGRect = CGRect(x: 0, y: 0, width: self.size.width/6, height: self.size.width/6)
        star.path = self.starPath(0, y: 0, radius: rect.size.width/3, sides: 5, pointyness: 2)
        star.strokeColor = yellow
        star.fillColor = yellow
        star.position = CGPoint(x: self.size.width/2, y: self.size.height/2);
        // Set names for the launcher so that we can check what node is touched in the touchesEnded method
        star.name = "launchStar";
        //could randomize rotation here
        let rotation = SKAction.rotate(byAngle: CGFloat(2 * Double.pi), duration: 10)
        star.run(SKAction.repeatForever(rotation))
    }
    
    
    func setupStarPhysics() {
        star.isUserInteractionEnabled = false
        star.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: star.frame.width, height: star.frame.height))
        star.physicsBody?.isDynamic = true
        star.physicsBody?.affectedByGravity=false
        star.physicsBody?.categoryBitMask = PhysicsCategory.Shape
        star.physicsBody?.collisionBitMask=PhysicsCategory.Bin
        star.physicsBody?.contactTestBitMask=PhysicsCategory.Bin

    }
    
    func setupTitleLabel() {
        titleLabel.position = CGPoint(x: self.size.width/2, y: self.size.height - titleLabel.frame.height - 20);
        titleLabel.horizontalAlignmentMode = .center
        titleLabel.fontColor = UIColor.white
        titleLabel.fontName = "BigNoodleTitling"
        titleLabel.fontSize = 50
        let fadeAction = SKAction.fadeAlpha(to: 0, duration: 0.1)
        titleLabel.run(fadeAction)
    }
    
    func setupStartLabel(_ rad: CGFloat) {
        startLabel.position = CGPoint(x: self.size.width/8, y: self.size.height*18/20)
        startLabel.fontName = "BigNoodleTitling"
        startLabel.fontSize = 30
        
//        startIcon.xScale = 0.30
//        startIcon.yScale = 0.30
    }
    
    func setupSettingIcon(_ rad: CGFloat) {
        settingIcon.position = CGPoint(x: self.size.width*9/10, y: self.size.height*1/12)
        settingIcon.xScale = 0.8
        settingIcon.yScale = 0.8
    }
    
    func createMuteButton() {
        muteButton.position = CGPoint(x: self.size.width/10, y: self.size.height/12)
        muteButton.size = CGSize(width: self.size.width/5, height: self.size.height/10);
    }
    
    func didBegin(_ contact: SKPhysicsContact){
        if(collisionBool) {
            var firstBody=contact.bodyA
            var secondBody=contact.bodyB
            if(firstBody.categoryBitMask==PhysicsCategory.Bin && secondBody.categoryBitMask==PhysicsCategory.Shape){
                firstBody=contact.bodyB
                secondBody=contact.bodyA
            }
            if (firstBody.categoryBitMask==PhysicsCategory.Shape && secondBody.categoryBitMask==PhysicsCategory.Bin){
                if(secondBody.node!.name == "topLeft"){
                    self.removeAllChildren();
                    self.startGame();
                    self.star.position.y = 0
                }
                else if(secondBody.node!.name == "topRight"){
                    self.removeAllChildren();
                    self.startAbout();
                    self.star.position.y = 0
                }
                else if(secondBody.node!.name == "bottomLeft"){
                    if self.appDelegate.muted == false {  //MUTE IT
                        self.muteIt()
                    }
                    else if self.appDelegate.muted == true { //UNMUTE IT
                        self.unmuteIt()
                    }
                    self.star.removeFromParent()
                    self.star.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    self.star.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
                    self.addChild(star)
                }
                else if(secondBody.node!.name == "bottomRight"){
                    self.removeAllChildren();
                    self.openSettings();
                    self.star.position.y = 0
                }
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.location(in: self)
        // Save start location and time
        start = location
        startTime = touch.timestamp
        if(star.contains(location)){
            touching = true
        }
        if muteButton.contains(location) {
            if appDelegate.muted == false {  //MUTE IT
                muteIt()
            }
            else if appDelegate.muted == true { //UNMUTE IT
                unmuteIt()
            }
            self.star.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            self.star.physicsBody?.velocity = CGVector(dx: 0, dy: 0)

        } else if aboutIcon.contains(location) {
            startAbout()
        } else if startLabel.contains(location) {
            startGame()
        } else if settingIcon.contains(location) {
            openSettings()
        }   
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.atPoint(start).name != nil && touching && self.atPoint(start).physicsBody?.categoryBitMask == PhysicsCategory.Shape) {
            for touch in touches{
                self.removeChildren(in: [line])
                let currentLocation=touch.location(in: self)
                createLine(currentLocation)
                self.addChild(line)
                
            }
        }
    }
    
    func createLine(_ end: CGPoint){
        line.lineWidth=1.5
        line.path = linePath(end)
        line.fillColor = UIColor.white
        line.strokeColor = UIColor.white
        line.zPosition=4
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
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeChildren(in: [line])
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.location(in: self)
        // Determine distance from the starting point
        var dx: CGFloat = location.x - start.x
        var dy: CGFloat = location.y - start.y
        let magnitude: CGFloat = sqrt(dx * dx + dy * dy)
        
        if (magnitude >= self.kMinDistance){
            // Determine time difference from start of the gesture
            dx = dx / magnitude
            dy = dy / magnitude
            let touchedNode=self.atPoint(start)
            //make it move
            touchedNode.physicsBody?.velocity=CGVector(dx: 0.0, dy: 0.0)
            touchedNode.physicsBody?.applyImpulse(CGVector(dx: 400*dx, dy: 400*dy))
        }
        touching = false
    }
    
    func startAbout() {
        let scene: SKScene = AboutScene(size: self.size)
        // Configure the view.
        if let skView = self.view {
            skView.showsFPS = false
            skView.showsNodeCount = false
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
        }
        
    }
    
    func startGame() {
        let scene: SKScene = StartGameScene(size: self.size)
        // Configure the view.
        if let skView = self.view {
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
        }
        
    }
    
    func animateBinsAtStart() {
        let rotate = SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 0.5);
        //bin_1.anchorPoint = CGPoint(x: 0, y: 1)
        topRight.run(rotate)
        topRight.run(SKAction.move(to: CGPoint(x: self.size.width, y: self.size.height), duration: 0.5))
        
        topLeft.run(rotate)
        topLeft.run(SKAction.move(to: CGPoint(x: 0, y: self.size.height), duration: 0.5))
        
        bottomLeft.run(rotate)
        bottomLeft.run(SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.5))
        
        bottomRight.run(rotate)
        bottomRight.run(SKAction.move(to: CGPoint(x: self.size.width, y: 0), duration: 0.5))
    }
    
    let timeBeforeHandAppears = 5.0
    var time = 0.0
    var secondTime = true
    
    override func update(_ currentTime: TimeInterval) {
        if (secondTime && bottomLeft.position == CGPoint(x: 0, y: 0))  {
            collisionBool = true
            setupStarPhysics()
            setUpBinsPhysicsBody(topRight)
            setUpBinsPhysicsBody(topLeft)
            setUpBinsPhysicsBody(bottomLeft)
            setUpBinsPhysicsBody(bottomRight)
            secondTime = false
        }
        removeOffScreenNodes()
        if (currentTime - time >= timeBeforeHandAppears) {
            moveHand()
            time = currentTime
        }
    }
    
    func openSettings() {
        /*let scene = SettingScene(coder: self.size)
        scene.setOriginalScener(GameScene())
        // Configure the view.
        let skView = self.view as SKView!
        skView?.showsFPS = false
        skView?.showsNodeCount = false
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView?.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .aspectFill
        skView?.presentScene(scene)
 */
        
        
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    func removeOffScreenNodes() {
        for shape in ["launchStar"] {
            self.enumerateChildNodes(withName: shape, using: {
                node, stop in
                let sprite = node 
                if (sprite.position.y < 0 || sprite.position.x < 0 || sprite.position.x > self.size.width || sprite.position.y > self.size.height) {
                    self.star.position = CGPoint(x: self.size.width/2, y: self.size.height/2);
                    self.star.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                }
            })
        }
    }
    
    func authPlayerGameCenter() {
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = {
            (view, error) in
            if view != nil {
                let vc = self.view!.window?.rootViewController
                vc!.present(view!, animated: true, completion: nil)
            }
            else {
                //print(GKLocalPlayer.localPlayer().authenticated)
                
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
        self.hand.xScale = self.size.width / 5770 // scales to 0.065 on iphone6
        self.hand.yScale = self.size.width / 5770
        self.hand.zPosition = 3
        self.addChild(self.hand)
        let move = SKAction.move(to: CGPoint(x: self.size.width * 1 / 8, y: self.size.height * 7 / 8), duration: 1.5)
        let remove = SKAction.removeFromParent()
        self.hand.run(SKAction.sequence([move, remove]))
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
