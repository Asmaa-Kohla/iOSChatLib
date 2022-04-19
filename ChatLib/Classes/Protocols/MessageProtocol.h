//
//  MessageDataProtocol.h
//  iOSChat
//
//  Created by Asmaa Kohla on 10/04/2022.
//

#import "SendingState.h"
#import "MessageType.h"

@protocol MessageProtocol <NSObject>

- (long)getMessageId;
- (NSDate *)getSendTime;
- (long)getSenderId;
- (long)getReceiverId;
- (BOOL)getIsSentByMe;
- (SendingState)getSendingState;
- (BOOL)getIsSeen;
- (MessageType)getMessageType;
@end
