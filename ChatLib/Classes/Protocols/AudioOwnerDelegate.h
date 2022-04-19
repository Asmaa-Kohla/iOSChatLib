//
//  AudioOwnerDelegate.h
//  iOSChat
//
//  Created by Asmaa Kohla on 10/04/2022.
//

#import "AudioPlayerDelegate.h"

@protocol AudioOwnerDelegate <NSObject>
- (void)startPlayingAudio:(id<AudioPlayerDelegate>)audioPlayer;
@end
