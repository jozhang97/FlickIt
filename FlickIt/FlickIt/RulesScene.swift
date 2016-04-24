//
//  RulesScene.swift
//  FlickIt
//
//  Created by Shaili Patel on 2/27/16.
//  Copyright © 2016 Abhi_Shaili_Jeffrey_Rohan_Ashwin. All rights reserved.
//

import SpriteKit
import MediaPlayer
import AVFoundation
import Foundation

class RulesScene: SKScene {
    var moviePlayer: MPMoviePlayerController?
    //keep track of which way user swipes
    var numTouches = 0;
    //create caption for "how to play" screenshots
    var caption: SKLabelNode = SKLabelNode(fontNamed: "BigNoodleTitling")
    var total = 6; //change this based on number of screens
    var rules: SKLabelNode = SKLabelNode(fontNamed: "BigNoodleTitling")
//    var screenImage: SKSpriteNode = SKSpriteNode(imageNamed: "blue_triangle")
    var start = CGPoint();
    var swipe = UISwipeGestureRecognizer();
    var bgImage = SKSpriteNode(imageNamed: "flickitbg")
    var i = 0;
    var timer: NSTimer = NSTimer()
    var strings = ["There's 4 basic shapes that will enter the screen...", "Flick them into the proper bins they belong to!", "Earn as many points as you can with 3 lives!", "Avoid bombs and use hearts to get extra lives!", "Swipe to Play"]
    
    
    override init(size: CGSize) {
        super.init(size: size)
        createScene()
    }

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func createScene () {
        numTouches = 0;
        rules.text = "How to Play"
        rules.color = UIColor.yellowColor()
        rules.position = CGPoint(x: self.frame.width/2, y: self.frame.height*1/4)
        rules.fontSize = 40
        rules.zPosition = 3
        self.addChild(rules)
        
        caption.text = strings[0]
        caption.color = UIColor.yellowColor()
        caption.position = CGPoint(x: self.frame.width/2, y: self.frame.height*3/4)
        caption.fontSize = 20
        caption.zPosition = 1
        self.addChild(caption)
        
        playVideo()
        
        bgImage.size = CGSize(width: self.size.width, height: self.size.height);
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        bgImage.zPosition = 0;
        
        self.addChild(bgImage)

        timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("changeTextMethod"), userInfo: nil, repeats: true)
        //should put a pause of 10 seconds here for flicking period
        
        addSwipe()
        track()
        
    }
    
    func changeTextMethod () {
        i += 1
        //        if strings[0] == strings[i % strings.count] {
        //            timer.invalidate()
        //            i = 0
        //            self.timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("changeTextMethod"), userInfo: nil, repeats: true)
        //        }
        caption.text = strings[i % strings.count]
    }
    
    
    func playVideo() {
        let fileURL: NSURL = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("FlickItDemo", ofType: "mp4")!)
        let player = AVPlayer(URL: fileURL)
        player.actionAtItemEnd = AVPlayerActionAtItemEnd.None
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: "playerItemDidReachEnd:",
                                                         name: AVPlayerItemDidPlayToEndTimeNotification,
                                                         object: player.currentItem)
        let video2 = SKVideoNode(AVPlayer: player)
        video2.position = CGPoint(x: self.size.width * 1/2, y: self.size.height * 1/2)
        video2.zPosition = 1
        video2.setScale(0.64)
        self.addChild(video2)
        video2.play()
    }
    

    func playerItemDidReachEnd(notification: NSNotification) {
        if let playerItem: AVPlayerItem = notification.object as? AVPlayerItem {
            playerItem.seekToTime(kCMTimeZero)
        }
    }

    func track() {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Rule Screen")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        let event = GAIDictionaryBuilder.createEventWithCategory("Action", action: "Opened rules", label: nil, value: nil)
        tracker.send(event.build() as [NSObject : AnyObject])
    }
    
    func setCaptionText () {
//        if (numTouches == 0) {
//            caption.text = "There's 4 basic shapes that will enter the screen..."
////            self.addChild(caption)
////            screenImage.texture = SKTexture(imageNamed: "blue_triangle")
//        } else if (numTouches == 1) {
//            caption.text = "Flick them into the proper bins they belong to!"
////            self.addChild(caption)
////            screenImage.texture = SKTexture(imageNamed: "blue_circle")
//        } else if (numTouches == 2) {
//            caption.text = "Earn as many points as you can with 3 lives!"
////            self.addChild(caption)
////            screenImage.texture = SKTexture(imageNamed: "blue_star")
//        } else if (numTouches == 3) {
//            caption.text = "Avoid bombs and use stars to get extra points!"
////            self.addChild(caption)
////            screenImage.texture = SKTexture(imageNamed: "blue_square")
//        } else if (numTouches == 4) {
//            caption.text = "Swipe to Play"
////            self.addChild(caption)
////            screenImage.texture = SKTexture(imageNamed: "blue_triangle")
//        } else {

        if (numTouches != 0) {
            let scene: SKScene = StartGameScene(size: self.size)
            numTouches = 0
            
            // Configure the view.
            self.removeAllChildren()
            let skView = self.view as SKView!
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            
        }
    }
    
    
    func addSwipe() {
        swipe =  UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        let directions: [UISwipeGestureRecognizerDirection] = [.Right, .Left]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
            gesture.direction = direction
            self.view?.addGestureRecognizer(gesture)
        }
    }
    
    func handleSwipe(sender: UISwipeGestureRecognizer) {
        print(sender.direction)
        if (sender.direction == .Left && numTouches < total){
            print("Left")
            numTouches += 1
        } else if (sender.direction == .Right && numTouches > 0) {
            print("right")
            numTouches -= 1
        }
        setCaptionText();
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.locationInNode(self)
        start = location
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.locationInNode(self)
        if (start.x - location.x < 0) {
            swipe.direction = .Right;
            handleSwipe(swipe)
        } else if (start.x - location.x > 0) {
            swipe.direction = .Left
            handleSwipe(swipe)
        }
        start = CGPoint(x: self.size.width/2, y: self.size.height/2)
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
}



