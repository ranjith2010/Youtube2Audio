//
//  YCUtilityManager.swift
//  YoutubeToAudio
//
//  Created by ranjith on 24/04/16.
//  Copyright © 2016 iTag. All rights reserved.
//

import Foundation

class YCUtilityManager:NSObject {
    // Need to refer. How to Invoke class Methods inside classMethod
    class var MBProgressUtility: YCMBProgressUtility {
        return YCMBProgressUtility.sharedInstance
    }
}