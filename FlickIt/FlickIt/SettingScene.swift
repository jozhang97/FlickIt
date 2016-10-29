//
//  SettingScene.swift
//  FlickIt
//
//  Created by Abhishek Mangla on 5/23/16.
//  Copyright © 2016 Abhi_Shaili_Jeffrey_Rohan_Ashwin. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class SettingScene: SKScene {
    let backButton = SKLabelNode(text: "Back")
    let resetHighScoreButton = SKLabelNode(text: "Clear Highscore")
    let muteButton = SKLabelNode()
    let settingsTitle = SKLabelNode(text: "Settings")
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var audioPlaya = AVAudioPlayer()

    /*
    let highScoreButton = SKLabelNode(text: "See My HighScore")
    let shareButton = SKLabelNode(text: "Share with Friends")
    let storeButton = SKLabelNode(text: "Items Inventory")
    let inventoryButton = SKLabelNode(text: "Your Inventory")
    var highScoreSubview = UIView()
    var highScoreScene = SKScene()
    */
    var originalScene = SKScene()
    
    func returnMain()
    {
        let scene = originalScene
        let skView = self.view! as SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.showsPhysics = false
        skView.showsDrawCount = false
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        //if(skView.scene == nil){
        scene.scaleMode = .aspectFill
        scene.size  = skView.bounds.size
        
        
        if isStartGameScene(scene: scene) {
            let startGameScene = scene as! StartGameScene
            startGameScene.score = 0
            /*** CAUTION
             Our desire here is to set the label on the lose screen to show "High Score: 0"
             little hackish to set score back to 0, but when we run setUpLocalHighScore, it picks the bigger of score and prevHighScore
             We do not update the score label after this is called, it stays the same and is not affected
             GameCenter gets reported the score when lose screen appears, so is not affected by this hack either
            ***/
            startGameScene.setUpLocalHighScore()
            startGameScene.trackLose()
        }
        skView.presentScene(scene)
        
    }
    
    func isStartGameScene(scene: SKScene) -> Bool {
        let sceneMirror = Mirror.init(reflecting: scene)
        return sceneMirror.subjectType == StartGameScene.self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.location(in: self)
        // Save start location and time
        if backButton.contains(location) {
            backButton.fontColor = UIColor.gray
            
        }
        /*
        else if highScoreButton.contains(location) {
            highScoreButton.fontColor = UIColor.gray
        }
        else if shareButton.contains(location) {
            shareButton.fontColor = UIColor.gray
        }
        else if storeButton.contains(location) {
            storeButton.fontColor = UIColor.gray
        }
        else if inventoryButton.contains(location) {
            inventoryButton.fontColor = UIColor.gray
        } 
        */
        else if resetHighScoreButton.contains(location) {
            resetHighScoreButton.fontColor = UIColor.gray
        } else if muteButton.contains(location) {
            muteButton.fontColor = UIColor.gray
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch ends */
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.location(in: self)
        // Save end location and time
        if backButton.contains(location) {
            // highScoreSubview.removeFromSuperview()
            returnMain()
            
        } else if muteButton.contains(location) {
            // TODO: set appdelegate.muted and make music start or end
            if appDelegate.muted == true {
                muteButton.text = "Mute"
                appDelegate.muted = false
                audioPlaya.volume = 1
            }
            else {
                muteButton.text = "Unmute"
                appDelegate.muted = true
                audioPlaya.volume = 0
            }
        } else if resetHighScoreButton.contains(location) {
            resetLocalHighScore()
        }
        
        /*
        else if highScoreButton.contains(location) {
            
            openHighScoreSubview()
        }
        else if shareButton.contains(location) {
            
            openShareSubview()
        }
        else if storeButton.contains(location) {
            
            openStoreSubview()
        }
        else if inventoryButton.contains(location) {
            
            openInventorySubview()
        }
         highScoreButton.fontColor = UIColor.white
         shareButton.fontColor = UIColor.white
         storeButton.fontColor = UIColor.white
         inventoryButton.fontColor = UIColor.white
        */
        resetHighScoreButton.fontColor = UIColor.white
        muteButton.fontColor = UIColor.white
        backButton.fontColor = UIColor.white
 
//        if (!highScoreSubview.frame.containsPoint(location)) {
//            
//        }
    }
    
    func setOriginalScener(_ scene: SKScene) {
        originalScene = scene
    }
    
    /*
    func openStoreSubview() {
        print("show the store to purchase powerups")
    }
    
    func openInventorySubview() {
        print("show the user's inventory of powerups")
    }
    
    func openHighScoreSubview() {
        print("show cool high scores table with local, state, and national level maybe")
        let prevHighScore: Int = UserDefaults.standard.integer(forKey: "score")
        highScoreSubview = UIView(frame: CGRect(x: 1/7*view!.frame.size.width, y: 1/5*view!.frame.size.height, width: 5/7*view!.frame.size.width, height: 3/5*view!.frame.size.height))
        highScoreSubview.backgroundColor = UIColor.white
        
        let it = NSArray(array: ["Local", "National", "World"])
        let segmentedCont = UISegmentedControl(items: it as [AnyObject])
        
        segmentedCont.frame = CGRect(x: 1/7*self.view!.frame.size.width, y: 1/5*view!.frame.size.height, width: 5/7*view!.frame.size.width, height: 1/5*view!.frame.size.height)
        highScoreSubview.addSubview(segmentedCont)
        
        
        self.view?.addSubview(highScoreSubview)
    }
    
    func openShareSubview() {
        print("show subview that gives user options to share on FB, google, or whatever")
    }
    */
    
    let musicLabel = SKLabelNode()
    let musicLabel2 = SKLabelNode()
    func setUpMusicLabel() {
        musicLabel.text = "Music: http://www.bensound.com"
        musicLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 1/8)
        musicLabel.horizontalAlignmentMode = .center
        musicLabel.fontColor = UIColor.white
        musicLabel.fontName = "Avenir"
        musicLabel.fontSize = 20
        musicLabel.zPosition = 3
        self.addChild(musicLabel)
        
        musicLabel2.text = "Licensed under Creative Commons"
        musicLabel2.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.5/8)
        musicLabel2.horizontalAlignmentMode = .center
        musicLabel2.fontColor = UIColor.white
        musicLabel2.fontName = "Avenir"
        musicLabel2.fontSize = 20
        musicLabel2.zPosition = 3
        self.addChild(musicLabel2)
    }
    
    init(size: CGSize, ap: AVAudioPlayer) {
        super.init(size: size)
        audioPlaya = ap
        if (appDelegate.muted == false) {
            muteButton.text = "Mute"
        }
        else {
            muteButton.text = "Unmute"
        }
        settingsTitle.position = CGPoint(x: self.frame.size.width/2, y: 3*self.frame.size.height/4)
        settingsTitle.horizontalAlignmentMode = .center
        settingsTitle.fontColor = UIColor.white
        settingsTitle.fontName = "Avenir"
        settingsTitle.fontSize = 54
        settingsTitle.zPosition = 5
        self.addChild(settingsTitle)
        
        backButton.position = CGPoint(x: self.frame.size.width/9, y: 12*self.frame.size.height/13);
        backButton.horizontalAlignmentMode = .center
        backButton.fontColor = UIColor.white
        backButton.fontName = "Avenir"
        backButton.fontSize = 24
        backButton.zPosition = 5
        self.addChild(backButton)
        
        /*
        highScoreButton.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height*6/10);
        highScoreButton.horizontalAlignmentMode = .center
        highScoreButton.fontColor = UIColor.white
        highScoreButton.fontName = "BigNoodleTitling"
        highScoreButton.fontSize = 50
        self.addChild(highScoreButton)
        
        shareButton.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height*5/10);
        shareButton.horizontalAlignmentMode = .center
        shareButton.fontColor = UIColor.white
        shareButton.fontName = "BigNoodleTitling"
        shareButton.fontSize = 50
        self.addChild(shareButton)
        
        storeButton.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height*4/10);
        storeButton.horizontalAlignmentMode = .center
        storeButton.fontColor = UIColor.white
        storeButton.fontName = "BigNoodleTitling"
        storeButton.fontSize = 50
        self.addChild(storeButton)
        */
        setUpMusicLabel()
 
        resetHighScoreButton.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height*5/10);
        resetHighScoreButton.horizontalAlignmentMode = .center
        resetHighScoreButton.fontColor = UIColor.white
        resetHighScoreButton.fontName = "Avenir"
        resetHighScoreButton.fontSize = 24
        resetHighScoreButton.zPosition = 5
        self.addChild(resetHighScoreButton)

        muteButton.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height*6/10);
        muteButton.horizontalAlignmentMode = .center
        muteButton.fontColor = UIColor.white
        muteButton.fontName = "Avenir"
        muteButton.fontSize = 24
        muteButton.zPosition = 5
        self.addChild(muteButton)
        
        createBackground()
        trackSettings()
    }
    
    func trackSettings() {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Settings Screen")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker?.send(builder?.build() as? [AnyHashable: Any] ?? [:])
        let event = GAIDictionaryBuilder.createEvent(withCategory: "Action", action: "Go To settings", label: nil, value: nil)
        tracker?.send(event?.build() as? [AnyHashable: Any] ?? [:])
    }
    
    
    func updateMuteButtonText() {
        if appDelegate.muted {
            muteButton.text = "Unmute"
        }
        else {
            muteButton.text = "Mute"
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetLocalHighScore() {
        UserDefaults.standard.set(0, forKey: "score")
        UserDefaults.standard.synchronize()
    }
    func createBackground(){
        let size = CGSize(width: screenWidth, height: screenHeight)
        let color1 = UIColor(red: 171/255.0, green: 232/255.0, blue: 243/255.0, alpha: 1.0).cgColor
        let color2 = UIColor(red: 246/255.0, green: 204/255.0, blue: 208/255.0, alpha: 1.0).cgColor
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        layer.colors = [color1, color2] // start color
        UIGraphicsBeginImageContext(size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let bg = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        UIGraphicsEndImageContext()
        let back = SKTexture.init(cgImage: bg!)
        let backnode = SKSpriteNode(texture: back, size: size)
        backnode.zPosition = 0
        backnode.position = CGPoint(x:screenWidth/2,y:screenHeight/2)
        self.addChild(backnode)
    }


}
