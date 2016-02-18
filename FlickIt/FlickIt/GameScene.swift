//
//  GameScene.swift
//  FlickIt
//
//  Created by Jeffrey Zhang on 2/13/16.
//  Copyright (c) 2016 Abhi_Shaili_Jeffrey_Rohan_Ashwin. All rights reserved.
//

import SpriteKit

//struct PhysicsCategory {
//    static let Bin : UInt32 = 0x1 <<1
//    static let Shape : UInt32 = 0x1 <<2
//}

class GameScene: SKScene {
    var startBin = SKSpriteNode()
    var rulesBin = SKSpriteNode()
    var aboutBin = SKSpriteNode()
    var shape = SKSpriteNode()
    
    /** Creates scene by setting position and defining physics */
    func createScene(){
        /** Puts in the title */
        let title = UILabel(frame: CGRectMake(self.frame.width/9, self.frame.height/8, self.frame.width/2, self.frame.height/8))
        
        title.text = "Flick-It"
        title.font = UIFont(name: "Futura", size: 30)
        title.textColor = UIColor.blueColor()
        self.view?.addSubview(title)
        
    //New labels added in after Jeffrey's commit
        //start label -- edit placement and width
        let start = UILabel(frame: CGRectMake(self.frame.width/2, self.frame.height*1/4, self.frame.width/4, self.frame.height/12))
        start.text = "Start"
        start.font = UIFont(name: "Futura", size: 18)
        start.textColor = UIColor.whiteColor();
        self.view?.addSubview(start)
        
        //rules label -- edit placement and width
        let rules = UILabel(frame: CGRectMake(self.frame.width/2 + 10, self.frame.height*1/4, self.frame.width/4, self.frame.height/12))
        rules.text = "Rules"
        rules.font = UIFont(name: "Futura", size: 18)
        rules.textColor = UIColor.whiteColor();
        self.view?.addSubview(rules)

        //about label -- edit placement and width
        let about = UILabel(frame: CGRectMake(self.frame.width/2, self.frame.height*1/2 - 10, self.frame.width/4, self.frame.height/12))
        about.text = "About"
        about.font = UIFont(name: "Futura", size: 18)
        about.textColor = UIColor.whiteColor();
        self.view?.addSubview(about)

        
        
        /** Puts in background */
        self.view?.backgroundColor = UIColor.blackColor()

        
        /** Giving the objects pictures */
        startBin = SKSpriteNode(imageNamed: "bin")
        rulesBin = SKSpriteNode(imageNamed: "bin")
        aboutBin = SKSpriteNode(imageNamed: "bin")
        shape = SKSpriteNode(imageNamed: "blue_triangle")
        
        /** Downsizes pictures to fit on screen better */
        startBin.setScale(0.15)
        rulesBin.setScale(0.15)
        aboutBin.setScale(0.15)
        shape.setScale(0.15)
        
        /** Sets positions of startBin, rulesBin, shape */
        startBin.position = CGPoint(x: self.frame.width/2, y: self.frame.height*1/4)
        rulesBin.position = CGPoint(x: self.frame.width*1/4, y: self.frame.height/2)
        aboutBin.position = CGPoint(x: self.frame.width*2/4, y: self.frame.height/2)
        shape.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        
        /** Adding objects into screen */
        self.addChild(startBin)
        self.addChild(rulesBin)
        self.addChild(aboutBin)
        self.addChild(shape)
    }
    
    override func didMoveToView(view: SKView) {
        createScene()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */

        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
