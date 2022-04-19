//
//  TextMessageData.h
//  iOSChat
//
//  Created by Asmaa Kohla on 10/04/2022.
//

#import <UIKit/UIKit.h>
#import "MessageData.h"
#import "TextMessageProtocol.h"

@interface TextMessageData : MessageData<TextMessageProtocol>

@property (strong, nonatomic) NSString *messageTxt;

- (id)init:(long)msgId sendTime:(NSDate *)date senderId:(long)sender receiverId:(long)receiver isSentByMe:(BOOL)byMe sendingState:(SendingState)state isSeen:(BOOL)seen messageTxt:(NSString *)msgTxt;

@end
