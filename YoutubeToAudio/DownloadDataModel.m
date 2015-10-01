//
//  DownloadDataModel.m
//  YoutubeToAudio
//
//  Created by ranjith on 17/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import "DownloadDataModel.h"

@interface DownloadDataModel ()

// The backing dictionary
@property (strong, readwrite, nonatomic) NSMutableDictionary* serverDictionary;

@end


@implementation DownloadDataModel


- (id)init {
    self = [super init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [self setServerDictionary:[NSMutableDictionary dictionaryWithDictionary:dict]];
    return self;
}

- (id)initWithServerDictionary:(NSDictionary*)dictionary {
    self = [super init];
    [self setServerDictionary:[NSMutableDictionary dictionaryWithDictionary:dictionary]];
    return self;
}

- (NSDictionary*)dictionary {
    return self.serverDictionary;
}

- (NSString *)format {
    return self.serverDictionary[@"format"];
}

- (NSString *)extension {
    return self.serverDictionary[@"ext"];
}

- (NSString *)downloadUrl {
    return self.serverDictionary[@"url"];
}



@end
