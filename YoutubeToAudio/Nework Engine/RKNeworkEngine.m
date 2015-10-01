//
//  RKNeworkEngine.m
//  YoutubeToAudio
//
//  Created by ranjith on 25/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import "RKNeworkEngine.h"
#import "AFNetworking.h"


@interface RKNeworkEngine ()

@property (nonatomic,strong) NSString *pageToken;

@end

@implementation RKNeworkEngine

- (void)fetchYTVideoMetaDataWithVideoID:(DataModel*)dataModel {
    NSString *baseURLString = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/videos?id=%@&part=contentDetails&key=AIzaSyCYXlcV2F22Jsw5J_5KVWa3eYKd9oQiraw",dataModel.videoId];
    NSURL *finalURL = [NSURL URLWithString:baseURLString];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:finalURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:@"weather.php" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
     
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void)fetchYoutubeVideosWithSearchQuery:(NSString*)query isFreshQuery:(BOOL)isFresh
                               fetchCount:(int)fetchCount
                                         :(void(^)(NSArray *models,NSError *error))block  {
    
    NSString *finalString;
    if(!isFresh) {
    finalString= [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&key=AIzaSyCYXlcV2F22Jsw5J_5KVWa3eYKd9oQiraw&maxResults=%d&q=%@&type=video&pageToken=%@",fetchCount,query,self.pageToken];
    }
    else {
        finalString= [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&key=AIzaSyCYXlcV2F22Jsw5J_5KVWa3eYKd9oQiraw&maxResults=%d&q=%@&type=video",fetchCount,query];
    }
    
    NSURL *url = [NSURL URLWithString:finalString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation
                                               , id responseObject) {
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        
        self.pageToken = json[@"nextPageToken"];
        
        NSArray *items = json[@"items"];
        NSMutableArray *buffer = [NSMutableArray new];
        
        for(NSDictionary *item in items) {
            DataModel *model = [[DataModel alloc]initWithServerDictionary:item];
            [buffer addObject:model];
        }
        
        block(buffer,nil);
        
        // code
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // code
        block(nil,error);
    }
     ];
    [operation start];
}


- (void)fetchMostPopularVideosWithFetchCount:(int)fetchCount isFreshQuery:(BOOL)isFresh :(void (^)(NSArray *, NSError *))block {
    
    NSString *finalString;
    
    if(!isFresh) {
        finalString = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&chart=mostPopular&key=AIzaSyCYXlcV2F22Jsw5J_5KVWa3eYKd9oQiraw&maxResults=%d&type=video&pageToken=%@",fetchCount,self.pageToken];
    }
    else {
        finalString = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&chart=mostPopular&key=AIzaSyCYXlcV2F22Jsw5J_5KVWa3eYKd9oQiraw&maxResults=%d&type=video",fetchCount];
    }
    
    NSURL *url = [NSURL URLWithString:finalString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation
                                               , id responseObject) {
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        self.pageToken = json[@"nextPageToken"];
        NSArray *items = json[@"items"];
        NSMutableArray *buffer = [NSMutableArray new];
        
        for(NSDictionary *item in items) {
            DataModel *model = [[DataModel alloc]initWithServerDictionary:item];
            [buffer addObject:model];
        }

        block(buffer,nil);
        // code
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // code
        block(nil,error);
    }
     ];
    [operation start];
}


- (void)fetchVideoDetails:(DataModel*)model :(void(^)(DataModel *dataModel,NSError *error))block {
    
   NSString *finalString = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/videos?id=%@&part=contentDetails&key=AIzaSyCYXlcV2F22Jsw5J_5KVWa3eYKd9oQiraw",model.videoId];
    NSURL *url = [NSURL URLWithString:finalString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation
                                               , id responseObject) {
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        NSArray *items = json[@"items"];
        NSDictionary *firstObject = items.firstObject;
        model.videoDuration = [self parseDuration:firstObject[@"contentDetails"][@"duration"]];
        NSLog(@"%@",model.videoDuration);
        block(model,nil);
        // code
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // code
        block(model,nil);
    }
     ];
    [operation start];
}


- (NSString *)parseDuration:(NSString *)duration {
    NSInteger hours = 0;
    NSInteger minutes = 0;
    NSInteger seconds = 0;
    
    NSRange timeRange = [duration rangeOfString:@"T"];
    duration = [duration substringFromIndex:timeRange.location];
    
    while (duration.length > 1) {
        duration = [duration substringFromIndex:1];
        
        NSScanner *scanner = [NSScanner.alloc initWithString:duration];
        NSString *part = [NSString.alloc init];
        [scanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&part];
        
        NSRange partRange = [duration rangeOfString:part];
        
        duration = [duration substringFromIndex:partRange.location + partRange.length];
        
        NSString *timeUnit = [duration substringToIndex:1];
        if ([timeUnit isEqualToString:@"H"])
            hours = [part integerValue];
        else if ([timeUnit isEqualToString:@"M"])
            minutes = [part integerValue];
        else if ([timeUnit isEqualToString:@"S"])
            seconds = [part integerValue];
    }
    
    NSString *finalTime;
    if(hours){
        finalTime = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
    }
    else {
        finalTime = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
    }
    return finalTime;
}

@end
