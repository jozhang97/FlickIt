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
    let highScoreButton = SKLabelNode(text: "See My HighScore")
    let shareButton = SKLabelNode(text: "Share with Friends")
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
        scene.scaleMode = .AspectFill
        scene.size  = skView.bounds.size
        skView.presentScene(scene)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.locationInNode(self)
        // Save start location and time
        if backButton.containsPoint(location) {
            backButton.fontColor = UIColor.grayColor()
            
        }
        else if highScoreButton.containsPoint(location) {
            highScoreButton.fontColor = UIColor.grayColor()
        }
        else if shareButton.containsPoint(location) {
            shareButton.fontColor = UIColor.grayColor()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch ends */
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.locationInNode(self)
        // Save end location and time
        if backButton.containsPoint(location) {
            backButton.fontColor = UIColor.whiteColor()
            returnMain()
            
        }
        else if highScoreButton.containsPoint(location) {
            highScoreButton.fontColor = UIColor.whiteColor()
            openHighScoreSubview()
        }
        else if shareButton.containsPoint(location) {
            shareButton.fontColor = UIColor.whiteColor()
            openShareSubview()
        }
    }
    
    func setOriginalScener(scene: SKScene) {
        originalScene = scene
    }
    
    func openHighScoreSubview() {
        print("show cool high scores table with local, state, and national level maybe")
    }
    
    func openShareSubview() {
        print("show subview that gives user options to share on FB, google, or whatever")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        backButton.position = CGPointMake(self.frame.size.width/9, self.frame.size.height*9/10);
        backButton.horizontalAlignmentMode = .Center
        backButton.fontColor = UIColor.whiteColor()
        backButton.fontName = "BigNoodleTitling"
        backButton.fontSize = 50
        self.addChild(backButton)
        
        highScoreButton.position = CGPointMake(self.frame.size.width/2, self.frame.size.height*6/10);
        highScoreButton.horizontalAlignmentMode = .Center
        highScoreButton.fontColor = UIColor.whiteColor()
        highScoreButton.fontName = "BigNoodleTitling"
        highScoreButton.fontSize = 50
        self.addChild(highScoreButton)
        
        shareButton.position = CGPointMake(self.frame.size.width/2, self.frame.size.height*5/10);
        shareButton.horizontalAlignmentMode = .Center
        shareButton.fontColor = UIColor.whiteColor()
        shareButton.fontName = "BigNoodleTitling"
        shareButton.fontSize = 50
        self.addChild(shareButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
