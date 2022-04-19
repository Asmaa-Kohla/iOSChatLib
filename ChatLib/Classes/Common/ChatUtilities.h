//
//  ChatUtilities.h
//  iOSChat
//
//  Created by Asmaa Kohla on 22/03/2022.
//
#import <UIKit/UIKit.h>

@interface ChatUtilities : NSObject

+ (UIImage *)horizontallyFlippedImageFromImage:(UIImage *)image;
+ (UIImage *)stretchableImageFromImage:(UIImage *)image  withsize:(CGSize)bubbleImageSize;
+ (NSString *)stringByTrimingWhitespace:(NSString *)stringValue;
+ (BOOL)isRTL:(UIView *)view;
+ (void)loadImageFromUrl:(NSString *)url intoImageView:(UIImageView *)imageView;
+ (int) getInsetBottomValue;
+ (BOOL)isiPad;
+ (UIImage *)getImageNamed:(NSString *)imageName;
+ (UIColor *)getColorNamed:(NSString *)colorName;

@end
