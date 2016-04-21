//
//  YCViewControllerExtension.swift
//  YoutubeToAudio
//
//  Created by ranjith on 27/03/16.
//  Copyright © 2016 iTag. All rights reserved.
//

import Foundation

extension UIViewController {
     
    var longTaskViewHelper: YCLongTaskViewHelper! {return YCLongTaskViewHelper()}
    
 /*   func showMessage(message: String, title: String, positiveTitles: Array<String>, negativeTitle: String, positiveBlock: YCAlertIndexedActionBlock, negativeBlock: YCAlertActionBlock) {
        let alertController = self.longTaskViewHelper .showMessage(message, title: title, positiveTitles: positiveTitles, negativeTitle: negativeTitle, positiveBlock: positiveBlock, negativeBlock: negativeBlock)
        self .presentViewController(alertController, animated: true, completion: nil)
    }
    */
    func showBusyIndicatorWithMessage(message: String, image: UIImage) {
        self.longTaskViewHelper.showBusyIndicatorWithMessage(message, image: image)
    }
    
    func dismissBusyIndicator() {
        self.longTaskViewHelper.dismissBusyIndicator()
    }
    
    /*func showConfirmationWithTitle(title: String, message: String, positiveTitle: String, negativeTitle: String, positiveBlock: YCAlertActionBlock, negativeBlock: YCAlertActionBlock) {
        self.longTaskViewHelper.showConfirmationWithTitle(title, message: message, positiveTitle: positiveTitle, negativeTitle: negativeTitle, positiveBlock: positiveBlock, negativeBlock: negativeBlock)
    }*/
    
    func showToastWithBiggerMessage(biggerMessage: String) {
        self.longTaskViewHelper.showToastWithBiggerMessage(biggerMessage)
    }
    
    func showToastWithMessage(message: String) {
        self.longTaskViewHelper.showToastWithMessage(message)
    }
    
   /* func showError(error: NSError, withTitle: String, positiveButtonTitle: String, negativeButtonTitle: String, positiveBlock: YCAlertActionBlock, negativeBlock: YCAlertActionBlock) {
      let alertController = self.longTaskViewHelper.showError(error, withTitle: title!, positiveButtonTitle: positiveButtonTitle, negativeButtonTitle: negativeButtonTitle, positiveBlock: positiveBlock, negativeBlock: negativeBlock)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    */
    func showInformationWithTitle(title: String, message: String, dismissButtonTitle: String) {
      let alertController = self.longTaskViewHelper.showInformationWithTitle(title, message: message, dismissButtonTitle: dismissButtonTitle)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}