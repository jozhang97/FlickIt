//
//  RulesScene.swift
//  FlickIt
//
//  Created by Shaili Patel on 2/27/16.
//  Copyright © 2016 Abhi_Shaili_Jeffrey_Rohan_Ashwin. All rights reserved.
//

import SpriteKit

class RulesScene: SKScene {
    
    //keep track of which way user swipes
    var numTouches = 0;
    //create caption for "how to play" screenshots
    var caption: SKLabelNode = SKLabelNode(fontNamed: "Open Sans Condensed Light")
    var total = 5; //change this based on number of screens
    var rules: SKLabelNode = SKLabelNode(fontNamed: "Open Sans Condensed Light")
    var screenImage: SKSpriteNode = SKSpriteNode(imageNamed: "blue_triangle")
    var start = CGPoint();
    var swipe = UISwipeGestureRecognizer();
    
    override init(size: CGSize) {
        super.init(size: size)
        createScene()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createScene () {
        
        rules.text = "How to Play"
        rules.color = UIColor.whiteColor()
        rules.position = CGPoint(x: self.frame.width/2, y: self.frame.height*3.5/4)
        rules.fontSize = 30
        self.addChild(rules)
        
        caption.text = "Random shapes will appear on the screen"
        caption.color = UIColor.whiteColor()
        caption.position = CGPoint(x: self.frame.width/2, y: self.frame.height*3/4)
        caption.fontSize = 16
        self.addChild(caption)
        
        screenImage.position = CGPoint(x: self.size.width * 1/2, y: self.size.height * 1/2)
        screenImage.size = CGSize(width: self.size.width * 2/3, height: self.size.height * 1/2)
        self.addChild(screenImage)
        
        self.view?.backgroundColor = UIColor.blackColor();
        addSwipe()
        
    }
    
    func setCaptionText () {
        if (numTouches == 0) {
            caption.text = "There's 4 basic shapes that will enter the screen..."
            screenImage.texture = SKTexture(imageNamed: "blue_triangle")
        } else if (numTouches == 1) {
            caption.text = "Flick them into the proper bins they belong to!"
            screenImage.texture = SKTexture(imageNamed: "blue_circle")
        } else if (numTouches == 2) {
            caption.text = "Earn as many points as you can with 3 lives!"
            screenImage.texture = SKTexture(imageNamed: "blue_star")
        } else if (numTouches == 3) {
            caption.text = "Avoid bombs and use stars to get extra points!"
            screenImage.texture = SKTexture(imageNamed: "blue_square")
        } else if (numTouches == 4) {
            caption.text = "Swipe to Play"
            screenImage.texture = SKTexture(imageNamed: "")
        } else {
            let scene: SKScene = StartGameScene(size: self.size)
            
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
    }
    
}



