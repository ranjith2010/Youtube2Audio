//
//  ButtonExtension.swift
//  YoutubeToAudio
//
//  Created by ranjith on 27/03/16.
//  Copyright © 2016 ranjith. All rights reserved.
//

import Foundation

extension UIButton {
    func yc_applyLayerAttributes() {
        self.layer.borderWidth = 2.0
        let buttonLabel = self.titleLabel
        let textColor = buttonLabel!.textColor
        self.layer.borderColor = textColor.CGColor
        self.layer.cornerRadius = 4.0
    }
}
