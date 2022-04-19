//
//  VoiceMessageData.h
//  iOSChat
//
//  Created by Asmaa Kohla on 10/04/2022.
//

#import "MessageData.h"

@interface VoiceMessageData : MessageData

@property NSString *recordingUrl;
@property int recordingDuration;

- (id)init:(long)msgId sendTime:(NSDate *)date senderId:(long)sender receiverId:(long)receiver isSentByMe:(BOOL)byMe sendingState:(SendingState)state isSeen:(BOOL)seen recordingUrl:(NSString *)url duration:(int)duration;

@end
