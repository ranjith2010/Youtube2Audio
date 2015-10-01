//
//  RKImageDownloader.h
//  YoutubeToAudio
//
//  Created by ranjith on 28/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"

@protocol ImageDownloaderDelegate;

@interface RKImageDownloader : NSOperation

@property (nonatomic, assign) id <ImageDownloaderDelegate> delegate;

@property (nonatomic, readonly, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readonly, strong) DataModel *dataModel;

- (id)initWithDataModel:(DataModel *)model atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageDownloaderDelegate>) theDelegate;

@end


@protocol ImageDownloaderDelegate <NSObject>

- (void)imageDownloaderDidFinish:(RKImageDownloader *)downloader;

@end