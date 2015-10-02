//
//  RKNetworkClient.h
//  YoutubeToAudio
//
//  Created by ranjith on 25/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"


typedef void(^RKFetchMostPopularVideos)(NSArray *popularVideos,NSError *error);

@protocol RKHTTPClientProtocol <NSObject>

#pragma mark - Fetch mostPopular Videos on Youtube
- (id)fetchMostPopularVideosWithFetchCount:(int)fetchCount
                                isFreshQuery:(BOOL)isFresh
                                            :(RKFetchMostPopularVideos)block;

#pragma mark -
- (id)fetchYoutubeVideosWithSearchQuery:(NSString*)query isFreshQuery:(BOOL)isFresh
                               fetchCount:(int)fetchCount
                                         :(void(^)(NSArray *models,NSError *error))block;

- (void)fetchYTVideoMetaDataWithVideoID:(DataModel*)dataModel;

- (id)fetchVideoDetails:(DataModel*)model :(void(^)(DataModel *dataModel,NSError *error))block;






@end

@interface RKNetworkClient : NSObject

+ (id<RKHTTPClientProtocol>)sharedInstance;


@end
