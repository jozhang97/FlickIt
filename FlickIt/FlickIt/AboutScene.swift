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
    let groupPic = SKSpriteNode(imageNamed: "FlickItGroup.png")
    var start = 0
    let bgImage = SKSpriteNode(imageNamed: "flickitbg.png")
    var selfSizeWidth = CGFloat(0)
    var selfSizeHeight = CGFloat(0)
    override init(size: CGSize) {
        super.init(size: size)
        selfSizeWidth = sizeRect.size.height * UIScreen.mainScreen().scale;
        selfSizeHeight = sizeRect.size.width * UIScreen.mainScreen().scale;
        createDetailsLabel()
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
    
    func createDetailsLabel() {
        titleLabel.text = "This app was made by Ashwin Vaidyanathan,"
        titleLabel.position = CGPointMake(self.frame.width/2, self.frame.height * 4.25/5)
        titleLabel.horizontalAlignmentMode = .Center
        titleLabel.fontColor = UIColor.whiteColor()
        titleLabel.fontName = "BigNoodleTitling"
        titleLabel.fontSize = 20
        titleLabel.zPosition = 3
        
        titleLabel1.text = "Abhi Mangla, Rohan Narayan, Shaili"
        titleLabel1.position = CGPointMake(self.frame.width/2, self.frame.height * 4/5)
        titleLabel1.horizontalAlignmentMode = .Center
        titleLabel1.fontColor = UIColor.whiteColor()
        titleLabel1.fontName = "BigNoodleTitling"
        titleLabel1.fontSize = 20
        titleLabel1.zPosition = 3
        
        titleLabel2.text = "Patel, and Jeffrey Zhang."
        titleLabel2.position = CGPointMake(self.frame.width/2, self.frame.height * 3.75/5)
        titleLabel2.horizontalAlignmentMode = .Center
        titleLabel2.fontColor = UIColor.whiteColor()
        titleLabel2.fontName = "BigNoodleTitling"
        titleLabel2.fontSize = 20
        titleLabel2.zPosition = 3
        
        groupPic.position = CGPointMake(self.size.width/2, self.size.height/2)
        groupPic.xScale = 0.3
        groupPic.yScale = 0.3
        groupPic.zPosition = 3
        self.addChild(groupPic)
        
        backButton.text = "BACK"
        backButton.position = CGPointMake(self.frame.width/8, self.frame.height * 7.5/8)
        backButton.horizontalAlignmentMode = .Center
        backButton.fontColor = UIColor.whiteColor()
        backButton.fontName = "BigNoodleTitling"
        backButton.fontSize = 30
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
        setUpMusicLabel()
        
    }
    
    let suggestionLabel = SKLabelNode()
    func setUpsuggestionLabel() {
        suggestionLabel.text = "ANY SUGGESTIONS OR CONCERNS?"
        suggestionLabel.position = CGPointMake(self.frame.width/2, self.frame.height * 2/8)
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
        contactTitle.position = CGPointMake(self.frame.width/2, self.frame.height * 1.5/8)
        contactTitle.horizontalAlignmentMode = .Center
        contactTitle.fontColor = UIColor.whiteColor()
        contactTitle.fontName = "BigNoodleTitling"
        contactTitle.fontSize = 20
        contactTitle.zPosition = 3
        self.addChild(contactTitle)
    }
    
    let musicLabel = SKLabelNode()
    let musicLabel2 = SKLabelNode()
    func setUpMusicLabel() {
        musicLabel.text = "Music: http://www.bensound.com"
        musicLabel.position = CGPointMake(self.frame.width/2, self.frame.height * 1/8)
        musicLabel.horizontalAlignmentMode = .Center
        musicLabel.fontColor = UIColor.whiteColor()
        musicLabel.fontName = "BigNoodleTitling"
        musicLabel.fontSize = 20
        musicLabel.zPosition = 3
        self.addChild(musicLabel)
        
        musicLabel2.text = "Licensed under Creative Commons"
        musicLabel2.position = CGPointMake(self.frame.width/2, self.frame.height * 0.5/8)
        musicLabel2.horizontalAlignmentMode = .Center
        musicLabel2.fontColor = UIColor.whiteColor()
        musicLabel2.fontName = "BigNoodleTitling"
        musicLabel2.fontSize = 20
        musicLabel2.zPosition = 3
        self.addChild(musicLabel2)
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