//
//  DataModel.m
//  YoutubeToAudio
//
//  Created by ranjith on 17/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import "DataModel.h"

@interface DataModel()

// The backing dictionary
@property (strong, readwrite, nonatomic) NSMutableDictionary* serverDictionary;

@end

@implementation DataModel

@synthesize hasImage = _hasImage;
@synthesize filtered = _filtered;
@synthesize failed = _failed;


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

- (void)setTitle:(NSString *)title {
    NSString *path = [NSString stringWithFormat:@"snippet.title"];
    [self.serverDictionary setValue:title forKeyPath:path];
}

- (NSString *)title {
    NSString *path = [NSString stringWithFormat:@"snippet.title"];
    return [self.serverDictionary valueForKeyPath:path];
}

- (NSString *)videoId {
    NSString *path = [NSString stringWithFormat:@"id.videoId"];
    return [self.serverDictionary valueForKeyPath:path];
}

- (void)setThumbnailUrl:(NSString *)thumbnailUrl {
    NSString *path = [NSString stringWithFormat:@"snippet.thumbnails.high.url"];
    [self.serverDictionary setValue:thumbnailUrl forKeyPath:path];
}

- (NSString *)thumbnailUrl {
    NSString *path = [NSString stringWithFormat:@"snippet.thumbnails.high.url"];
    return [self.serverDictionary valueForKeyPath:path];
}

- (NSString *)videoDescription {
    NSString *path = [NSString stringWithFormat:@"snippet.description"];
    return [self.serverDictionary valueForKeyPath:path];
}

- (void)setVideoDuration:(NSString *)videoDuration {
    [self.serverDictionary setObject:videoDuration forKey:@"duration"];
}

- (NSString *)videoDuration {
    return self.serverDictionary[@"duration"];
}

- (NSString *)kind {
    return self.serverDictionary[@"kind"];
}

- (NSString *)channelTitle {
    NSString *keyPath = [NSString stringWithFormat:@"snippet.channelTitle"];
    return [self.serverDictionary valueForKeyPath:keyPath];
}

- (NSString *)publishedAt {
    NSString *keyPath = [NSString stringWithFormat:@"snippet.publishedAt"];
    return [self.serverDictionary valueForKeyPath:keyPath];
}



- (BOOL)hasImage {
    return _videoImage != nil;
}


- (BOOL)isFailed {
    return _failed;
}


- (BOOL)isFiltered {
    return _filtered;
}


@end
