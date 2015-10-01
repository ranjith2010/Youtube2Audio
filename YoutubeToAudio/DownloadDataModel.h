//
//  DownloadDataModel.h
//  YoutubeToAudio
//
//  Created by ranjith on 17/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadDataModel : NSObject

/*!
 Initializes with Server dictionary
 */
- (id)initWithServerDictionary:(NSDictionary*)dictionary;

/*!
 Returns dictionary that can be safely updated to Server.
 This dictionary contains server keys.
 */
- (NSDictionary*)dictionary;

@property (nonatomic,readonly) NSString *format;
@property (nonatomic,readonly) NSString *extension;
@property (nonatomic,readonly) NSString *downloadUrl;


@end
