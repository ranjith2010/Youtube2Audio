//
//  DownloadContentTableViewCell.m
//  YoutubeToAudio
//
//  Created by ranjith on 17/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import "DownloadContentTableViewCell.h"

@interface DownloadContentTableViewCell ()
@property (copy, nonatomic) void(^DidTapButtonBlock)(id sender);
@property (weak, nonatomic) IBOutlet UIButton *downloadButtonOutlet;

@end

@implementation DownloadContentTableViewCell

- (void)awakeFromNib {
    [self.downloadButtonOutlet yc_applyLayerAttributes];
}


- (void)feedCellWithObject:(DownloadDataModel*)downloadDataModel {
    self.formatLabel.text = downloadDataModel.format;
    self.extensionLabel.text = downloadDataModel.extension;
}

- (IBAction)didTapDownloadBtn:(id)sender {
    if (self.DidTapButtonBlock) {
        self.DidTapButtonBlock(sender);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
