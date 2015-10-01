//
//  RKNetworkClient.m
//  YoutubeToAudio
//
//  Created by ranjith on 25/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import "RKNetworkClient.h"
#import "RKNeworkEngine.h"

@implementation RKNetworkClient


+ (id<RKHTTPClientProtocol>)sharedInstance {
    static dispatch_once_t token;
    static RKNeworkEngine* theEngine;
    dispatch_once(&token, ^{
        theEngine = [RKNeworkEngine new];
    });
    return theEngine;
}


@end
