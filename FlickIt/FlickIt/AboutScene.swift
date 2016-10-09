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
    
    let sizeRect = UIScreen.main.applicationFrame;
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
        selfSizeWidth = sizeRect.size.height * UIScreen.main.scale;
        selfSizeHeight = sizeRect.size.width * UIScreen.main.scale;
        createDetailsLabel()
        trackAbout()
    }
    
    func trackAbout() {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "About Screen")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker?.send(builder?.build() as? [AnyHashable: Any] ?? [:])
        let event = GAIDictionaryBuilder.createEvent(withCategory: "Action", action: "Opened About", label: nil, value: nil)
        tracker?.send(event?.build() as? [AnyHashable: Any] ?? [:])    }
    
    func createDetailsLabel() {
        titleLabel.text = "This app was made by Ashwin Vaidyanathan,"
        titleLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 4.25/5)
        titleLabel.horizontalAlignmentMode = .center
        titleLabel.fontColor = UIColor.white
        titleLabel.fontName = "BigNoodleTitling"
        titleLabel.fontSize = 20
        titleLabel.zPosition = 3
        
        titleLabel1.text = "Abhi Mangla, Rohan Narayan, Shaili"
        titleLabel1.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 4/5)
        titleLabel1.horizontalAlignmentMode = .center
        titleLabel1.fontColor = UIColor.white
        titleLabel1.fontName = "BigNoodleTitling"
        titleLabel1.fontSize = 20
        titleLabel1.zPosition = 3
        
        titleLabel2.text = "Patel, and Jeffrey Zhang."
        titleLabel2.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 3.75/5)
        titleLabel2.horizontalAlignmentMode = .center
        titleLabel2.fontColor = UIColor.white
        titleLabel2.fontName = "BigNoodleTitling"
        titleLabel2.fontSize = 20
        titleLabel2.zPosition = 3
        
        groupPic.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        groupPic.xScale = 0.3
        groupPic.yScale = 0.3
        groupPic.zPosition = 3
        self.addChild(groupPic)
        
        backButton.text = "BACK"
        backButton.position = CGPoint(x: self.frame.width/8, y: self.frame.height * 7.5/8)
        backButton.horizontalAlignmentMode = .center
        backButton.fontColor = UIColor.white
        backButton.fontName = "BigNoodleTitling"
        backButton.fontSize = 30
        backButton.zPosition = 3
        
        bgImage.size = CGSize(width: self.size.width, height: self.size.height);
        bgImage.position = CGPoint(x: self.size.width/2, y: self.size.height/2);
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
        suggestionLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 2/8)
        suggestionLabel.horizontalAlignmentMode = .center
        suggestionLabel.fontColor = UIColor.white
        suggestionLabel.fontName = "BigNoodleTitling"
        suggestionLabel.fontSize = 20
        suggestionLabel.zPosition = 3
        self.addChild(suggestionLabel)
    }
    
    let contactTitle = SKLabelNode()
    func setUpContactTitle() {
        contactTitle.text = "CONTACT US AT FlickItTeam@GMAIL.COM"
        contactTitle.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 1.5/8)
        contactTitle.horizontalAlignmentMode = .center
        contactTitle.fontColor = UIColor.white
        contactTitle.fontName = "BigNoodleTitling"
        contactTitle.fontSize = 20
        contactTitle.zPosition = 3
        self.addChild(contactTitle)
    }
    
    let musicLabel = SKLabelNode()
    let musicLabel2 = SKLabelNode()
    func setUpMusicLabel() {
        musicLabel.text = "Music: http://www.bensound.com"
        musicLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 1/8)
        musicLabel.horizontalAlignmentMode = .center
        musicLabel.fontColor = UIColor.white
        musicLabel.fontName = "BigNoodleTitling"
        musicLabel.fontSize = 20
        musicLabel.zPosition = 3
        self.addChild(musicLabel)
        
        musicLabel2.text = "Licensed under Creative Commons"
        musicLabel2.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.5/8)
        musicLabel2.horizontalAlignmentMode = .center
        musicLabel2.fontColor = UIColor.white
        musicLabel2.fontName = "BigNoodleTitling"
        musicLabel2.fontSize = 20
        musicLabel2.zPosition = 3
        self.addChild(musicLabel2)
    }
    
    func returnMain() {
        let scene: SKScene = GameScene(size: self.size)
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.location(in: self)
        // Save start location and time
        if backButton.contains(location) {
            returnMain()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
