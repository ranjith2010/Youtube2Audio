//
//  AudioTableViewCell.h
//  YoutubeToAudio
//
//  Created by ranjith on 24/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SandBoxMediaModel.h"

@interface AudioTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *albumArtView;

@property (weak, nonatomic) IBOutlet UILabel *audioTitle;

- (void)feedCellWithObject:(SandBoxMediaModel*)mediaModel;


@property (nonatomic,strong) SandBoxMediaModel *currentMediaModel;
@property (weak, nonatomic) IBOutlet UIButton *playAndPauseBtn;

@property (weak, nonatomic) IBOutlet UISlider *seekBar;
@property (weak, nonatomic) IBOutlet UILabel *playingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@end
