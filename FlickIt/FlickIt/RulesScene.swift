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

@available(iOS 10.0, *)
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
    var timer: Timer = Timer()
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
        rules.color = UIColor.yellow
        rules.position = CGPoint(x: self.frame.width/2, y: self.frame.height*1/4)
        rules.fontSize = 40
        rules.zPosition = 3
        self.addChild(rules)
        
        caption.text = strings[0]
        caption.color = UIColor.yellow
        caption.position = CGPoint(x: self.frame.width/2, y: self.frame.height*3/4)
        caption.fontSize = 20
        caption.zPosition = 1
        self.addChild(caption)
        
        playVideo()
        
        bgImage.size = CGSize(width: self.size.width, height: self.size.height);
        bgImage.position = CGPoint(x: self.size.width/2, y: self.size.height/2);
        bgImage.zPosition = 0;
        
        self.addChild(bgImage)

        timer = Timer.scheduledTimer(timeInterval: 6.7, target: self, selector: #selector(RulesScene.changeTextMethod), userInfo: nil, repeats: true)
        //should put a pause of 10 seconds here for flicking period
        
        addSwipe()
        track()
        
    }
    
    @objc func changeTextMethod () {
        i += 1
        //        if strings[0] == strings[i % strings.count] {
        //            timer.invalidate()
        //            i = 0
        //            self.timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("changeTextMethod"), userInfo: nil, repeats: true)
        //        }
        caption.text = strings[i % strings.count]
    }
    
    
    func playVideo() {
        let fileURL: URL = URL(fileURLWithPath: Bundle.main.path(forResource: "FlickItDemoDone2", ofType: "mov")!)
        let player = AVPlayer(url: fileURL)
        player.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(RulesScene.playerItemDidReachEnd(_:)),
                                                         name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                         object: player.currentItem)
        player.isMuted = true
        let video2 = SKVideoNode(avPlayer: player)
        video2.position = CGPoint(x: self.size.width * 1/2, y: self.size.height * 1/2)
        video2.zPosition = 1
        video2.setScale(self.size.width/610)
        
        self.addChild(video2)
        video2.play()
    }
    

    @objc func playerItemDidReachEnd(_ notification: Notification) {
        if let playerItem: AVPlayerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero)
        }
    }

    func track() {
        if Platform.testingOrNotSimulator {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Rule Screen")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker?.send(builder?.build() as? [AnyHashable: Any] ?? [:])
        let event = GAIDictionaryBuilder.createEvent(withCategory: "Action", action: "Opened rules", label: nil, value: nil)
        tracker?.send(event?.build() as? [AnyHashable: Any] ?? [:])
        }
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
    }
    
    
    func addSwipe() {
        swipe =  UISwipeGestureRecognizer(target: self, action: #selector(RulesScene.handleSwipe(_:)))
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(RulesScene.handleSwipe(_:)))
            gesture.direction = direction
            self.view?.addGestureRecognizer(gesture)
        }
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        print(sender.direction)
        if (sender.direction == .left && numTouches < total){
            print("Left")
            numTouches += 1
        } else if (sender.direction == .right && numTouches > 0) {
            print("right")
            numTouches -= 1
        }
        setCaptionText();
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.location(in: self)
        start = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.location(in: self)
        let dx: CGFloat = location.x - start.x
        let dy: CGFloat = location.y - start.y
        let magnitude: CGFloat = sqrt(dx * dx + dy * dy)
        if (magnitude >= 50){
            swipe.direction = .left
            handleSwipe(swipe)
        }
        
        start = CGPoint(x: self.size.width/2, y: self.size.height/2)
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
}



