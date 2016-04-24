//
//  AboutScene.swift
//  FlickIt
//
//  Created by Apple on 4/2/16.
//  Copyright © 2016 Abhi_Shaili_Jeffrey_Rohan_Ashwin. All rights reserved.
//

import AVFoundation
import SpriteKit

class AboutScene: SKScene {

    let sizeRect = UIScreen.mainScreen().applicationFrame;
    let titleLabel = SKLabelNode()
    let titleLabel1 = SKLabelNode()
    let titleLabel2 = SKLabelNode()
    var audioPlayer = AVAudioPlayer()
    let backButton = SKLabelNode()
    var groupPic = SKSpriteNode(imageNamed: "FlickItGroup.png")
    var start = 0
    let bgImage = SKSpriteNode(imageNamed: "flickitbg.png")
    
    override init(size: CGSize) {
        super.init(size: size)
        createDetailsLabel()
//        sceneHeight = sizeRect.size.height * UIScreen.mainScreen().scale;
//        sceneWidth = sizeRect.size.width * UIScreen.mainScreen().scale;
//        shapeScaleFactor = 0.14*self.size.width/bin_3_shape_width
//        createScene()
        playMusic("jcena", type: "mp3")
        trackAbout()
    }
    
    func trackAbout() {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "About Screen")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        let event = GAIDictionaryBuilder.createEventWithCategory("Action", action: "Opened About", label: nil, value: nil)
        tracker.send(event.build() as [NSObject : AnyObject])
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
    
    func createDetailsLabel() {
        titleLabel.text = "This app was made by Ashwin Vaidyanathan,"
        titleLabel.position = CGPointMake(self.frame.width/2, self.frame.height * 4.25/5)
        titleLabel.horizontalAlignmentMode = .Center
        titleLabel.fontColor = UIColor.whiteColor()
        titleLabel.fontName = "BigNoodleTitling"
        titleLabel.fontSize = 20
        titleLabel.zPosition = 3
        
        titleLabel1.text = "Abhi Mangla, Rohan Narayan, Shaili"
        titleLabel1.position = CGPointMake(self.frame.width/2, self.frame.height * 4.25/5 - 20)
        titleLabel1.horizontalAlignmentMode = .Center
        titleLabel1.fontColor = UIColor.whiteColor()
        titleLabel1.fontName = "BigNoodleTitling"
        titleLabel1.fontSize = 20
        titleLabel1.zPosition = 3
        
        titleLabel2.text = "Patel, and Jeffrey Zhang."
        titleLabel2.position = CGPointMake(self.frame.width/2, self.frame.height * 4.25/5 - 40)
        titleLabel2.horizontalAlignmentMode = .Center
        titleLabel2.fontColor = UIColor.whiteColor()
        titleLabel2.fontName = "BigNoodleTitling"
        titleLabel2.fontSize = 20
        titleLabel2.zPosition = 3
        
        groupPic.position = CGPointMake(self.frame.width/2, self.frame.height/2)
        groupPic.xScale = 0.3
        groupPic.yScale = 0.3
        self.addChild(groupPic)
        
        backButton.text = "BACK"
        backButton.position = CGPointMake(self.frame.width/8, self.frame.height * 7.5/8)
        backButton.horizontalAlignmentMode = .Center
        backButton.fontColor = UIColor.whiteColor()
        backButton.fontName = "BigNoodleTitling"
        backButton.fontSize = 20
        backButton.zPosition = 3
        
        bgImage.size = CGSize(width: self.size.width, height: self.size.height);
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        bgImage.zPosition = 0;
        
        self.addChild(titleLabel)
        self.addChild(titleLabel1)
        self.addChild(titleLabel2)
        self.addChild(backButton)
        self.addChild(bgImage)
        setUpsuggestionLabel()
        setUpContactTitle()
        
    }
    
    let suggestionLabel = SKLabelNode()
    func setUpsuggestionLabel() {
        suggestionLabel.text = "ANY SUGGESTIONS OR CONCERNS?"
        suggestionLabel.position = CGPointMake(self.frame.width/2, self.frame.height * 2.5/8)
        suggestionLabel.horizontalAlignmentMode = .Center
        suggestionLabel.fontColor = UIColor.whiteColor()
        suggestionLabel.fontName = "BigNoodleTitling"
        suggestionLabel.fontSize = 20
        suggestionLabel.zPosition = 3
        self.addChild(suggestionLabel)
    }
    
    let contactTitle = SKLabelNode()
    func setUpContactTitle() {
        contactTitle.text = "CONTACT US AT FlickItTeam@GMAIL.COM"
        contactTitle.position = CGPointMake(self.frame.width/2, self.frame.height * 2/8)
        contactTitle.horizontalAlignmentMode = .Center
        contactTitle.fontColor = UIColor.whiteColor()
        contactTitle.fontName = "BigNoodleTitling"
        contactTitle.fontSize = 20
        contactTitle.zPosition = 3
        self.addChild(contactTitle)
    }
    
    func returnMain() {
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.locationInNode(self)
        // Save start location and time
        if backButton.containsPoint(location) {
            returnMain()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



}