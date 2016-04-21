//
//  TableViewExtension.swift
//  YoutubeToAudio
//
//  Created by ranjith on 27/03/16.
//  Copyright © 2016 iTag. All rights reserved.
//

import Foundation

extension UITableView {
    func yc_reloadDataWithHideEmptyCell() {
        reloadData()
        let emptyView = UIView.init(frame: CGRectZero)
        emptyView.backgroundColor = UIColor.clearColor()
        self.tableFooterView = emptyView
    }
}
