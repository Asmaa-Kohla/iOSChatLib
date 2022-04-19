//
//  VoiceMessageCell.m
//  iOSChat
//
//  Created by Asmaa Kohla on 23/03/2022.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "VoiceMessageCell.h"

@implementation VoiceMessageCell
{
    int seconds;
}

- (void)setDuration:(int)duration :(bool)isMe :(NSString*)recordingurl
{
    [self setAudioDuration:duration];
    [self setIsMine:isMe];
    _audioUrl = recordingurl;
}

- (void)setIsMine:(bool)isMe {
    
    self.playView.image = [ChatUtilities getImageNamed:@"play_arrow_black"];
    self.stopView.image = [ChatUtilities getImageNamed:@"stop_black"];
}

- (void)setAudioDuration:(int)duration {
    self.duration = duration;
    seconds = duration;
    [self updateTimeLabel];
}

- (IBAction)audioPlayStopAction:(id)sender
{
    self.playView.hidden = !self.isPlaying;
    self.stopView.hidden = self.isPlaying;
    
    if(self.isPlaying)
        [self stopPlaying];
    else
    {
        if(self.delegate)
            [self.delegate startPlayingAudio:self];
        [self startPlaying];
    }
    
    self.isPlaying = !self.isPlaying;
}

- (void)startPlaying
{
    if(!self.player)
    {
        seconds = self.duration;
        NSURL *soundFileURL = [NSURL URLWithString:self.audioUrl];
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        NSData *data = [NSData dataWithContentsOfURL:soundFileURL];
        self.player = [[AVAudioPlayer alloc] initWithData:data error:NULL];
        self.player.delegate = self;
    }
    
    
    self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    
    [self.player play];
}

- (void)stopPlaying
{
    [self.durationTimer invalidate];
    self.durationTimer = nil;
    [self.player pause];
}

- (void)updateTime
{
    if(seconds == 0)
    {
        [self audioPlayerDidFinishPlaying];
        return;
    }
    
    seconds--;
    [self updateTimeLabel];
}

- (void)updateTimeLabel
{
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)(seconds / 60), (int)(seconds % 60)];
}

- (void)audioPlayerDidFinishPlaying
{
    seconds = self.duration;
    [self updateTimeLabel];
    
    [self.durationTimer invalidate];
    self.durationTimer = nil;
    self.playView.hidden = NO;
    self.stopView.hidden = YES;
    self.isPlaying = NO;
}

- (BOOL)isPlayingAudio
{
    return self.isPlaying;
}

@end
