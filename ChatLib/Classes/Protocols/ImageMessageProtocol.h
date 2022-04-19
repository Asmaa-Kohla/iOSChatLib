//
//  ImageMessageProtocol.h
//  iOSChat
//
//  Created by Asmaa Kohla on 10/04/2022.
//

#import "MessageProtocol.h"

@protocol ImageMessageProtocol <MessageProtocol>

- (NSString *)getImageUrl;
- (NSString *)getThumbnailUrl;

- (UIImage *)getImage;
- (BOOL)isLoadingThumbnail;
- (void)loadThumbnailImage:(UICollectionView *)collectionView;

- (UIImage *)getThumbnailImage;
- (void)setIndexPath:(NSIndexPath *)index;
- (void)loadImage:(UIImageView *)imageView;

@end
