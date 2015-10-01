//
//  ZPHttpClientAF.h
//  Zippr
//
//  Created by totaramudu on 29/07/15.
//  Copyright (c) 2015 Zippr. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "ZPHttpAPIClient.h"

/*!
 The AF networking implementation of ZPHttpAPIClientProtocol
 */
@interface ZPHttpClientAF : AFHTTPSessionManager <ZPHttpAPIClientProtocol>
@end
