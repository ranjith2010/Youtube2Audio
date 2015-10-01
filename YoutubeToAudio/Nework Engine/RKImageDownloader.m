//
//  RKImageDownloader.m
//  YoutubeToAudio
//
//  Created by ranjith on 28/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import "RKImageDownloader.h"

@interface RKImageDownloader ()
@property (nonatomic, readwrite, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readwrite, strong) DataModel *dataModel;
@end

@implementation RKImageDownloader

@synthesize delegate = _delegate;
@synthesize indexPathInTableView = _indexPathInTableView;
@synthesize dataModel = _dataModel;


#pragma mark - Life Cycle

- (id)initWithDataModel:(DataModel *)record atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageDownloaderDelegate>)theDelegate {
    
    if (self = [super init]) {
        // 2
        self.delegate = theDelegate;
        self.indexPathInTableView = indexPath;
        self.dataModel = record;
    }
    return self;
}

#pragma mark -
#pragma mark - Downloading image


// 3
- (void)main {
    
    // 4
    @autoreleasepool {
        
        if (self.isCancelled)
            return;
        
        NSURL *url = [NSURL URLWithString:self.dataModel.thumbnailUrl];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
        
        if (self.isCancelled) {
            imageData = nil;
            return;
        }
        
        if (imageData) {
            UIImage *downloadedImage = [UIImage imageWithData:imageData];
            self.dataModel.videoImage = downloadedImage;
        }
        else {
            self.dataModel.failed = YES;
        }
        
        imageData = nil;
        
        if (self.isCancelled)
            return;
        
        // 5
        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(imageDownloaderDidFinish:) withObject:self waitUntilDone:NO];
        
    }
}



@end
