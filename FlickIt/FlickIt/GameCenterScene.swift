//
//  GameCenterScene.swift
//  FlickIt
//
//  Created by Jeffrey Zhang on 5/28/16.
//  Copyright © 2016 Abhi_Shaili_Jeffrey_Rohan_Ashwin. All rights reserved.
//

import Foundation

//
//  SettingScene.swift
//  FlickIt
//
//  Created by Abhishek Mangla on 5/23/16.
//  Copyright © 2016 Abhi_Shaili_Jeffrey_Rohan_Ashwin. All rights reserved.
//

import UIKit
import GameKit
class GameCenterScene: SKScene, GKGameCenterControllerDelegate {
    
    var startGameScene: StartGameScene!
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(sgs: StartGameScene) {
        super.init()
        startGameScene = sgs
    }
    
    func authPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {
            (view, error) in
            if view != nil {
                let viewController = self.view!.window?.rootViewController
                viewController?.presentViewController(view!, animated: true, completion: nil)
                //                viewController?.removeFromParentViewController()
                //                self.view?.removeFromSuperview() //idk about this
            }
            else {
                print("Authenticated status: " + String(GKLocalPlayer.localPlayer().authenticated))
            }
        }
    }
    
    func saveScore(score: Int) {
        if GKLocalPlayer.localPlayer().authenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: "scoreLeaderboard")
            scoreReporter.value = Int64(score)
            let scoreArray : [GKScore] = [scoreReporter]
            GKScore.reportScores(scoreArray, withCompletionHandler: {
                (NSError) in
                print(NSError)
                return
            })
            print("Score is")
            print(score)
        }
    }
    
    func showLeaderboard() {
        let viewController = self.view!.window?.rootViewController
        let gameCenterVC: GKGameCenterViewController! = GKGameCenterViewController()
        gameCenterVC.gameCenterDelegate = self
        viewController!.presentViewController(gameCenterVC, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
