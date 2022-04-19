//
//  VideoMessageData.h
//  iOSChat
//
//  Created by Asmaa Kohla on 10/04/2022.
//

#import "MessageData.h"
#import <UIKit/UIKit.h>

@interface VideoMessageData : MessageData

@property NSString *thumbnailUrl;
@property NSString *videoUrl;

- (id)init:(long)msgId sendTime:(NSDate *)date senderId:(long)sender receiverId:(long)receiver isSentByMe:(BOOL)byMe sendingState:(SendingState)state isSeen:(BOOL)seen thumbnailUrl:(NSString *)thumbUrl videoUrl:(NSString *)videoUrl;

@end
