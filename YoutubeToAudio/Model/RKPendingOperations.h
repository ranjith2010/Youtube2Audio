//
//  RKPendingOperations.h
//  YoutubeToAudio
//
//  Created by ranjith on 28/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKPendingOperations : NSObject

@property (nonatomic, strong) NSMutableDictionary *downloadsInProgress;
@property (nonatomic, strong) NSOperationQueue *downloadQueue;

@property (nonatomic, strong) NSMutableDictionary *filtrationsInProgress;
@property (nonatomic, strong) NSOperationQueue *filtrationQueue;

@end
