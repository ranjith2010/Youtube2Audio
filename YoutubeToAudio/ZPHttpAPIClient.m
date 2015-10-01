//
//  ZPHttpClient.m
//  Zippr
//
//  Created by totaramudu on 03/08/15.
//  Copyright (c) 2015 Zippr. All rights reserved.
//

#import "ZPHttpAPIClient.h"
#import "ZPHttpClientAF.h"

@implementation ZPHttpAPIClient

+ (id<ZPHttpAPIClientProtocol>)sharedInstance {
    static dispatch_once_t token;
    static ZPHttpClientAF* theClient;
    dispatch_once(&token, ^{
        theClient = [ZPHttpClientAF new];
    });
    return theClient;
}

@end
