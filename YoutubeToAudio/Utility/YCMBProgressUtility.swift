//
//  YCMBProgressUtility.swift
//  YoutubeToAudio
//
//  Created by ranjith on 24/04/16.
//  Copyright © 2016 iTag. All rights reserved.
//

import Foundation

class YCMBProgressUtility:NSObject,YCMBProgressUtilityProtocol {
    class var sharedInstance: YCMBProgressUtility {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: YCMBProgressUtility? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = YCMBProgressUtility()
        }
        return Static.instance!
    }
    override init() {}
    
    //MBProgressUtility Protocols
    func showBusyIndicatorWithMessage(message:String?,image:UIImage?,viewControllerToShow:UIViewController) {
        let hud = MBProgressHUD .showHUDAddedTo(viewControllerToShow.view, animated: true)
        if let messageText = message {
            hud.labelText = messageText
        }
        hud .show(true)
    }
    
    func dismissBusyIndicator(viewControllerToDismiss:UIViewController) {
        dispatch_async(dispatch_get_main_queue()) {
            MBProgressHUD .hideHUDForView(viewControllerToDismiss.view, animated: true)
        }
    }
}