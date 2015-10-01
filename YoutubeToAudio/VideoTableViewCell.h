//
//  VideoTableViewCell.h
//  YoutubeToAudio
//
//  Created by ranjith on 17/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface VideoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImage;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *DescriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *mediaDurationLabel;

@property (weak, nonatomic) IBOutlet UILabel *mediaIndexLabel;



- (void)feedCellWithObject:(DataModel*)dataModel;

@end
