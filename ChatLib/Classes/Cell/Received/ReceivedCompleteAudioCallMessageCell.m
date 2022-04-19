//
//  ReceivedCompleteAudioCallMessageCell.m
//  iOSChat
//
//  Created by Asmaa Kohla on 22/03/2022.
//

#import <Foundation/Foundation.h>
#import "ReceivedCompleteAudioCallMessageCell.h"

@implementation ReceivedCompleteAudioCallMessageCell

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle bundleForClass:[self class]]];
}

+ (NSString *)cellReuseIdentifier
{
    return NSStringFromClass([self class]);
}

@end
