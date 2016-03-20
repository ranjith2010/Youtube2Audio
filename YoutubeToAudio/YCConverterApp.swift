//
//  YCConverterApp.swift
//  YoutubeToAudio
//
//  Created by ranjith on 20/03/16.
//  Copyright © 2016 ranjith. All rights reserved.
//

import UIKit
import Foundation

class YCConverterApp: NSObject {
    internal func startAppWithLaunchOptions(launchOptions:[String:AnyObject],application:UIApplication,window:UIWindow) {
        let rootTableViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RootTableViewController")
        window.rootViewController = rootTableViewController
    }
}

