
//
//  startGame.swift
//  FlickIt
//
//  Created by Apple on 2/20/16.
//  Copyright © 2016 Abhi_Shaili_Jeffrey_Rohan_Ashwin. All rights reserved.
//

import SpriteKit

class StartGameScene: SKScene, SKPhysicsContactDelegate {
    var bgImage = SKSpriteNode(imageNamed: "neon_circle.jpg");
    var startSquare = SKSpriteNode(imageNamed: "start_square.jpg");
    var launchSquare = SKSpriteNode(imageNamed: "launch_square.jpg");
    var rulesCircle = SKSpriteNode(imageNamed: "rules_circle.jpg");
    var launchCircle = SKSpriteNode(imageNamed: "launch_circle.jpg");
    
    let shapes = ["blue_triangle", "red_square", "green_triangle","yellow_square"]
    let bins = ["bin_1", "bin_2", "bin_3", "bin_4"]
    
    override init(size: CGSize) {
        super.init(size: size)
        physicsWorld.contactDelegate = self // error fix = do self.physicsWorld...
        createScene()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func didMoveToView(view: SKView) {
//        print("hello")
//        createScene()
//    }
    
    func createScene() {
        // Sets the neon circle image to fill the entire screen
        bgImage.size = CGSize(width: self.size.width/2, height: self.size.height);
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        self.addChild(bgImage);
        self.view?.backgroundColor = UIColor.blackColor();
        
        
        
    }
    
    func perfectFlick(shape: SKNode) {
        // increment score
        // do some lovely animation of shape exploding into pixels 
        // play audio 
        shape.removeFromParent();
    }
    
    func failedFlick(){
        // play sad audio
        // end game
        // some animation symbolizing something bad 
        self.removeAllChildren();
        self.addChild(bgImage);
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if ((contact.bodyA.node!.name == shapes[0] && contact.bodyB.node!.name == bins[0]) || (
        contact.bodyA.node!.name == shapes[1] && contact.bodyB.node!.name == bins[1]) || (
        contact.bodyA.node!.name == shapes[2] && contact.bodyB.node!.name == bins[2]) || (
        contact.bodyA.node!.name == shapes[3] && contact.bodyB.node!.name == bins[3])){
            perfectFlick(contact.bodyA.node!)
        } else if ((contact.bodyB.node!.name == shapes[0] && contact.bodyA.node!.name == bins[0]) || (
        contact.bodyB.node!.name == shapes[1] && contact.bodyA.node!.name == bins[1]) || (
        contact.bodyB.node!.name == shapes[2] && contact.bodyA.node!.name == bins[2]) || (
        contact.bodyB.node!.name == shapes[3] && contact.bodyA.node!.name == bins[3])) {
            perfectFlick(contact.bodyB.node!)
        } else {
            failedFlick()
        }
    }

    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
        
    }
    
    
}