//
//  RootTableViewController.h
//  YoutubeToAudio
//
//  Created by ranjith on 17/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking/AFNetworking.h"
#import "RKPendingOperations.h"
#import "RKImageDownloader.h"
#import "RKImageFiltration.h"
#import "DataModel.h"

@interface RootTableViewController : UITableViewController<ImageDownloaderDelegate, ImageFiltrationDelegate>

@property (nonatomic, strong) RKPendingOperations *pendingOperations;


@end
