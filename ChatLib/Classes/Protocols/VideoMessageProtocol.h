//
//  VideoMessageProtocol.h
//  iOSChat
//
//  Created by Asmaa Kohla on 10/04/2022.
//

#import "MessageProtocol.h"

@protocol VideoMessageProtocol <MessageProtocol>

- (NSString *)getThumbnailUrl;
- (NSString *)getVideoUrl;
- (UIImage *)getThumbnailImage;
- (void)setIndexPath:(NSIndexPath *)index;
- (void)loadThumbnailImage:(UICollectionView *)collectionView;

@end
