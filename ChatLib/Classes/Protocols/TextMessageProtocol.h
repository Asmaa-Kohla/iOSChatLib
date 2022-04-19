//
//  TextMessageProtocol.h
//  iOSChat
//
//  Created by Asmaa Kohla on 10/04/2022.
//

#import "MessageProtocol.h"

@protocol TextMessageProtocol <MessageProtocol>

- (NSString *)getMessageText;

@end
