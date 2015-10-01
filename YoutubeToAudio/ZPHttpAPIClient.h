//
//  ZPHttpClient.h
//  Zippr
//
//  Created by totaramudu on 03/08/15.
//  Copyright (c) 2015 Zippr. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 The success response block.
 @param task The NSURLSessionTask associated with this request. 
 @param response The zippr server response. This will be either NSDictionary or an NSArray. 
        Note that this is not the exact json but the value of <JSON>.response
 */
typedef void(^ZPHttpClientSuccessResponseBlock)(NSURLSessionTask* task, id response);

/*!
 The failure response block.
 @param task The NSURLSessionTask associated with this request.
 @param error The zippr app error. The server error code is mapped to error codes in ZPErrors.h.
        Error code is the app understood error code as defined in ZPErrors.h
        The userInfo can have the following items
        NSLocalizedFailureReasonErrorKey holds the server description of the error.
        ZPErrorUserInfoKeyOriginalError holds the original NSError. This is only for debug purpose.
        ZPErrorUserInfoKeyErrorJSON holds the error JSON. This is only for debug purpose.
 */
typedef void(^ZPHttpClientFailureResponseBlock)(NSURLSessionTask* task, NSError* error);

/*!
 The protocol that should be implemented by Http client .
 This is specific to Zippr Server REST api.
 */
@protocol ZPHttpAPIClientProtocol <NSObject>
@required

- (void)setOnetimeRequestTimeout:(int)timeout;

- (void)setValue:(NSString*)value forHeaderField:(NSString*)header;

- (NSURLSessionTask*)performGET:(NSString*)url
                      withQuery:(NSDictionary*)queryParams
                        success:(ZPHttpClientSuccessResponseBlock)successBlock
                        failure:(ZPHttpClientFailureResponseBlock)failureBlock;

- (NSURLSessionTask*)performPOST:(NSString*)url
                        withBody:(NSDictionary*)queryParams
                         success:(ZPHttpClientSuccessResponseBlock)successBlock
                         failure:(ZPHttpClientFailureResponseBlock)failureBlock;

- (NSURLSessionTask*)performPUT:(NSString*)url
                       withBody:(NSDictionary*)queryParams
                        success:(ZPHttpClientSuccessResponseBlock)successBlock
                        failure:(ZPHttpClientFailureResponseBlock)failureBlock;

- (NSURLSessionTask*)performDELETE:(NSString*)url
                         withQuery:(NSDictionary*)queryParams
                           success:(ZPHttpClientSuccessResponseBlock)successBlock
                           failure:(ZPHttpClientFailureResponseBlock)failureBlock;
- (NSURLSessionTask*)performPOST:(NSString*)url
                        withBody:(NSDictionary*)body
                   withImageData:(NSDictionary*)imageData
                         success:(ZPHttpClientSuccessResponseBlock)successBlock
                         failure:(ZPHttpClientFailureResponseBlock)failureBlock;

@end

@interface ZPHttpAPIClient : NSObject

+ (id<ZPHttpAPIClientProtocol>)sharedInstance;

@end
