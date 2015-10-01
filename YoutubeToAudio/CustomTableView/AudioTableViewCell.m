//
//  AudioTableViewCell.m
//  YoutubeToAudio
//
//  Created by ranjith on 24/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import "AudioTableViewCell.h"
#import "RKPlayerClient.h"
#import "RKPlayerEngine.h"


@interface AudioTableViewCell ()<uiUpdatesProtocol> {
    BOOL seekToZeroBeforePlay;
    id mTimeObserver;
    BOOL isSeek;
    float mRestoreAfterScrubbingRate;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *albumArtWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *albumArtHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playingTimeLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *endTimeLeadingConstraint;


@property (nonatomic) BOOL hasResized;

@property (nonatomic,strong)id<RKPlayerAPIClientProtocol>RKPlayerClient;

@end

@implementation AudioTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)feedCellWithObject:(SandBoxMediaModel*)mediaModel {
    self.audioTitle.text = [mediaModel.name stringByDeletingPathExtension];
    self.currentMediaModel = mediaModel;
    
}

- (IBAction)didTapPlayAndPause:(id)sender {

    if(!self.RKPlayerClient) {
        self.RKPlayerClient = [RKPlayerClient sharedInstance];
        self.RKPlayerClient.updatesDelegate = self;
    }
    if([self.RKPlayerClient rate]!=0){
        // Its Playing. So need to Pause
        [self.RKPlayerClient pause];
    }
    else if([self.RKPlayerClient playerStarted]) {
        [self.RKPlayerClient play];
    }
    else {
        NSURL *mediaURL = [NSURL fileURLWithPath:self.currentMediaModel.url];
        [self.RKPlayerClient playMediaWithURL:mediaURL withSlider:self.seekBar];
    }
}

- (void)dealloc {
    [self.RKPlayerClient removePlayerObservers];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    

    // Configure the view for the selected state
}
- (IBAction)didTapAlbumArt:(id)sender {
    if(!self.hasResized) {
        [UIView animateWithDuration:0.50 animations:^{
            self.albumArtHeightConstraint.constant = self.bounds.size.height;
            self.albumArtWidthConstraint.constant = self.bounds.size.width;
            self.hasResized = YES;
        } completion:nil];
    }
    else {
        [UIView animateWithDuration:0.50 animations:^{
            self.albumArtHeightConstraint.constant = 64;
            self.albumArtWidthConstraint.constant = 64;
            self.hasResized = NO;
        } completion:nil];
    }
    
    [self layoutIfNeeded];
}

#pragma mark Movie scrubber control

/* ---------------------------------------------------------
 **  Methods to handle manipulation of the movie scrubber control
 ** ------------------------------------------------------- */


/* The user is dragging the movie controller thumb to scrub through the movie. */
- (IBAction)beginScrubbing:(id)sender
{
    [self.RKPlayerClient beginscrub];
    
}

/* Set the player current time to match the scrubber position. */
- (IBAction)scrub:(id)sender
{
    if ([sender isKindOfClass:[UISlider class]] && !isSeek)
    {
        isSeek = YES;
        UISlider* slider = sender;
        
        CMTime playerDuration = [self.RKPlayerClient playerItemDuration];
        if (CMTIME_IS_INVALID(playerDuration)) {
            return;
        }
        
        double duration = CMTimeGetSeconds(playerDuration);
        if (isfinite(duration))
        {
            float minValue = [slider minimumValue];
            float maxValue = [slider maximumValue];
            float value = [slider value];
            
            double time = duration * (value - minValue) / (maxValue - minValue);
//            self.endTimeLabel.text = [NSString stringWithFormat:@"%f",time];
            
            CMTime timeWithSeconds = CMTimeMakeWithSeconds(time, NSEC_PER_SEC);
            [self.RKPlayerClient scrub:timeWithSeconds :^(BOOL isSeeking) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    isSeek = NO;
                });
            }];
            
        }
    }
}

/* The user has released the movie thumb control to stop scrubbing through the movie. */
- (IBAction)endScrubbing:(id)sender
{
    if (!mTimeObserver)
    {
        CMTime playerDuration = [self.RKPlayerClient playerItemDuration];
        if (CMTIME_IS_INVALID(playerDuration))
        {
            return;
        }
        
        double duration = CMTimeGetSeconds(playerDuration);
        if (isfinite(duration))
        {
            CGFloat width = CGRectGetWidth([self.seekBar bounds]);
            double tolerance = 0.5f * duration / width;
            CMTime timeWithSeconds = CMTimeMakeWithSeconds(tolerance, NSEC_PER_SEC);
            
            [self.RKPlayerClient endScrub:timeWithSeconds withSlider:self.seekBar];
        }
    }
    
}

- (BOOL)isScrubbing
{
    return mRestoreAfterScrubbingRate != 0.f;
}

-(void)enableScrubber
{
    self.seekBar.enabled = YES;
}

-(void)disableScrubber
{
    self.seekBar.enabled = NO;
}

#pragma mark - UI Updates

- (void)changePlayAndPauseString:(NSString*)status {

    [self.playAndPauseBtn setTitle:status forState:UIControlStateNormal];
}

- (void)updateSeekBarValue:(float)value {
    self.seekBar.value = value;
    [self.playingTimeLabel setNeedsUpdateConstraints];

    [UIView animateWithDuration:0 animations:^{
        self.playingTimeLeadingConstraint.constant += value;
//        self.playingTimeLabel.text = [NSString stringWithFormat:@"%.2f",value];
        self.endTimeLeadingConstraint.constant+=value;
//        NSLog(@"%f",self.playingTimeLeadingConstraint.constant);
//        NSLog(@"%@",self.playingTimeLabel.text);
//        NSLog(@"%f",value);
    }completion:nil];
    [self layoutIfNeeded];
}

- (void)duration:(NSString*)totalTime {
//    self.endTimeLabel.text = totalTime;
    self.endTimeLabel.text = [NSString stringWithFormat:@"|%@",totalTime];
}

- (void)currentTime:(NSString *)time {
    self.playingTimeLabel.text = time;
}

@end
