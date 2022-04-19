//
//  ImagePreviewViewController.m
//  iOSChat
//
//  Created by Asmaa Kohla on 14/04/2022.
//

#import <Foundation/Foundation.h>
#import "ImagePreviewViewController.h"

@implementation ImagePreviewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadImage];
}

- (void)loadImage
{
    if([self.message getImage])
    {
        self.imageView.image = [self.message getImage];
    }
    else
    {
        if([self.message getThumbnailImage])
            self.imageView.image = [self.message getThumbnailImage];
        
        [self.message loadImage:self.imageView];
    }
}

@end
