//
//  SandBoxMediaModel.h
//  YoutubeToAudio
//
//  Created by ranjith on 24/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SandBoxMediaModel : NSObject

/*!
 Initializes with Server dictionary
 */
- (id)initWithServerDictionary:(NSDictionary*)dictionary;

/*!
 Returns dictionary that can be safely updated to Server.
 This dictionary contains server keys.
 */
- (NSDictionary*)dictionary;

@property (nonatomic,readwrite) NSString *name;
@property (nonatomic,readwrite) NSString *url;

@end
