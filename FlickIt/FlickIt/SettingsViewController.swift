//
//  SettingsViewController.swift
//  FlickIt
//
//  Created by Abhishek Mangla on 5/23/16.
//  Copyright © 2016 Abhi_Shaili_Jeffrey_Rohan_Ashwin. All rights reserved.
//

import Foundation

import UIKit
import SpriteKit

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func getView() -> UIView {
        let nov = UIView()
        nov.backgroundColor = UIColor.blackColor()
        
        let backButton = UIButton(frame: CGRectMake(10, 10, view.frame.size.width/5, view.frame.size.width/10))
        backButton.setTitle("Back", forState: .Normal)
        backButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        backButton.addTarget(self, action: #selector(buttonAction), forControlEvents: UIControlEvents.TouchUpInside)
        nov.addSubview(backButton)
        
        return nov
    }
    
    func buttonAction(sender:UIButton!)
    {
        print("here")
        let scene = GameScene(size: view.bounds.size)
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.showsPhysics = false
        skView.showsDrawCount = false
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        
        if(skView.scene == nil){
            scene.scaleMode = .AspectFill
            scene.size  = skView.bounds.size
            skView.presentScene(scene)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
