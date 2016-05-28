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
    let storeButton = SKLabelNode(text: "Items Inventory")
    let inventoryButton = SKLabelNode(text: "Your Inventory")
    var highScoreSubview = UIView()
    var highScoreScene = SKScene()
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
        else if storeButton.containsPoint(location) {
            storeButton.fontColor = UIColor.grayColor()
        }
        else if inventoryButton.containsPoint(location) {
            inventoryButton.fontColor = UIColor.grayColor()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch ends */
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.locationInNode(self)
        // Save end location and time
        if backButton.containsPoint(location) {
            highScoreSubview.removeFromSuperview()
            returnMain()
            
        }
        else if highScoreButton.containsPoint(location) {
            
            openHighScoreSubview()
        }
        else if shareButton.containsPoint(location) {
            
            openShareSubview()
        }
        else if storeButton.containsPoint(location) {
            
            openStoreSubview()
        }
        else if inventoryButton.containsPoint(location) {
            
            openInventorySubview()
        }
        backButton.fontColor = UIColor.whiteColor()
        highScoreButton.fontColor = UIColor.whiteColor()
        shareButton.fontColor = UIColor.whiteColor()
        storeButton.fontColor = UIColor.whiteColor()
        inventoryButton.fontColor = UIColor.whiteColor()
//        if (!highScoreSubview.frame.containsPoint(location)) {
//            
//        }
    }
    
    func setOriginalScener(scene: SKScene) {
        originalScene = scene
    }
    
    func openStoreSubview() {
        print("show the store to purchase powerups")
    }
    
    func openInventorySubview() {
        print("show the user's inventory of powerups")
    }
    
    func openHighScoreSubview() {
        print("show cool high scores table with local, state, and national level maybe")
        let prevHighScore: Int = NSUserDefaults.standardUserDefaults().integerForKey("score")
        highScoreSubview = UIView(frame: CGRectMake(1/7*view!.frame.size.width, 1/5*view!.frame.size.height, 5/7*view!.frame.size.width, 3/5*view!.frame.size.height))
        highScoreSubview.backgroundColor = UIColor.whiteColor()
        
        let it = NSArray(array: ["Local", "National", "World"])
        let segmentedCont = UISegmentedControl(items: it as [AnyObject])
        
        segmentedCont.frame = CGRectMake(1/7*self.view!.frame.size.width, 1/5*view!.frame.size.height, 5/7*view!.frame.size.width, 1/5*view!.frame.size.height)
        highScoreSubview.addSubview(segmentedCont)
        
        
        self.view?.addSubview(highScoreSubview)
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
        
        storeButton.position = CGPointMake(self.frame.size.width/2, self.frame.size.height*4/10);
        storeButton.horizontalAlignmentMode = .Center
        storeButton.fontColor = UIColor.whiteColor()
        storeButton.fontName = "BigNoodleTitling"
        storeButton.fontSize = 50
        self.addChild(storeButton)
        
        inventoryButton.position = CGPointMake(self.frame.size.width/2, self.frame.size.height*3/10);
        inventoryButton.horizontalAlignmentMode = .Center
        inventoryButton.fontColor = UIColor.whiteColor()
        inventoryButton.fontName = "BigNoodleTitling"
        inventoryButton.fontSize = 50
        self.addChild(inventoryButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
