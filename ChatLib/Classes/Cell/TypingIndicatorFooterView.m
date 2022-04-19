//
//  TypingIndicatorFooterView.m
//  iOSChat
//
//  Created by Asmaa Kohla on 30/03/2022.
//

#import "TypingIndicatorFooterView.h"
#import "ChatUtilities.h"
#import "UIImage+ChatLib.h"

@implementation TypingIndicatorFooterView

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle bundleForClass:[self class]]];
}

+ (NSString *)cellReuseIdentifier {
    return NSStringFromClass([self class]);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIColor *bubbleColor = [ChatUtilities getColorNamed:@"grayBubbleColor"];
    UIImage *bubbleImage = [ChatUtilities getImageNamed:@"bubble"];
    UIImage *normalBubble = [bubbleImage imageMaskedWithColor:bubbleColor];
     
    //horizontally flip images
    normalBubble = [ChatUtilities horizontallyFlippedImageFromImage:normalBubble];
    //make image streatchable
    normalBubble = [ChatUtilities stretchableImageFromImage:normalBubble withsize:normalBubble.size];
    
    [self.bubbleImageView setImage:normalBubble];
    
    self.typingIndicatorImageView.image = [[ChatUtilities getImageNamed:@"typing"] imageMaskedWithColor:[ChatUtilities getColorNamed:@"typingIndecatorColor"]];
}

@end
