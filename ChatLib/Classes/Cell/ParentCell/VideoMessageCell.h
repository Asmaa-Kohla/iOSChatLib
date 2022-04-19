//
//  VideoMessageCell.h
//  iOSChat
//
//  Created by Asmaa Kohla on 29/03/2022.
//

#import "MessageCell.h"

@interface VideoMessageCell : MessageCell

@property (weak, nonatomic) IBOutlet UIImageView *playView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndecator;

- (void)clearData;

@end
