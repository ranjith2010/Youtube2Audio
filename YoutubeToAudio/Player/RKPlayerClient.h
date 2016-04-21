//
//  RKPlayerClient.h
//  YoutubeToAudio
//
//  Created by ranjith on 24/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;

/*!
 @abstract:This protocol response is update any UI related stuff.
 This communication will happen when ever player changes any status.
 */
@protocol uiUpdatesProtocol <NSObject>

/*!
 @brief:Here the button label will change Play OR Pause
        It will trig Once the player has been started
 @param:status Its String value
 */
- (void)changePlayAndPauseString:(NSString*)status;

/*!
 @brief:Here the Slider value will change based on Player.rate
 @param:value its Player rate value
 */
- (void)updateSeekBarValue:(float)value;


- (void)duration:(NSString*)totalTime;

- (void)currentTime:(NSString *)time;

@end


/*!
 The protocol that should be implemented by Player Engine
 This is specific to Play a Media through AVPlayer
 */
@protocol RKPlayerAPIClientProtocol <NSObject>
@required

/*!
 @brief:This Protocol will simply start play with media URL
        Here We are going to create a Brand New AVPlayer.
 @param:mediaURL as a NSURL object
 @param:Slider Its a UI property of custom Tableview cell
 */
- (void)playMediaWithURL:(NSURL*)mediaURL withSlider:(UISlider *)slider;

/*!
 @brief:It will give us player has been started or not
 @return:Bool value of Player state
 */
- (BOOL)playerStarted;

/*!
 @brief:It will simply play. Actually this method indicates when player in 'Paused' state
 */
- (void)play;

/*!
 @brief:This Protocol will simply Pasue the AVPlayer
 @return:BOOL value, whether its Paused or Not?
 */
- (void)pause;

/*!
 @brief:This Protocol will Stop the AVPlayer
 @return:BOOL value, whether its Stopped or Not?
 */
- (BOOL)stop;

/*!
 @brief:It indicates the current rate of playback
 @return:float player rate
 */
- (float)rate;

/*!
 @brief:This one helps to remove the player observers
 */
- (void)removePlayerObservers;

/*!
 @brief:This method will retun the Player duration. 
        i think it will calculate and give the media total duration
 @return:CMTime total time of media
 */
- (CMTime)playerItemDuration;

/*!
 @brief:This will trigg when scrub i mean Slider start
 */
- (void)beginscrub;

/*!
 @brief:Here we want to keep the slide status and seeking time
 @param:time Its a timewithSeconds of slider
 @param:The completion block ,It will give us its seeking or not?
 */
- (void)scrub:(CMTime)time :(void(^)(BOOL isSeeking))block;

/*!
 @brief:This will trigg Once you touch ended on slider. i mean Dragging has done
 @param:time its a timeWithSeconds of slider
 @param:slider its a Ui element from custom cell
 */
- (void)endScrub:(CMTime)time withSlider:(UISlider*)slider;




#pragma mark Streaming Section




@property (nonatomic,weak) id<uiUpdatesProtocol> updatesDelegate;

@end
@interface RKPlayerClient : NSObject

+ (id<RKPlayerAPIClientProtocol>)sharedInstance;


@end
