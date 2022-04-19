//
//  LinkMessageData.h
//  iOSChat
//
//  Created by Asmaa Kohla on 12/04/2022.
//

#import <UIKit/UIKit.h>
#import "TextMessageData.h"
#import "LinkMessageProtocol.h"

@interface LinkMessageData : TextMessageData<LinkMessageProtocol>

- (LPLinkMetadata *)getLinkMetadata API_AVAILABLE(ios(13.0));
- (void)setLinkMetadata:(LPLinkMetadata *)isLoading API_AVAILABLE(ios(13.0));
- (BOOL)isLoadingUrl;
- (void)setLoadingUrl:(BOOL)isLoading;
- (BOOL)isLinkMessage;
- (void)setIsLinkMessage:(BOOL)isLink;
- (CGSize)getLinkContentSize;
- (void)setLinkContentSize:(CGSize)size;
- (void)setLinkIndexPath:(NSIndexPath *)index;
- (void)loadLinkData:(UICollectionView *)collectionView;

@end
