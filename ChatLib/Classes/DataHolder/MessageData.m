//
//  MessageData.m
//  iOSChat
//
//  Created by Asmaa Kohla on 09/04/2022.
//

#import "MessageData.h"

@implementation MessageData

- (id)init:(long)msgId sendTime:(NSDate *)date senderId:(long)sender receiverId:(long)receiver isSentByMe:(BOOL)byMe sendingState:(SendingState)state isSeen:(BOOL)seen
{
    self.messageId = msgId;
    self.sendTime = date;
    self.senderId = sender;
    self.receiverId = receiver;
    self.isSentByMe = byMe;
    self.sendingState = state;
    self.isSeen = seen;
    self.isDeleted = NO;
    
    return self;
}

#pragma mark - Message Protocol methods

- (MessageType)getMessageType
{
    
    return self.isDeleted? kDeletedMessage : kTextMessage;
}

- (long)getMessageId
{
    return self.messageId;
}

- (NSDate *)getSendTime
{
    return self.sendTime;
}

- (long)getSenderId
{
    return self.senderId;
}

- (long)getReceiverId
{
    return self.receiverId;
}

- (BOOL)getIsSentByMe
{
    return self.isSentByMe;
}

- (SendingState)getSendingState
{
    return self.sendingState;
}

- (BOOL)getIsSeen
{
    return self.isSeen;
}

@end
