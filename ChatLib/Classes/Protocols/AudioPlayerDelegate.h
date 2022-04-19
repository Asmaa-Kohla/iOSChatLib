//
//  AudioPlayerDelegate.h
//  iOSChat
//
//  Created by Asmaa Kohla on 23/03/2022.
//

@protocol AudioPlayerDelegate <NSObject>
- (IBAction)audioPlayStopAction:(id)sender;
- (BOOL)isPlayingAudio;
@end
