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
    var caption: SKLabelNode = SKLabelNode(fontNamed: "Open Sans Cond Light")
    var total = 6; //change this based on number of screens
    var rules: SKLabelNode = SKLabelNode(fontNamed: "Open Sans Cond Light")
//    var screenImage: SKSpriteNode = SKSpriteNode(imageNamed: "blue_triangle")
    var start = CGPoint();
    var swipe = UISwipeGestureRecognizer();
    var bgImage = SKSpriteNode(imageNamed: "flickitbg")
    //var video: SKVideoNode = SKVideoNode(fileNamed: "FlickItDemo3")
    
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
        rules.color = UIColor.whiteColor()
        rules.position = CGPoint(x: self.frame.width/2, y: self.frame.height*3.5/4)
        rules.fontSize = 30
        rules.zPosition = 3
        self.addChild(rules)
        
        caption.text = "There's 4 basic shapes that will enter the screen..."
        caption.color = UIColor.whiteColor()
        caption.position = CGPoint(x: self.frame.width/2, y: self.frame.height*3/4)
        caption.fontSize = 16
        self.addChild(caption)
        
//        screenImage.position = CGPoint(x: self.size.width * 1/2, y: self.size.height * 1/2)
//        screenImage.size = CGSize(width: self.size.width * 2/3, height: self.size.height * 1/2)
//        self.addChild(screenImage)
//
        let fileURL: NSURL = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("FlickItDemo3", ofType: "mp4")!)
        player = AVPlayer(URL: fileURL)
        
        
        player.actionAtItemEnd =
        
        
        let action1 = SKAction.runBlock(restartVideo)
        let action = SKAction.sequence([action1, SKAction.waitForDuration(15)])
        self.addChild(video)
        SKAction.repeatActionForever(action)
    
        
        print("playing video")
        print("VIDEOOOO")
//        [video, play];
//        video.paused = NO;
        
        
        bgImage.size = CGSize(width: self.size.width, height: self.size.height);
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        bgImage.zPosition = 0;
        
//        self.addChild(bgImage)
        var i = 0;
        var strings = [“askjll”, “aksdh”, “akfldj;”, “askfjal”]
        var timer: NSTimer
        
    
        textLabel.text = strings[0]
        timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector(“changeTextMethod"), userInfo: nil, repeats: true)
            //should put a pause of 10 seconds here for flicking period
        
        
        
        addSwipe()
        track()
        
    }
    var player: AVPlayer = AVPlayer()
    var video: SKVideoNode = SKVideoNode()

    func changeTextMethod () {
        i++
        textLabel.text = strings[i % strings.size]
    }
    
    
    func toNextScreen () {
        //if thing flicked in the screen
        //stop timer
        //go to next screen and remove all objects
    }
    
    func restartVideo() {
        video.removeFromParent()
        video = SKVideoNode(AVPlayer: player)
        video.position = CGPointMake(self.size.width * 1/2, self.size.height * 1/2)
        video.size = CGSizeMake(self.size.width * 2/3, self.size.height * 1/2)
        video.zPosition = 100
        self.addChild(video)
        video.play()
    }
//
//    func playVideo() {
//        let path = NSBundle.mainBundle().pathForResource("FlickItDemo3", ofType:"mov")
//        let url = NSURL.fileURLWithPath(path!)
//        moviePlayer = MPMoviePlayerController(contentURL: url)
//        
//        if let player = moviePlayer {
//            
//            player.view.frame = CGRect(x: self.size.width/2, y: self.size.height/2, width: self.size.width/2, height: self.size.height/2)
//            
//            player.prepareToPlay()
//            player.scalingMode = .AspectFill
//            player.controlStyle = .None
//            player.shouldAutoplay = true
//            player.repeatMode = MPMovieRepeatMode.One
//            self.view!.addSubview(player.view)
//            
//        }    
//    }
//
    func track() {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Rule Screen")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        let event = GAIDictionaryBuilder.createEventWithCategory("Action", action: "Opened rules", label: nil, value: nil)
        tracker.send(event.build() as [NSObject : AnyObject])
    }
    
    func setCaptionText () {
        if (numTouches == 0) {
            caption.text = "There's 4 basic shapes that will enter the screen..."
//            self.addChild(caption)
//            screenImage.texture = SKTexture(imageNamed: "blue_triangle")
        } else if (numTouches == 1) {
            caption.text = "Flick them into the proper bins they belong to!"
//            self.addChild(caption)
//            screenImage.texture = SKTexture(imageNamed: "blue_circle")
        } else if (numTouches == 2) {
            caption.text = "Earn as many points as you can with 3 lives!"
//            self.addChild(caption)
//            screenImage.texture = SKTexture(imageNamed: "blue_star")
        } else if (numTouches == 3) {
            caption.text = "Avoid bombs and use stars to get extra points!"
//            self.addChild(caption)
//            screenImage.texture = SKTexture(imageNamed: "blue_square")
        } else if (numTouches == 4) {
            caption.text = "Swipe to Play"
//            self.addChild(caption)
//            screenImage.texture = SKTexture(imageNamed: "blue_triangle")
        } else {
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



