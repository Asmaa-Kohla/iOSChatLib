//
//  SentLinkMessageCell.m
//  iOSChat
//
//  Created by Asmaa Kohla on 22/03/2022.
//

#import <Foundation/Foundation.h>
#import "SentLinkMessageCell.h"

@implementation SentLinkMessageCell

- (BOOL)isSentMessage
{
    return YES;
}

- (UIColor *)sentBubbleColor
{
    return [ChatUtilities getColorNamed:@"linkBubbleColor"];
}

- (UIColor *)sentHighlightedBubbleColor
{
    return [ChatUtilities getColorNamed:@"linkBubbleColor"];
}

- (UIColor *)receivedBubbleColor
{
    return [ChatUtilities getColorNamed:@"linkBubbleColor"];
}

- (UIColor *)receivedHighlightedBubbleColor
{
    return [ChatUtilities getColorNamed:@"linkBubbleColor"];
}

@end
