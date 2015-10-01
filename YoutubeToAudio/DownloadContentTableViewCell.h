//
//  DownloadContentTableViewCell.h
//  YoutubeToAudio
//
//  Created by ranjith on 17/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadDataModel.h"

@interface DownloadContentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *formatLabel;

@property (weak, nonatomic) IBOutlet UILabel *extensionLabel;


- (void)feedCellWithObject:(DownloadDataModel*)downloadDataModel;
- (void)setDidTapButtonBlock:(void(^)(id sender))block;

@end
