//
//  TextMessageData.m
//  iOSChat
//
//  Created by Asmaa Kohla on 10/04/2022.
//

#import <Foundation/Foundation.h>
#import "TextMessageData.h"

@interface TextMessageData()
{
    API_AVAILABLE(ios(13.0))
    LPLinkMetadata *linkMetadata;
    BOOL isLoadingUrl;
    NSNumber *isLinkMessage;
    CGSize linkContentSize;
    NSIndexPath *indexPath;
}
@end

@implementation TextMessageData

- (id)init:(long)msgId sendTime:(NSDate *)date senderId:(long)sender receiverId:(long)receiver isSentByMe:(BOOL)byMe sendingState:(SendingState)state isSeen:(BOOL)seen messageTxt:(NSString *)msgTxt
{
    if (self = [super init:msgId sendTime:date senderId:sender receiverId:receiver isSentByMe:byMe sendingState:state isSeen:seen])
    {
        self.messageTxt = msgTxt;
    }
    return self;
}

#pragma mark - override MessageData

- (MessageType)getMessageType
{
    return self.isDeleted? kDeletedMessage : kTextMessage;
}

#pragma mark - Text Message Protocol

- (NSString *)getMessageText
{
    return self.messageTxt;
}

@end
