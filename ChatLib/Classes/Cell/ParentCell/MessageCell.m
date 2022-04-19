//
//  MessageCell.m
//  iOSChat
//
//  Created by Asmaa Kohla on 24/03/2022.
//

#import <Foundation/Foundation.h>
#import "MessageCell.h"

@implementation MessageCell

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle bundleForClass:[self class]]];
}

+ (NSString *)cellReuseIdentifier
{
    return NSStringFromClass([self class]);
}

- (void)setDateTimeLabelText:(NSMutableAttributedString *)dateTimeString
{
    [self.dateTimeLabel setAttributedText:dateTimeString];
    if(dateTimeString == nil)
        self.dateLabelHeightConstraint.constant = 0;
    else
    {
        CGFloat dateTimeLabelHeight = [dateTimeString boundingRectWithSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading context:nil].size.height;
        self.dateLabelHeightConstraint.constant = dateTimeLabelHeight;
    }
}

- (void)setSendingStateImage:(SendingState)state isRead:(BOOL)isRead
{
    if(state == kErrorFailed)
    {
        self.sendingStateImage.tintColor = [UIColor redColor];
        self.sendingStateImage.image = [ChatUtilities getImageNamed:@"crossed_circle_black"];
    }
    else if(state == kNotSent)
    {
        self.sendingStateImage.tintColor = [UIColor grayColor];
        self.sendingStateImage.image = [ChatUtilities getImageNamed:@"empty_circle_black"];
    }
    else if(isRead)
    {
        self.sendingStateImage.tintColor = [ChatUtilities getColorNamed:@"blueBubbleColor"];
        self.sendingStateImage.image = [ChatUtilities getImageNamed:@"delivered_black"];
    }
    else
    {
        self.sendingStateImage.tintColor = [UIColor grayColor];
        self.sendingStateImage.image = [ChatUtilities getImageNamed:@"delivered_black"];
    }
}

+ (NSDictionary *)getDateTextAttributes
{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    return @{ NSFontAttributeName : [UIFont systemFontOfSize:12.0f],
                             NSForegroundColorAttributeName : [UIColor lightGrayColor],
                             NSParagraphStyleAttributeName : paragraphStyle };
}

@end
