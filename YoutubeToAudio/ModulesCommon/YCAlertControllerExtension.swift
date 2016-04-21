//
//  AlertViewExtension.swift
//  YoutubeToAudio
//
//  Created by ranjith on 27/03/16.
//  Copyright © 2016 iTag. All rights reserved.
//

import Foundation

extension UIAlertController {
    
    private struct AssociatedKeys {
        static let YC_POSITIVE_BLOCK_IDENTIFIER = "postive.block.identifier"
        static let YC_NEGATIVE_BLOCK_IDENTIFIER = "negative.block.identifier"
        static let YC_DISMISS_BLOCK_IDENTIFER = "dismiss.block.identifier"
    }

  /*  class func showError(error:NSError,title:String,positiveTitle:String,negativeTitle:String,
        positiveBlock:YCAlertActionBlock,
        negativeBlock:YCAlertActionBlock) ->UIAlertController{
            
            #if PRERELEASE
                if error.domain .hasPrefix(YC_ERR_DOMAIN) {
                    NSException .raise("Unknown Domain", format: "Should not use non YoutubeConverted domain errors", arguments: error)
                }
            #else
                let message = error.userInfo["msg"] as! String
                let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .Alert)
                alertController.setPositiveBlock(positiveBlock)
                alertController.setNegativeBlock(negativeBlock)
                return alertController
            #endif
    }
    */
    class func showInformationWithTitle(title:String,message:String,dismissTitle:String)->UIAlertController {
        return UIAlertController.init(title: title, message: message, preferredStyle: .Alert)
    }
    
 /*   class func showMessage(message:String,title:String,positiveTitles:Array<String>,negativeTitle:String,positiveBlock:YCAlertIndexedActionBlock,negativeBlock:YCAlertActionBlock) ->UIAlertController {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .Alert)
        alertController.setDismissBlock(positiveBlock)
        alertController.setNegativeBlock(negativeBlock)
        
        for buttonTitle in positiveTitles {
            let alertAction = UIAlertAction.init(title: buttonTitle, style: .Default, handler: nil)
            alertController.addAction(alertAction)
        }
        return alertController
    }
    
    class func showConfirmationWithTitle(title: String, message: String, positiveTitle: String, negativeTitle: String, positiveBlock: YCAlertActionBlock, negativeBlock: YCAlertActionBlock) ->UIAlertController {
        let alertController = UIAlertController()
        let alertAction = UIAlertAction.init(title: title, style: .Default, handler: nil)
        alertController.addAction(alertAction)
        return alertController
    }
    
    func setPositiveBlock(block:YCAlertActionBlock) {
        objc_setAssociatedObject(self, AssociatedKeys.YC_POSITIVE_BLOCK_IDENTIFIER, block as!AnyObject, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    func positiveBlock() ->(YCAlertActionBlock) {
        return objc_getAssociatedObject(self, AssociatedKeys.YC_POSITIVE_BLOCK_IDENTIFIER) as! YCAlertActionBlock
    }
    
    func setNegativeBlock(block:YCAlertActionBlock) {
        objc_setAssociatedObject(self, AssociatedKeys.YC_NEGATIVE_BLOCK_IDENTIFIER, block as!AnyObject, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    func negativeBlock() ->(YCAlertActionBlock) {
        return objc_getAssociatedObject(self, AssociatedKeys.YC_NEGATIVE_BLOCK_IDENTIFIER) as! YCAlertActionBlock
    }
    
    
    func setDismissBlock(block:YCAlertIndexedActionBlock) {
        objc_setAssociatedObject(self, AssociatedKeys.YC_DISMISS_BLOCK_IDENTIFER, block as! AnyObject, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    func dismissBlock() ->(YCAlertIndexedActionBlock) {
        return objc_getAssociatedObject(self, AssociatedKeys.YC_DISMISS_BLOCK_IDENTIFER) as! YCAlertIndexedActionBlock
    }
 */
}