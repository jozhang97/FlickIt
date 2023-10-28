//
//  GameViewController.swift
//  FlickIt
//
//  Created by Jeffrey Zhang on 2/13/16.
//  Copyright (c) 2016 Abhi_Shaili_Jeffrey_Rohan_Ashwin. All rights reserved.
//

import UIKit
import SpriteKit

@available(iOS 11.0, *)
class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = HomeScene(size: view.bounds.size)
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.showsPhysics = false
        skView.showsDrawCount = false
        definesPresentationContext = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        
        if(skView.scene == nil){
            
            scene.scaleMode = .aspectFill
            scene.size  = skView.bounds.size
            skView.presentScene(scene)
        }
        
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }


    override var shouldAutorotate : Bool {
        return false
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}
