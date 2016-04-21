//
//  YCLongTaskViewProtocol.swift
//  YoutubeToAudio
//
//  Created by ranjith on 27/03/16.
//  Copyright © 2016 iTag. All rights reserved.
//

import Foundation

//typedef void(^ZPAlertActionBlock)(void);
//typedef void (^ZPAlertIndexedActionBlock)(NSInteger buttonIndex);

var YCAlertActionBlock:(()->Void)?
//typealias YCAlertActionBlock = () -> ()
typealias YCAlertIndexedActionBlock = () -> (Int)

typealias YCCancelBlock = () -> ()

//var completionHandler: ((sucsess:Bool!, items:[AnyObject]!)->())?

//typealias YCAlertActionBlock:(()->Void)?

@objc protocol YCLongTaskViewProtocol {
    
    /**
    Show busy indicator. The type of busy indicator is upto the View.
    @param message The text message (example "Loading...", "Please wait..."). This can be nil.
    @param image The image to be shown as part of busy indicator. This is optional and can be used if the View supports. This can be nil.
    */
    func showBusyIndicatorWithMessage(message:String,image:UIImage)
    
    /**
    Dismisses busy indicator
    */
    func dismissBusyIndicator()
    
    /**
    Shows an error as an alert. The presentation style is upto the view.
    @param error The reason error. The message of the alert is the localizedDescription of the error.
    @param title The alert title. This can be nil.
    @param positiveButtonTitle The text for positive action button.
    @param negativeButtonTitle The text for negative action button.
    @param positiveBlock The block to be executed when user responds with positive action.
    @param negativeBlock The block to be executed when user responds with negative action. This can be nil.
    */
 /*   func showError(error:NSError,
        withTitle:String,
        positiveButtonTitle:String,
        negativeButtonTitle:String,
        positiveBlock:YCAlertActionBlock,
        negativeBlock:YCAlertActionBlock)->UIAlertController
    
    /**
    Shows a confirmation dialog. The presentation style is upto the view.
    @param title The alert title. This can be nil.
    @param message The alert message.
    @param positiveButtonTitle The text for positive action button.
    @param negativeButtonTitle The text for negative action button.
    @param positiveBlock The block to be executed when user responds with positive action.
    @param negativeBlock The block to be executed when user responds with negative action. This can be nil.
    */
    func showConfirmationWithTitle(title:String,
        message:String,
        positiveTitle:String,
        negativeTitle:String,
        positiveBlock:YCAlertActionBlock,
        negativeBlock:YCAlertActionBlock)->UIAlertController
    
    /**
    Shows an information to the User. This is called in a situations where the system presents some info to the user but does not depend on the user's action. For example an invalid email during signup.
    @param title The info title. This can be nil.
    @param message The info message.
    @param dismissButtonTitle The dismiss button title.
    */
    func showInformationWithTitle(title:String,message:String,dismissButtonTitle:String)->UIAlertController
    
    /**
    Shows a confirmation dialog with more then one positive buttons. The presentation style is upto the view.
    @param message The alert message.
    @param title The alert title. This can be nil.
    @param positiveTitles The text for positive action buttons in array.
    @param negativeTitle The text for negative action button.
    @param dismissBlock The block to be executed when user responds with positive action and gives back the selected positive button index.
    @param negativeBlock The block to be executed when user responds with negative action. This can be nil.
    */
    func showMessage(message:String,
        title:String,
        positiveTitles:Array<String>,
        negativeTitle:String,
        positiveBlock:YCAlertIndexedActionBlock,
        negativeBlock:YCAlertActionBlock) -> UIAlertController
  */
    /**
    Shows a Notification to the User. This is called in a situations where the user Received a New notification
    @param message This is a Notification message
    */
    func showToastWithMessage(message:String)
    
    /**
    Shows a Notification to the User. This is called in a situations where the user Received a New notification
    @param message This is a Notification message, Actually this one will be called when you want to show some bigger message.
    */
    func showToastWithBiggerMessage(biggerMessage:String)
}