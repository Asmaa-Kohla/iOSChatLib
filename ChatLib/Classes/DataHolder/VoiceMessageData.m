//
//  VoiceMessageData.m
//  iOSChat
//
//  Created by Asmaa Kohla on 10/04/2022.
//

#import <Foundation/Foundation.h>
#import "VoiceMessageData.h"

@implementation VoiceMessageData

- (id)init:(long)msgId sendTime:(NSDate *)date senderId:(long)sender receiverId:(long)receiver isSentByMe:(BOOL)byMe sendingState:(SendingState)state isSeen:(BOOL)seen recordingUrl:(NSString *)url duration:(int)duration
{
    if (self = [super init:msgId sendTime:date senderId:sender receiverId:receiver isSentByMe:byMe sendingState:state isSeen:seen])
    {
        self.recordingUrl = url;
        self.recordingDuration = duration;
    }
    return self;
}

#pragma mark - override MessageData

- (MessageType)getMessageType
{
    return self.isDeleted? kDeletedMessage : kVoiceMessage;
}

#pragma mark - Voice Message Protocol

- (NSString *)getRecordingUrl
{
    return self.recordingUrl;
}

- (int)getRecordingDuration
{
    return self.recordingDuration;
}

@end
