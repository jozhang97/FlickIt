//
//  GGButton.swift
//  FlickIt
//
//  Created by Apple on 3/22/16.
//  Copyright © 2016 Abhi_Shaili_Jeffrey_Rohan_Ashwin. All rights reserved.
//

import SpriteKit

class GGButton: SKNode {
    var defaultButton: SKLabelNode
    var action: () -> Void
    
    init(defaultButtonText: String, buttonAction: () -> Void) {
        defaultButton = SKLabelNode(text: defaultButtonText)
        defaultButton.horizontalAlignmentMode = .Center
        defaultButton.fontColor = UIColor.whiteColor()
        defaultButton.fontName = "Futura"
        defaultButton.fontSize = 30
        action = buttonAction
        
        super.init()
        
        userInteractionEnabled = true
        addChild(defaultButton)
    }
    
    /**
     Required so XCode doesn't throw warnings
     */
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
