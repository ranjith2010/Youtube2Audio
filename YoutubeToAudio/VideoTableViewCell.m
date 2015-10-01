//
//  VideoTableViewCell.m
//  YoutubeToAudio
//
//  Created by ranjith on 17/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import "VideoTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+WebCache.h"
#import "RKNetworkClient.h"
#import "RKNeworkEngine.h"

@interface VideoTableViewCell()

@property(nonatomic) SDImageCache *imageCache;

@property (nonatomic,weak)id<RKHTTPClientProtocol>RKHttpClient;

@end

@implementation VideoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)feedCellWithObject:(DataModel*)dataModel {
    
    [self.mediaIndexLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
    
    self.title.text = dataModel.title;
    if(dataModel.videoDescription) {
        self.DescriptionLabel.text = dataModel.videoDescription;
    }
    else {
        self.DescriptionLabel.text = @"No Description";
    }
    if(dataModel.videoImage) {
        self.thumbnailImage.image = dataModel.videoImage;
    }
    else {
    
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:dataModel.thumbnailUrl]
                                                        options:0
                                                       progress:nil
                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         if (image && finished)
         {
             dispatch_async(dispatch_get_main_queue(),
                            ^{
                                self.thumbnailImage.image = image;
                                dataModel.videoImage = image;
                            });
         }
     }];
    }
    if(!self.RKHttpClient) {
        self.RKHttpClient = [RKNetworkClient sharedInstance];
    }
    
    if(dataModel.videoDuration){
        self.mediaDurationLabel.text = dataModel.videoDuration;
    }
    else {
    [self.RKHttpClient fetchVideoDetails:dataModel :^(DataModel *dataModel, NSError *error) {
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           self.mediaDurationLabel.text = dataModel.videoDuration;
                       });
    }];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
