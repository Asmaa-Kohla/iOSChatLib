//
//  ImagePreviewViewController.h
//  iOSChat
//
//  Created by Asmaa Kohla on 14/04/2022.
//

#import <UIKit/UIKit.h>
#import "ImageMessageProtocol.h"

@interface ImagePreviewViewController : UIViewController

@property (weak, nonatomic) id<ImageMessageProtocol> message;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
