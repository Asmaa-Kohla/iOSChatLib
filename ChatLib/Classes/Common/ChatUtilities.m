//
//  ChatUtilities.m
//  iOSChat
//
//  Created by Asmaa Kohla on 22/03/2022.
//

#import "ChatUtilities.h"

@implementation ChatUtilities

+ (UIImage *)horizontallyFlippedImageFromImage:(UIImage *)image
{
    return [UIImage imageWithCGImage:image.CGImage
                               scale:image.scale
                         orientation:UIImageOrientationUpMirrored];
}

+ (UIImage *)stretchableImageFromImage:(UIImage *)image withsize:(CGSize)bubbleImageSize
{
    // make image stretchable from center point
    CGPoint center = CGPointMake(bubbleImageSize.width / 2.0f, bubbleImageSize.height / 2.0f);
    UIEdgeInsets capInsets = UIEdgeInsetsMake(center.y, center.x, center.y, center.x);
    
    return [image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
}

+ (NSString *)stringByTrimingWhitespace:(NSString *)stringValue
{
    return [stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (BOOL)isRTL:(UIView *)view
{
    return view.semanticContentAttribute == UIUserInterfaceLayoutDirectionRightToLeft;
}

+ (void)loadImageFromUrl:(NSString *)url intoImageView:(UIImageView *)imageView
{
    if (!url)
        return;
    
    //AFNetworking
    /*[imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] placeholderImage:nil success:nil failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
     {
         NSLog(@"download image failed");
     }];*/
}

+ (int) getInsetBottomValue
{
    if (@available(iOS 11.0, *))
    {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        return window.safeAreaInsets.bottom;
    }
    return 0;
}

+ (BOOL)isiPad
{
    return [[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)];
}

+ (UIImage *)getImageNamed:(NSString *)imageName
{
    return [UIImage imageNamed:imageName inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
}

+ (UIColor *)getColorNamed:(NSString *)colorName
{
    return [UIColor colorNamed:colorName inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
}

@end
