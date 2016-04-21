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
    func startAppWithLaunchOptions(launchOptions:[String:AnyObject],application:UIApplication,window:UIWindow) {
        
        let rootTableViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RootTableViewController") as! RootTableViewController
        let homeTabBarItem = UITabBarItem.init(title: "Home", image: (UIImage.init(named: "HomeIcon")), selectedImage:(UIImage.init(named: "HomeIcon")))
        rootTableViewController.title = "Home"
        let navigationController = UINavigationController.init(rootViewController: rootTableViewController)
        navigationController.tabBarItem = homeTabBarItem
        rootTableViewController.ycHomeNavigation = YCHomeNavigation()
        rootTableViewController.ycHomeNavigation.navigationController = navigationController
        
        let sandBoxTableViewController = sandboxTableViewController()
        sandBoxTableViewController.title = "Downloads"
        let navigationControllerForSandBoxTVC = UINavigationController.init(rootViewController: sandBoxTableViewController)
        let sandBoxTabBarItem = UITabBarItem.init(title: "Downloads", image: (UIImage.init(named: "HomeIcon")), selectedImage:(UIImage.init(named: "HomeIcon")))
        navigationControllerForSandBoxTVC.tabBarItem = sandBoxTabBarItem
        tabBarController .setViewControllers([navigationController,navigationControllerForSandBoxTVC], animated: true)
        window.rootViewController = tabBarController
    }
    
    private func sandboxTableViewController() ->SandBoxTableViewController {
        return UIStoryboard.init(name:"Main",bundle:nil).instantiateViewControllerWithIdentifier("SandBoxTableViewController") as! SandBoxTableViewController
    }
}

