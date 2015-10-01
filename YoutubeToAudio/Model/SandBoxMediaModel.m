//
//  SandBoxMediaModel.m
//  YoutubeToAudio
//
//  Created by ranjith on 24/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import "SandBoxMediaModel.h"

@interface SandBoxMediaModel()

// The backing dictionary
@property (strong, readwrite, nonatomic) NSMutableDictionary* serverDictionary;

@end

@implementation SandBoxMediaModel


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

- (void)setName:(NSString *)name {
    [self.serverDictionary setValue:name forKey:@"name"];
}

- (NSString *)name {
    return self.serverDictionary[@"name"];
}

- (void)setUrl:(NSString *)url {
    [self.serverDictionary setValue:url forKey:@"url"];
}

- (NSString *)url {
    return self.serverDictionary[@"url"];
}


@end
