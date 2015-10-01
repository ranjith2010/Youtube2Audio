//
//  RKNetworkClient.h
//  YoutubeToAudio
//
//  Created by ranjith on 25/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"

@protocol RKHTTPClientProtocol <NSObject>


- (void)fetchYoutubeVideosWithSearchQuery:(NSString*)query isFreshQuery:(BOOL)isFresh
                               fetchCount:(int)fetchCount
                                         :(void(^)(NSArray *models,NSError *error))block;



- (void)fetchYTVideoMetaDataWithVideoID:(DataModel*)dataModel;

- (void)fetchVideoDetails:(DataModel*)model :(void(^)(DataModel *dataModel,NSError *error))block;

- (void)fetchMostPopularVideosWithFetchCount:(int)fetchCount isFreshQuery:(BOOL)isFresh :(void(^)(NSArray *models,NSError *error))block;

@end

@interface RKNetworkClient : NSObject

+ (id<RKHTTPClientProtocol>)sharedInstance;


@end
