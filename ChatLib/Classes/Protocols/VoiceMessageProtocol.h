//
//  VoiceMessageProtocol.h
//  iOSChat
//
//  Created by Asmaa Kohla on 10/04/2022.
//

#import "MessageProtocol.h"

@protocol VoiceMessageProtocol <MessageProtocol>

- (NSString *)getRecordingUrl;
- (int)getRecordingDuration;

@end
