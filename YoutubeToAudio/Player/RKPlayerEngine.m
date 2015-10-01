//
//  RKPlayerEngine.m
//  YoutubeToAudio
//
//  Created by ranjith on 24/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import "RKPlayerEngine.h"

static void *RKPlayerRateObservationContext = &RKPlayerRateObservationContext;
static void *RKPlayerStatusObservationContext = &RKPlayerStatusObservationContext;
static void *RKPlayerCurrentItemObservationContext = &RKPlayerCurrentItemObservationContext;

@interface RKPlayerEngine () {
    id mTimeObserver;
    BOOL isSeeking;
    float mRestoreAfterScrubbingRate;
}

@property (nonatomic,strong) AVPlayer *RKPlayer;
@property (nonatomic,strong) AVPlayerItem *RKPlayerItem;
@property (nonatomic,strong) UISlider *seekBar;


@property (nonatomic, assign) BOOL showTimeFrames;
@property (nonatomic, assign) BOOL showTimeHours;
@property (nonatomic, assign) BOOL showMinusSignOnRemainingTime;
@property (nonatomic, assign) CGFloat nbFramesPerSecond;


@end

@implementation RKPlayerEngine


- (void)prepareAssetsToPlay:(NSURL*)mediaURL {
    
    /*
     Create an asset for inspection of a resource referenced by a given URL.
     Load the values for the asset key "playable".
     */
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:mediaURL options:nil];
    
    NSArray *requestedKeys = @[@"playable"];
    
    /* Tells the asset to load the values of any of the specified keys that are not already loaded. */
    [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:
     ^{
         dispatch_async( dispatch_get_main_queue(),
                        ^{
                            /* IMPORTANT: Must dispatch to main queue in order to operate on the AVPlayer and AVPlayerItem. */
                            [self prepareToPlayAsset:asset withKeys:requestedKeys];
                        });
     }];
}


#pragma mark Prepare to play asset, URL

/*
 Invoked at the completion of the loading of the values for all keys on the asset that we require.
 Checks whether loading was successfull and whether the asset is playable.
 If so, sets up an AVPlayerItem and an AVPlayer to play the asset.
 */
- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    /* Make sure that the value of each key has loaded successfully. */
    for (NSString *thisKey in requestedKeys)
    {
        NSError *error = nil;
        AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
        if (keyStatus == AVKeyValueStatusFailed)
        {
            [self assetFailedToPrepareForPlayback:error];
            return;
        }
        /* If you are also implementing -[AVAsset cancelLoading], add your code here to bail out properly in the case of cancellation. */
    }
    
    /* Use the AVAsset playable property to detect whether the asset can be played. */
    if (!asset.playable)
    {
        /* Generate an error describing the failure. */
        NSString *localizedDescription = NSLocalizedString(@"Item cannot be played", @"Item cannot be played description");
        NSString *localizedFailureReason = NSLocalizedString(@"The assets tracks were loaded, but could not be made playable.", @"Item cannot be played failure reason");
        NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   localizedDescription, NSLocalizedDescriptionKey,
                                   localizedFailureReason, NSLocalizedFailureReasonErrorKey,
                                   nil];
        NSError *assetCannotBePlayedError = [NSError errorWithDomain:@"StitchedStreamPlayer" code:0 userInfo:errorDict];
        
        /* Display the error to the user. */
        [self assetFailedToPrepareForPlayback:assetCannotBePlayedError];
        
        return;
    }
    
    /* At this point we're ready to set up for playback of the asset. */
    
    /* Stop observing our prior AVPlayerItem, if we have one. */
    if (self.RKPlayerItem)
    {
        /* Remove existing player item key value observers and notifications. */
        
        [self.RKPlayerItem removeObserver:self forKeyPath:@"status"];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.RKPlayerItem];
    }
    
    /* Create a new instance of AVPlayerItem from the now successfully loaded AVAsset. */
    self.RKPlayerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    /* Observe the player item "status" key to determine when it is ready to play. */
    [self.RKPlayerItem addObserver:self
                          forKeyPath:@"status"
                             options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                             context:RKPlayerStatusObservationContext];
    
    /* When the player item has played to its end time we'll toggle
     the movie controller Pause button to be the Play button */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.RKPlayerItem];
    
//    seekToZeroBeforePlay = NO;
    
    /* Create new player, if we don't already have one. */
    if (!self.RKPlayer)
    {
        /* Get a new AVPlayer initialized to play the specified player item. */
        [self setRKPlayer:[AVPlayer playerWithPlayerItem:self.RKPlayerItem]];
        
        /* Observe the AVPlayer "currentItem" property to find out when any
         AVPlayer replaceCurrentItemWithPlayerItem: replacement will/did
         occur.*/
        [self.RKPlayer addObserver:self
                          forKeyPath:@"currentItem"
                             options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                             context:RKPlayerCurrentItemObservationContext];
        
        /* Observe the AVPlayer "rate" property to update the scrubber control. */
        [self.RKPlayer addObserver:self
                          forKeyPath:@"rate"
                             options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                             context:RKPlayerRateObservationContext];
    }
    
    /* Make our new AVPlayerItem the AVPlayer's current item. */
    if (self.RKPlayer.currentItem != self.RKPlayerItem)
    {
        /* Replace the player item with a new player item. The item replacement occurs
         asynchronously; observe the currentItem property to find out when the
         replacement will/did occur
         
         If needed, configure player item here (example: adding outputs, setting text style rules,
         selecting media options) before associating it with a player
         */
        [self.RKPlayer replaceCurrentItemWithPlayerItem:self.RKPlayerItem];
        
        //        [self syncPlayPauseButtons];
    }
    
//    [self.mScrubber setValue:0.0];
}


#pragma mark Error Handling - Preparing Assets for Playback Failed

/* --------------------------------------------------------------
 **  Called when an asset fails to prepare for playback for any of
 **  the following reasons:
 **
 **  1) values of asset keys did not load successfully,
 **  2) the asset keys did load successfully, but the asset is not
 **     playable
 **  3) the item did not become ready to play.
 ** ----------------------------------------------------------- */

-(void)assetFailedToPrepareForPlayback:(NSError *)error
{
//    [self removePlayerTimeObserver];
    [self syncScrubber];
//    [self disableScrubber];
    //    [self disablePlayerButtons];
    
    /* Display the error. */
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
//                                                        message:[error localizedFailureReason]
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//    [alertView show];
}


#pragma mark Key Value Observer for player rate, currentItem, player item status

/* ---------------------------------------------------------
 **  Called when the value at the specified key path relative
 **  to the given object has changed.
 **  Adjust the movie play and pause button controls when the
 **  player item "status" value changes. Update the movie
 **  scrubber control when the player item is ready to play.
 **  Adjust the movie scrubber control when the player item
 **  "rate" value changes. For updates of the player
 **  "currentItem" property, set the AVPlayer for which the
 **  player layer displays visual output.
 **  NOTE: this method is invoked on the main queue.
 ** ------------------------------------------------------- */

- (void)observeValueForKeyPath:(NSString*) path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
    /* AVPlayerItem "status" property value observer. */
    if (context == RKPlayerStatusObservationContext)
    {
        //        [self syncPlayPauseButtons];
        
        AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status)
        {
                /* Indicates that the status of the player is not yet known because
                 it has not tried to load new media resources for playback */
            case AVPlayerItemStatusUnknown:
            {
                [self removePlayerTimeObserver];
                [self syncScrubber];
                
//                [self disableScrubber];
                // [self disablePlayerButtons];
            }
                break;
                
            case AVPlayerItemStatusReadyToPlay:
            {
                /* Once the AVPlayerItem becomes ready to play, i.e.
                 [playerItem status] == AVPlayerItemStatusReadyToPlay,
                 its duration can be fetched from the item. */
                
                [self.RKPlayer play];
                Float64 duration = CMTimeGetSeconds(self.RKPlayer.currentItem.duration);
                NSLog(@"%f",duration);
                
                [self initScrubberTimer];
                [self updateDuration];
                
//                [self enableScrubber];
                //  [self enablePlayerButtons];
            }
                break;
                
            case AVPlayerItemStatusFailed:
            {
                AVPlayerItem *playerItem = (AVPlayerItem *)object;
                //  [self assetFailedToPrepareForPlayback:playerItem.error];
            }
                break;
        }
    }
    /* AVPlayer "rate" property value observer. */
    else if (context == RKPlayerRateObservationContext)
    {
        if([self.RKPlayer rate]) {
            // change to pause
            [self.updatesDelegate changePlayAndPauseString:@"Pause"];
        }
        else {
            // change to play
            [self.updatesDelegate changePlayAndPauseString:@"Play"];
        }
        
        //        [self syncPlayPauseButtons];
    }
    /* AVPlayer "currentItem" property observer.
     Called when the AVPlayer replaceCurrentItemWithPlayerItem:
     replacement will/did occur. */
    else if (context == RKPlayerCurrentItemObservationContext)
    {
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        
        /* Is the new player item null? */
        if (newPlayerItem == (id)[NSNull null])
        {
            //            [self disablePlayerButtons];
//            [self disableScrubber];
        }
        else /* Replacement of player currentItem has occurred */
        {
            /* Set the AVPlayer for which the player layer displays visual output. */
            //            [self.mPlaybackView setPlayer:mPlayer];
            
//            [self setViewDisplayName];
            
            /* Specifies that the player should preserve the video’s aspect ratio and
             fit the video within the layer’s bounds. */
            //            [self.mPlaybackView setVideoFillMode:AVLayerVideoGravityResizeAspect];
            
            //            [self syncPlayPauseButtons];
        }
    }
    else
    {
        [super observeValueForKeyPath:path ofObject:object change:change context:context];
    }
}



/* Called when the player item has played to its end time. */
- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    /* After the movie has played to its end time, seek back to time zero
     to play it again. */
//    seekToZeroBeforePlay = YES;
}



#pragma mark Movie scrubber control

/* ---------------------------------------------------------
 **  Methods to handle manipulation of the movie scrubber control
 ** ------------------------------------------------------- */

/* Requests invocation of a given block during media playback to update the movie scrubber control. */
-(void)initScrubberTimer {
    
    double interval = .1f;
    
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        return;
    }
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration))
    {
        CGFloat width = CGRectGetWidth([self.seekBar bounds]);
        interval = 0.5f * duration / width;
    }
    
    /* Update the scrubber during normal playback. */
    __weak RKPlayerEngine *weakSelf = self;
    mTimeObserver = [self.RKPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)
                                                                queue:NULL /* If you pass NULL, the main queue is used. */
                                                           usingBlock:^(CMTime time)
                     {
                         [weakSelf syncScrubber];
                         float totalSecond = CMTimeGetSeconds(time);
                         int minute = (int)totalSecond / 60;
                         int second = (int)totalSecond % 60;
                         [weakSelf.updatesDelegate currentTime:[NSString stringWithFormat:@"%02d:%02d", minute, second]];
                     }];
}



/* Set the scrubber based on the player current time. */
- (void)syncScrubber
{
    [self updateDuration];
    
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        self.seekBar.minimumValue = 0.0;
        return;
    }
    
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration))
    {
        float minValue = [self.seekBar minimumValue];
        float maxValue = [self.seekBar maximumValue];
        double time = CMTimeGetSeconds([self.RKPlayer currentTime]);
        
        float updatedValue = (maxValue - minValue) * time / duration + minValue;
        
        [self.updatesDelegate updateSeekBarValue:updatedValue];
    }
}


#pragma mark - Protocol Implementations

- (void)playMediaWithURL:(NSURL*)mediaURL withSlider:(UISlider *)slider {
    self.seekBar = slider;
    [self prepareAssetsToPlay:mediaURL];
}

- (void)play {
    [self.RKPlayer play];
}

- (float)rate {
   return self.RKPlayer.rate;
}

- (void)pause {
    [self.RKPlayer pause];
}

- (BOOL)playerStarted {
    return self.RKPlayer.currentItem ? YES : NO;
}

- (void)removePlayerObservers {
    [self removePlayerTimeObserver];
    
    [self.RKPlayer removeObserver:self forKeyPath:@"rate"];
    [self.RKPlayer.currentItem removeObserver:self forKeyPath:@"status"];
    
    [self.RKPlayer pause];
}

/* ---------------------------------------------------------
 **  Get the duration for a AVPlayerItem.
 ** ------------------------------------------------------- */

- (CMTime)playerItemDuration
{
    AVPlayerItem *playerItem = [self.RKPlayer currentItem];
    if (playerItem.status == AVPlayerItemStatusReadyToPlay)
    {
        return([playerItem duration]);
    }
    
    return(kCMTimeInvalid);
}


- (void)scrub:(CMTime)time :(void (^)(BOOL))block {
    [self.RKPlayer seekToTime:time completionHandler:^(BOOL finished) {
        block(NO);
    }];
}

- (void)beginscrub {
    mRestoreAfterScrubbingRate = [self.RKPlayer rate];
    [self.RKPlayer setRate:0.f];
    
    /* Remove previous timer. */
    [self removePlayerTimeObserver];

}

- (void)endScrub:(CMTime)time withSlider:(UISlider *)slider {
    self.seekBar = slider;
    __weak RKPlayerEngine *weakSelf = self;
    mTimeObserver = [self.RKPlayer addPeriodicTimeObserverForInterval:time queue:NULL usingBlock:
                     ^(CMTime time)
                     {
                         [weakSelf syncScrubber];
                         float totalSecond = CMTimeGetSeconds(time);
                         int minute = (int)totalSecond / 60;
                         int second = (int)totalSecond % 60;
                         [weakSelf.updatesDelegate currentTime:[NSString stringWithFormat:@"%02d:%02d", minute, second]];
                     }];
    
    if (mRestoreAfterScrubbingRate)
    {
        [self.RKPlayer setRate:mRestoreAfterScrubbingRate];
        mRestoreAfterScrubbingRate = 0.f;
    }
}


/* Cancels the previously registered time observer. */
-(void)removePlayerTimeObserver
{
    if (mTimeObserver)
    {
        [self.RKPlayer removeTimeObserver:mTimeObserver];
        mTimeObserver = nil;
    }
}

- (void)updateDuration {

    CGFloat nbSecondsElapsed;
    CGFloat nbSecondsDuration = 0;
    CGFloat ratio = 0;
    
    if(self.RKPlayer.currentItem == nil)
        return;
    
    nbSecondsElapsed = CMTimeGetSeconds(self.RKPlayer.currentItem.currentTime);
    if(CMTIME_IS_VALID(self.RKPlayer.currentItem.duration) && !CMTIME_IS_INDEFINITE(self.RKPlayer.currentItem.duration))
    {
        nbSecondsDuration = CMTimeGetSeconds(self.RKPlayer.currentItem.duration);
    }
    
    if(nbSecondsDuration != 0)
    {
        ratio = nbSecondsElapsed/nbSecondsDuration;
        [self updateDurationLabelWithTime:nbSecondsDuration];
    }
    
}

- (void)updateDurationLabelWithTime:(NSTimeInterval)time {
    [self.updatesDelegate duration:[self timecodeForTimeInterval:time]];
}

- (NSString *)timecodeForTimeInterval:(NSTimeInterval)time
{
    NSInteger seconds;
    NSInteger hours;
    NSInteger minutes;
    CGFloat milliseconds;
    NSInteger nbFrames = 0;
    NSString *timecode;
    NSString *sign;
    
    sign = ((time < 0) && self.showMinusSignOnRemainingTime?@"\u2212":@"");
    time = ABS(time);
    hours = time/60/24;
    minutes = (time - hours*24)/60;
    seconds = (time - hours*24) - minutes*60;
    
    if(self.showTimeFrames)
    {
        milliseconds = time - (NSInteger)time;
        nbFrames = milliseconds*self.nbFramesPerSecond;
    }
    
    if((hours > 0) || self.showTimeHours)
    {
        if(self.showTimeFrames)
        {
            timecode = [NSString stringWithFormat:@"%@%d:%02d:%02d:%02d", sign, (int)hours, (int)minutes, (int)seconds, (int)nbFrames];
        }
        else
        {
            timecode = [NSString stringWithFormat:@"%@%d:%02d:%02d", sign, (int)hours, (int)minutes, (int)seconds];
        }
    }
    else
    {
        if(self.showTimeFrames)
        {
            timecode = [NSString stringWithFormat:@"%@%02d:%02d:%02d", sign, (int)minutes, (int)seconds, (int)nbFrames];
        }
        else
        {
            timecode = [NSString stringWithFormat:@"%@%02d:%02d", sign, (int)minutes, (int)seconds];
        }
    }
    
    return timecode;
}

@end
