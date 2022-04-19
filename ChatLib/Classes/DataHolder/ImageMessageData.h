//
//  ImageMessageData.h
//  iOSChat
//
//  Created by Asmaa Kohla on 10/04/2022.
//

#import "MessageData.h"
#import <UIKit/UIKit.h>

@interface ImageMessageData : MessageData

@property NSString *imageUrl;
@property NSString *thumbnailUrl;

- (id)init:(long)msgId sendTime:(NSDate *)date senderId:(long)sender receiverId:(long)receiver isSentByMe:(BOOL)byMe sendingState:(SendingState)state isSeen:(BOOL)seen imageUrl:(NSString *)image thumbnailUrl:(NSString *)thumbnail;

@end
