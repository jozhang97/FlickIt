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

    let sizeRect = UIScreen.mainScreen().applicationFrame;
    let titleLabel = SKLabelNode()
    var audioPlayer = AVAudioPlayer()
    
    override init(size: CGSize) {
        super.init(size: size)
        createDetailsLabel()
//        sceneHeight = sizeRect.size.height * UIScreen.mainScreen().scale;
//        sceneWidth = sizeRect.size.width * UIScreen.mainScreen().scale;
//        shapeScaleFactor = 0.14*self.size.width/bin_3_shape_width
//        createScene()
        playMusic("jcena", type: "mp3")
        
    }
    
    func playMusic(path: String, type: String) {
        let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(path, ofType: type)!)
        print(alertSound)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            try audioPlayer = AVAudioPlayer(contentsOfURL: alertSound)
        }
        catch {
            
        }
        audioPlayer.prepareToPlay()
        audioPlayer.numberOfLoops = -1
        audioPlayer.play()
    }
    
    func createDetailsLabel() {
        titleLabel.text = "Made by Ashwin, Abhi, Rohan, Shaili, Jeffrey."
        titleLabel.position = CGPointMake(self.frame.width/2, self.frame.height/2)
        titleLabel.horizontalAlignmentMode = .Center
        titleLabel.fontColor = UIColor.whiteColor()
        titleLabel.fontName = "Futura"
        titleLabel.fontSize = 20
        self.addChild(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



}