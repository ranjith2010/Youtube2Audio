//
//  ZPHttpClientAF.m
//  Zippr
//
//  Created by totaramudu on 29/07/15.
//  Copyright (c) 2015 Zippr. All rights reserved.
//

#import "ZPHttpClientAF.h"

const uint kStandardTimeoutInSec                =   12;

NSString * const HTTPGET                        =   @"GET";
NSString * const HTTPPOST                       =   @"POST";
NSString * const HTTPPUT                        =   @"PUT";
NSString * const HTTPDEL                        =   @"DEL";
NSString * const HTTPMULTIPART                  =   @"MULTIPART";


#pragma mark - Success and Error response keys
NSString * const kResponseOkKey                 =   @"ok";
NSString * const kResponseKey                   =   @"response";
NSString * const kResponseErrorKey              =   @"error";
NSString * const kResponseErrorDescKey          =   @"description";

typedef void(^ZPSuccessResponseBlock_AF)(NSURLSessionDataTask *task, id responseObject);
typedef void(^ZPFailureResponseBlock_AF)(NSURLSessionDataTask *task, NSError *error);

@interface ZPHttpClientAF ()
@property (nonatomic) NSURL* serverBaseUrl;
@property (nonatomic) uint oneTimeTimeout;
@end

@implementation ZPHttpClientAF

- (instancetype)init {
    NSURL* baseUrl = [NSURL URLWithString:@"https://www.googleapis.com/youtube/v3/videos?"];
    self = [super initWithBaseURL:baseUrl];
    if (self) {
        self.serverBaseUrl = baseUrl;
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.requestSerializer.timeoutInterval = kStandardTimeoutInSec;
        [self setValue:@"application/json" forHeaderField:@"Content-Type"];
//        [self setValue:@"contentDetails" forKey:@"part"];
//        [self setValue:@"AIzaSyCYXlcV2F22Jsw5J_5KVWa3eYKd9oQiraw" forHeaderField:@"key"];
        // Session key will be set by the caller according to user onboarding logic.
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];

        policy.allowInvalidCertificates = YES;
        [policy setValidatesDomainName:NO];

        self.securityPolicy = policy;
    }
    return self;
}

- (void)setOnetimeRequestTimeout:(int)timeout {
    self.oneTimeTimeout = timeout;
}

- (void)setValue:(NSString*)value forHeaderField:(NSString*)header {
    [self.requestSerializer setValue:value forHTTPHeaderField:header];
}

- (NSURLSessionTask*)performGET:(NSString*)url
                      withQuery:(NSDictionary*)queryParams
                        success:(ZPHttpClientSuccessResponseBlock)successBlock
                        failure:(ZPHttpClientFailureResponseBlock)failureBlock {
    return [self _perform:HTTPGET withUrl:url withParams:queryParams withIamgeData:nil success:successBlock failure:failureBlock];
}


- (NSURLSessionTask*)performPOST:(NSString*)url
                        withBody:(NSDictionary*)body
                         success:(ZPHttpClientSuccessResponseBlock)successBlock
                         failure:(ZPHttpClientFailureResponseBlock)failureBlock {
    
    return [self _perform:HTTPPOST withUrl:url withParams:body withIamgeData:nil success:successBlock failure:failureBlock];
}

- (NSURLSessionTask*)performPOST:(NSString*)url
                        withBody:(NSDictionary*)body
                   withImageData:(NSDictionary*)imageData
                         success:(ZPHttpClientSuccessResponseBlock)successBlock
                         failure:(ZPHttpClientFailureResponseBlock)failureBlock
{
    return [self _perform:HTTPMULTIPART withUrl:url withParams:body withIamgeData:imageData success:successBlock failure:failureBlock];
}


- (NSURLSessionTask*)performPUT:(NSString*)url
                       withBody:(NSDictionary*)body
                        success:(ZPHttpClientSuccessResponseBlock)successBlock
                        failure:(ZPHttpClientFailureResponseBlock)failureBlock {
    return [self _perform:HTTPPUT withUrl:url withParams:body withIamgeData:nil success:successBlock failure:failureBlock];
}

- (NSURLSessionTask*)performDELETE:(NSString*)url
                         withQuery:(NSDictionary*)queryParams
                           success:(ZPHttpClientSuccessResponseBlock)successBlock
                           failure:(ZPHttpClientFailureResponseBlock)failureBlock {
    return [self _perform:HTTPDEL withUrl:url withParams:queryParams withIamgeData:nil success:successBlock failure:failureBlock];
}

#pragma mark - Private

- (NSString*)urlForRoute:(NSString*)route {
    if ([[route lowercaseString] hasPrefix:@"http"]) {
        return route;
    } else {
#warning need to implement in further network calls
//        NSString* urlStr = [[self.serverBaseUrl URLByAppendingPathComponent:route] absoluteString];
        return route;;
    }
}

/*!
 Performs a http request. 
 @param verb The http verb as defined in HTTP*
 @param url The request url.
 @param params The query or body params
 @param success The success block.
 @param failure The failure block.
 */
- (NSURLSessionTask*)_perform:(NSString*)verb
                         withUrl:(NSString*)url
                      withParams:(NSDictionary*)params
                   withIamgeData:(NSDictionary*)imageDict
                         success:(ZPHttpClientSuccessResponseBlock)successBlock
                         failure:(ZPHttpClientFailureResponseBlock)failureBlock {
    
    [self prepareRequest:self.requestSerializer];
    ZPSuccessResponseBlock_AF success = [self successProxyBlock:successBlock];
    ZPFailureResponseBlock_AF failure = [self failureProxyBlock:failureBlock];
    NSURLSessionTask* sessionTask;
    NSString* absUrl = [self urlForRoute:url];
    
#ifdef TEST_DUMP_REQUEST_RESPONSE
    NSLog(@"----- Request dump starts -----");
    NSLog(@"%@ url:%@", verb, absUrl);
    NSLog(@"Headers %@", self.requestSerializer.HTTPRequestHeaders);
    NSLog(@"params: %@", params);
    NSLog(@"----- Request dump end  -----");
#endif
    
    if ([verb isEqualToString:HTTPGET]) {
        sessionTask = [self GET:absUrl
                     parameters:params
                        success:success
                        failure:failure];
    }
    
    else if ([verb isEqualToString:HTTPPOST]) {
        sessionTask = [self POST:absUrl
                     parameters:params
                        success:success
                        failure:failure];
    }
    
    else if ([verb isEqualToString:HTTPPUT]) {
        sessionTask = [self PUT:absUrl
                     parameters:params
                        success:success
                        failure:failure];
    }
    
    else if ([verb isEqualToString:HTTPDEL]) {
        sessionTask = [self DELETE:absUrl
                     parameters:params
                        success:success
                        failure:failure];
    }
    
    else if ([verb isEqualToString:HTTPMULTIPART]) {
        sessionTask = [self POST:absUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//            NSData *imageData = UIImageJPEGRepresentation(imageDict[kZPServerZipprImage], 0.7);
//            [formData appendPartWithFileData:imageData name:@"image" fileName:[imageDict[kZPServerZipprImagePath] lastPathComponent] mimeType:@"image/jpeg"];
        } success:success failure:failure];
    }
    
    else {
        [NSException raise:NSInvalidArgumentException
                    format:@"Unsupported http verb %@", verb];
        return nil;
    }
    
    return sessionTask;
}

/*!
 Should be called before making the request.
 */
- (void)prepareRequest:(AFHTTPRequestSerializer*)requestSerializer {
    if (self.oneTimeTimeout != kStandardTimeoutInSec) {
        requestSerializer.timeoutInterval = self.oneTimeTimeout;
        self.oneTimeTimeout = kStandardTimeoutInSec;
    } else {
        requestSerializer.timeoutInterval = kStandardTimeoutInSec;
    }
}

/*!
 The success proxy block.
 */
- (ZPSuccessResponseBlock_AF)successProxyBlock:(ZPHttpClientSuccessResponseBlock)success {
    // Do any operations common to all success response.
    ZPSuccessResponseBlock_AF successBlock = ^(NSURLSessionDataTask *task, id responseObject) {
        
#ifdef TEST_DUMP_REQUEST_RESPONSE
      NSLog(@"----- Success response dump starts -----");
        NSLog(@"%@", task.originalRequest.URL);
        NSLog(@"response: %@", responseObject);
        NSLog(@"sent: %.3f KB", ((double)task.countOfBytesSent/1024));
        NSLog(@"received: %.3f KB", ((double)task.countOfBytesReceived/1024));
      NSLog(@"----- Success response dump ends -----");
#endif
        
        if (success) {
            NSDictionary* result = (NSDictionary*)responseObject;
            id response = result[kResponseKey];
            success(task, response);
        }
    };
    return successBlock;
}

/*!
 The failure block
 */
- (ZPFailureResponseBlock_AF)failureProxyBlock:(ZPHttpClientFailureResponseBlock)failure {
    // Do any operations common to all failure response.
    ZPFailureResponseBlock_AF failureBlock = ^(NSURLSessionDataTask *task, NSError *afError) {
        
#ifdef TEST_DUMP_REQUEST_RESPONSE
        NSLog(@"----- Failure response dump starts -----");
        NSLog(@"%@", task.originalRequest.URL);
        NSLog(@"response: %@", afError);
        NSLog(@"----- Failure response dump ends -----");
#endif
        
        if (failure) {
//            NSError* zipprError = [afError toZipprError];
//            if(zipprError.code == ZPErrorCodeInvalidSession) {
//                [self.operationQueue cancelAllOperations];
//                [[NSNotificationCenter defaultCenter]postNotificationName:kZPLocalNotificationInvalidSession object:nil];
//            }
            failure(task, afError);
        }
    };
    return failureBlock;
}

@end
