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
    //Lazy initialization
    lazy var tabBarController:UITabBarController = {
        return UITabBarController()
    }()
    override init() {
    }
    internal func startAppWithLaunchOptions(launchOptions:[String:AnyObject],application:UIApplication,window:UIWindow) {
        let rootTableViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RootTableViewController") as! RootTableViewController
        let homeTabBarItem = UITabBarItem.init(title: "Home", image: (UIImage.init(named: "HomeIcon")), selectedImage:(UIImage.init(named: "HomeIcon")))
        rootTableViewController.title = "Home"
        let navigationController = UINavigationController.init(rootViewController: rootTableViewController)
        navigationController.tabBarItem = homeTabBarItem
        rootTableViewController.ycHomeNavigation = YCHomeNavigation()
        rootTableViewController.ycHomeNavigation.navigationController = navigationController
        tabBarController .setViewControllers([navigationController], animated: true)
        window.rootViewController = tabBarController
    }
}

