//
//  ImageMessageCell.h
//  iOSChat
//
//  Created by Asmaa Kohla on 24/03/2022.
//

#import "MessageCell.h"

@interface ImageMessageCell : MessageCell

@property (weak, nonatomic) IBOutlet UIImageView *singleImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *singleImageLoadingIndecator;

- (void)clearData;

@end
