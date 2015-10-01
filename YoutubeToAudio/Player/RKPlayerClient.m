//
//  RKPlayerClient.m
//  YoutubeToAudio
//
//  Created by ranjith on 24/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import "RKPlayerClient.h"
#import "RKPlayerEngine.h"

@implementation RKPlayerClient


+ (id<RKPlayerAPIClientProtocol>)sharedInstance {
    static dispatch_once_t token;
    static RKPlayerEngine* theEngine;
    dispatch_once(&token, ^{
        theEngine = [RKPlayerEngine new];
    });
    return theEngine;
}


@end
