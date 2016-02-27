
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
    
    var bin_1 = SKSpriteNode(imageNamed: "bin-2.png"); //change this to differently oriented triangles
    var bin_2 = SKSpriteNode(imageNamed: "bin-2.png");
    var bin_3 = SKSpriteNode(imageNamed: "bin-2.png");
    var bin_4 = SKSpriteNode(imageNamed: "bin-2.png");
    
    let shapes = ["blue_triangle", "red_square", "green_triangle","yellow_square"]
    let bins = ["bin_1", "bin_2", "bin_3", "bin_4"]
    
    var time : CFTimeInterval = 2;
    var shapeToAdd = SKSpriteNode();
    
    var shapeController = SpawnShape();
    
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
        bgImage.zPosition = 1
        self.addChild(bgImage);
        
        print("Entered create scene")
        
        //adds bins on all 4 corners of screen with name, zposition and size
        //bin_1.size = CGSize(width: 100, height: 100)
        bin_1.position = CGPointMake(self.frame.width * 2 / 3, self.frame.height * 9 / 10)
        bin_1.zPosition = 3
        bin_1.name = "bin_1"
        
        //bin_2.size = CGSize(width: 100, height: 100)
        bin_2.position = CGPointMake(self.frame.width / 3, self.frame.height * 9 / 10)
        bin_2.zPosition = 3
        bin_2.name = "bin_2"
        
        //bin_3.size = CGSize(width: 100, height: 100)
        bin_3.position = CGPointMake(self.frame.width * 2 / 3, self.frame.height / 10)
        bin_3.zPosition = 3
        bin_3.name = "bin_3"
        
        //bin_4.size = CGSize(width: 100, height: 100)
        bin_4.position = CGPointMake(self.frame.size.width / 3, self.frame.size.height / 10)
        bin_4.zPosition = 3
        bin_4.name = "bin_4"
        
        self.addChild(bin_1)
        self.addChild(bin_2)
        self.addChild(bin_3)
        self.addChild(bin_4)
        
        //self.view?.backgroundColor = UIColor.blackColor();
        
    }
    
    func perfectFlick(shape: SKNode) {
        // increment score
        // do some lovely animation of shape exploding into pixels 
        // play audio 
        //shape.removeFromParent();
        print("successful flick")
    }
    
    func failedFlick(){
        // play sad audio
        // end game
        // some animation symbolizing something bad 
//        self.removeAllChildren();
//        self.addChild(bgImage);
        print("failed flick")
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        print(contact.bodyA.node?.name);
        print(contact.bodyB.node?.name);
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
            failedFlick();
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if currentTime - time >= 2 {
            shapeToAdd = self.shapeController.spawnShape();
            shapeToAdd.position = CGPointMake(self.size.width/2, self.size.height/2);
            
            //print(shapeToAdd.physicsBody?.velocity);
            self.addChild(shapeToAdd);
            //shapeToAdd.physicsBody?.applyImpulse(CGVectorMake(shapeController.dx, shapeController.dy))
            //self.addChild(self.shapeController.spawnShape());
            time = currentTime;
        }
        
        
//        let spawn = SKAction.runBlock({
//            () in
//            self.addChild(self.shapeController.spawnShape())
//        })
//        let delay = SKAction.waitForDuration(2)
//        let spawnDelay = SKAction.sequence([spawn,delay])
//        let spawnDelayForever = SKAction.repeatActionForever(spawnDelay)
//        self.runAction(spawnDelayForever)
    }

    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
        
    }
    
    
}