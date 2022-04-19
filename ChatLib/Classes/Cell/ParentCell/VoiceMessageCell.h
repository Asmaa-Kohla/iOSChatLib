//
//  VoiceMessageCell.h
//  iOSChat
//
//  Created by Asmaa Kohla on 23/03/2022.
//
#import "BubbleMessageCell.h"
#import "AudioOwnerDelegate.h"

#import <AVFoundation/AVFoundation.h>


@interface VoiceMessageCell : BubbleMessageCell<AudioPlayerDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) NSString *audioUrl;
@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) NSTimer *durationTimer;
@property (nonatomic) int duration;
@property (nonatomic) BOOL isPlaying;

@property (weak, nonatomic) IBOutlet UIImageView *playView;
@property (weak, nonatomic) IBOutlet UIImageView *stopView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, weak) id<AudioOwnerDelegate> delegate;

- (IBAction)audioPlayStopAction:(id)sender;

- (void)setDuration:(int)duration :(bool)isMe :(NSString*)recordingName;
- (BOOL)isPlayingAudio;

@end
