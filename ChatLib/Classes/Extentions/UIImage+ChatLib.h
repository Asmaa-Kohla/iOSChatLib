//
//  UIImage+ChatLib.h
//  iOSChat
//
//  Created by Asmaa Kohla on 22/03/2022.
//

#import <UIKit/UIKit.h>

@interface UIImage (ChatLib)

/**
 *  Creates and returns a new image object that is masked with the specified mask color.
 *
 *  @param maskColor The color value for the mask. This value must not be `nil`.
 *
 *  @return A new image object masked with the specified color.
 */
- (UIImage *)imageMaskedWithColor:(UIColor *)maskColor;

@end
