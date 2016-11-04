//
//  Platform.swift
//  FlickIt
//
//  Created by Jeffrey Zhang on 11/1/16.
//  Copyright © 2016 Abhi_Shaili_Jeffrey_Rohan_Ashwin. All rights reserved.
//

import Foundation

struct Platform {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    static var isTesting: Bool {
        return false // hardcore this
    }
    static var testingOrNotSimulator: Bool {
        return !isSimulator || isTesting
    }
    // I should track if its not simulator and not testing 
}
