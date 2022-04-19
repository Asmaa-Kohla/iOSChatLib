//
//  ReceivedTextMessageCell.m
//  iOSChat
//
//  Created by Asmaa Kohla on 22/03/2022.
//

#import <Foundation/Foundation.h>
#import "ReceivedTextMessageCell.h"

@implementation ReceivedTextMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.messageTextView.textContainerInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.messageTextView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.messageTextView.textAlignment = NSTextAlignmentNatural;
}

- (BOOL)isSentMessage
{
    return NO;
}

@end
