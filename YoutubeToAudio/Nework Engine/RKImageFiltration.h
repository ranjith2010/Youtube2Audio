//
//  RKImageFiltration.h
//  YoutubeToAudio
//
//  Created by ranjith on 28/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>
#import "DataModel.h"

@protocol ImageFiltrationDelegate;

@interface RKImageFiltration : NSOperation

@property (nonatomic, weak) id <ImageFiltrationDelegate> delegate;
@property (nonatomic, readonly, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readonly, strong) DataModel *dataModel;

- (id)initWithDataModel:(DataModel *)record atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageFiltrationDelegate>)theDelegate;

@end

@protocol ImageFiltrationDelegate <NSObject>
- (void)imageFiltrationDidFinish:(RKImageFiltration *)filtration;
@end