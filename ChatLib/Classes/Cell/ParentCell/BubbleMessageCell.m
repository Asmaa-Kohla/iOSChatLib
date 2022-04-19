//
//  BubbleMessageCell.m
//  iOSChat
//
//  Created by Asmaa Kohla on 29/03/2022.
//

#import <Foundation/Foundation.h>
#import "BubbleMessageCell.h"
#import "ChatUtilities.h"
#import "UIImage+ChatLib.h"

@implementation BubbleMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if([self isSentMessage])
    {
        UIColor *bubbleColor = [self sentBubbleColor];
        UIColor *highlightedBubbleColor = [self sentHighlightedBubbleColor];
        
        UIImage *bubbleImage = [ChatUtilities getImageNamed:@"bubble"];
        UIImage *normalBubble = [bubbleImage imageMaskedWithColor:bubbleColor];
        UIImage *highlightedBubble = [bubbleImage imageMaskedWithColor:highlightedBubbleColor];
        
        if([ChatUtilities isRTL:self.contentView])
        {
            //horizontally flip images
            normalBubble = [ChatUtilities horizontallyFlippedImageFromImage:normalBubble];
            highlightedBubble = [ChatUtilities horizontallyFlippedImageFromImage:highlightedBubble];
        }
        
        //make image streatchable
        normalBubble = [ChatUtilities stretchableImageFromImage:normalBubble withsize:normalBubble.size];
        highlightedBubble = [ChatUtilities stretchableImageFromImage:highlightedBubble withsize:highlightedBubble.size];
        
        [_bubbleImageView setImage:normalBubble];
        [_bubbleImageView setHighlightedImage:highlightedBubble];
    }
    else
    {
        UIColor *bubbleColor = [self receivedBubbleColor];
        UIColor *highlightedBubbleColor = [self receivedHighlightedBubbleColor];
        
        UIImage *bubbleImage = [ChatUtilities getImageNamed:@"bubble"];
        UIImage *normalBubble = [bubbleImage imageMaskedWithColor:bubbleColor];
        UIImage *highlightedBubble = [bubbleImage imageMaskedWithColor:highlightedBubbleColor];
        
        if(![ChatUtilities isRTL:self.contentView])
        {
            //horizontally flip images
            normalBubble = [ChatUtilities horizontallyFlippedImageFromImage:normalBubble];
            highlightedBubble = [ChatUtilities horizontallyFlippedImageFromImage:highlightedBubble];
        }
        
        //make image streatchable
        normalBubble = [ChatUtilities stretchableImageFromImage:normalBubble withsize:normalBubble.size];
        highlightedBubble = [ChatUtilities stretchableImageFromImage:highlightedBubble withsize:highlightedBubble.size];
        
        [_bubbleImageView setImage:normalBubble];
        [_bubbleImageView setHighlightedImage:highlightedBubble];
    }
}

- (BOOL)isSentMessage
{
    return YES;
}

- (UIColor *)sentBubbleColor
{
    return [ChatUtilities getColorNamed:@"grayBubbleColor"];
}

- (UIColor *)sentHighlightedBubbleColor
{
    return [UIColor whiteColor];
}

- (UIColor *)receivedBubbleColor
{
    return [ChatUtilities getColorNamed:@"blueBubbleColor"];
}

- (UIColor *)receivedHighlightedBubbleColor
{
    return [ChatUtilities getColorNamed:@"blueBubbleHighlightedColor"];
}

@end
