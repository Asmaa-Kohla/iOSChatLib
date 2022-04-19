//
//  MessageData.h
//  iOSChat
//
//  Created by Asmaa Kohla on 09/04/2022.
//

#import <Foundation/Foundation.h>

#import "MessageType.h"
#import "SendingState.h"
#import "MessageProtocol.h"

@interface MessageData : NSObject<MessageProtocol>

@property long messageId;
@property (strong, nonatomic) NSDate *sendTime;
@property long senderId;
@property long receiverId;
@property BOOL isSentByMe;
@property SendingState sendingState;
@property BOOL isSeen;
@property BOOL isDeleted;

- (id)init:(long)msgId sendTime:(NSDate *)date senderId:(long)sender receiverId:(long)receiver isSentByMe:(BOOL)byMe sendingState:(SendingState)state isSeen:(BOOL)seen;

@end
