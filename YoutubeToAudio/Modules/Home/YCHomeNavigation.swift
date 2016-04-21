//
//  YCHomeNavigation.swift
//  YoutubeToAudio
//
//  Created by ranjith on 21/03/16.
//  Copyright © 2016 ranjith. All rights reserved.
//

import Foundation
import UIKit

class YCHomeNavigation: NSObject,YCHomeNavigationProtocol {
    var navigationController:UINavigationController!
    func presentDownloadContentViewControllerWithDataModel(dataModel: DataModel) {
        let downloadContentViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DownloadContentViewController") as! DownloadContentViewController
        downloadContentViewController.model = dataModel
        navigationController!.pushViewController(downloadContentViewController, animated: true)
    }
}
