//
//  YCHomeNavigationProtocol.swift
//  YoutubeToAudio
//
//  Created by ranjith on 21/03/16.
//  Copyright © 2016 ranjith. All rights reserved.
//

import Foundation

@objc protocol YCHomeNavigationProtocol:class {
    var navigationController:UINavigationController! {
        get set
    }
    func presentDownloadContentViewControllerWithDataModel(dataModel: DataModel)
}