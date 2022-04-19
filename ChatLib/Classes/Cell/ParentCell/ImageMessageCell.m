//
//  ImageMessageCell.m
//  iOSChat
//
//  Created by Asmaa Kohla on 24/03/2022.
//

#import <Foundation/Foundation.h>
#import "ImageMessageCell.h"

@implementation ImageMessageCell

- (void)clearData
{
    self.singleImageView.image = nil;
    self.singleImageLoadingIndecator.hidden = YES;
}

@end
