//
//  YCLongTaskViewHelper.swift
//  YoutubeToAudio
//
//  Created by ranjith on 27/03/16.
//  Copyright © 2016 iTag. All rights reserved.
//

import Foundation

class YCLongTaskViewHelper: NSObject,YCLongTaskViewProtocol {
    var containerView:UIView?
    
   convenience init(containerViewController:UIViewController) {
        self.init()
        containerView! = containerViewController.view
    }
    
    func searchUsersWithSearchTerm(searchTerm: String,
        completionClosure: (users :String) ->()) {
            
    }
    
    
    func showBusyIndicatorWithMessage(message: String, image: UIImage) {
        let hud = MBProgressHUD .showHUDAddedTo(self.containerView, animated: true)
        hud.labelText = message
        hud .show(true)
    }
    
    func dismissBusyIndicator() {
        dispatch_async(dispatch_get_main_queue()) {
            MBProgressHUD .hideHUDForView(self.containerView, animated: true)
        }
    }
    
    func showToastWithMessage(message: String) {
        let hud = MBProgressHUD .showHUDAddedTo(self.containerView, animated: false)
        hud.labelText = message
        hud.mode = MBProgressHUDModeText
        hud .hide(true, afterDelay: 2)
    }
    
    func showToastWithBiggerMessage(biggerMessage: String) {
        let hud = MBProgressHUD .showHUDAddedTo(self.containerView, animated: false)
        hud.detailsLabelText = biggerMessage
        hud.mode = MBProgressHUDModeText
        hud .hide(true, afterDelay: 2)
    }
    
 /*   func showMessage(message: String, title: String, positiveTitles: Array<String>, negativeTitle: String, positiveBlock: YCAlertIndexedActionBlock, negativeBlock: YCAlertActionBlock) ->UIAlertController {
          return UIAlertController .showMessage(message, title: title, positiveTitles: positiveTitles, negativeTitle: negativeTitle, positiveBlock: positiveBlock, negativeBlock: negativeBlock)
    }
    
    func showError(error: NSError, withTitle: String, positiveButtonTitle: String, negativeButtonTitle: String, positiveBlock: YCAlertActionBlock, negativeBlock: YCAlertActionBlock) ->UIAlertController{
      return UIAlertController.showError(error, title: withTitle, positiveTitle: positiveButtonTitle, negativeTitle: negativeButtonTitle, positiveBlock: positiveBlock, negativeBlock: negativeBlock)
    }
    
    func showConfirmationWithTitle(title: String, message: String, positiveTitle: String, negativeTitle: String, positiveBlock: YCAlertActionBlock, negativeBlock: YCAlertActionBlock)->UIAlertController {
        return UIAlertController.showConfirmationWithTitle(title, message: message, positiveTitle: positiveTitle, negativeTitle: negativeTitle, positiveBlock: positiveBlock, negativeBlock: negativeBlock)
    }
    */
    func showInformationWithTitle(title: String, message: String, dismissButtonTitle: String)->UIAlertController {
      return  UIAlertController.showInformationWithTitle(title, message: message, dismissTitle: dismissButtonTitle)
    }
}