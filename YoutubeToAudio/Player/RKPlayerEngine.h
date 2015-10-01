//
//  RKPlayerEngine.h
//  YoutubeToAudio
//
//  Created by ranjith on 24/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RKPlayerClient.h"
#warning add .PCH file
#import <UIKit/UIKit.h>


@interface RKPlayerEngine : NSObject<RKPlayerAPIClientProtocol>

@property (nonatomic,weak) id<uiUpdatesProtocol> updatesDelegate;

@end
