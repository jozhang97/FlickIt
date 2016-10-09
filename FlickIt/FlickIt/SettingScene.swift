//
//  SettingScene.swift
//  FlickIt
//
//  Created by Abhishek Mangla on 5/23/16.
//  Copyright © 2016 Abhi_Shaili_Jeffrey_Rohan_Ashwin. All rights reserved.
//

import UIKit
import SpriteKit

class SettingScene: SKScene {
    let backButton = SKLabelNode(text: "BACK")
    let resetHighScoreButton = SKLabelNode(text: "Clear my highscore")
    let muteButton = SKLabelNode()    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

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
        skView.presentScene(scene)
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
            updateMuteButtonText()
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
    
    override init(size: CGSize) {
        super.init(size: size)
        backButton.position = CGPoint(x: self.frame.size.width/9, y: self.frame.size.height*9/10);
        backButton.horizontalAlignmentMode = .center
        backButton.fontColor = UIColor.white
        backButton.fontName = "BigNoodleTitling"
        backButton.fontSize = 50
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
 
        resetHighScoreButton.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height*5/10);
        resetHighScoreButton.horizontalAlignmentMode = .center
        resetHighScoreButton.fontColor = UIColor.white
        resetHighScoreButton.fontName = "BigNoodleTitling"
        resetHighScoreButton.fontSize = 50
        self.addChild(resetHighScoreButton)

        muteButton.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height*6/10);
        muteButton.horizontalAlignmentMode = .center
        muteButton.fontColor = UIColor.white
        muteButton.fontName = "BigNoodleTitling"
        muteButton.fontSize = 50
        updateMuteButtonText()
        self.addChild(muteButton)
        
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


}
