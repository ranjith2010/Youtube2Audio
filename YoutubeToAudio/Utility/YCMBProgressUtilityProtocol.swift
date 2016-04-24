//
//  YCMBProgressUtilityProtocol.swift
//  YoutubeToAudio
//
//  Created by ranjith on 24/04/16.
//  Copyright © 2016 iTag. All rights reserved.
//

import Foundation

protocol YCMBProgressUtilityProtocol {
    func showBusyIndicatorWithMessage(message:String?,image:UIImage?,viewControllerToShow:UIViewController)
    func dismissBusyIndicator(viewControllerToDismiss:UIViewController)
}
