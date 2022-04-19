//
//  LinkMessageData.m
//  iOSChat
//
//  Created by Asmaa Kohla on 12/04/2022.
//

#import <Foundation/Foundation.h>
#import <LinkPresentation/LinkPresentation.h>
#import "LinkMessageData.h"

@interface LinkMessageData()
{
    API_AVAILABLE(ios(13.0))
    LPLinkMetadata *linkMetadata;
    BOOL isLoadingUrl;
    NSNumber *isLinkMessage;
    CGSize linkContentSize;
    NSIndexPath *indexPath;
}
@end

@implementation LinkMessageData

#pragma mark - override MessageData

- (MessageType)getMessageType
{
    return self.isDeleted? kDeletedMessage : kLinkMessage;
}

#pragma mark - Text Message Protocol

- (NSString *)getMessageText
{
    return self.messageTxt;
}

#pragma mark - Link details data load

- (LPLinkMetadata *)getLinkMetadata API_AVAILABLE(ios(13.0)){
    return linkMetadata;
}

- (void)setLinkMetadata:(LPLinkMetadata *)isLoading API_AVAILABLE(ios(13.0)){
    linkMetadata = isLoading;
}

- (BOOL)isLoadingUrl
{
    return isLoadingUrl;
}

- (void)setLoadingUrl:(BOOL)isLoading
{
    isLoadingUrl = isLoading;
}

- (BOOL)isLinkMessage
{
    if(!isLinkMessage)
    {
        NSURL *candidateURL = [NSURL URLWithString:self.messageTxt];
        BOOL isLinkMsg = candidateURL && candidateURL.scheme && candidateURL.host;
        isLinkMessage = [NSNumber numberWithBool:isLinkMsg];
    }
    return [isLinkMessage boolValue];
}

- (void)setIsLinkMessage:(BOOL)isLink
{
    isLinkMessage = [NSNumber numberWithBool:isLink];
}

- (CGSize)getLinkContentSize
{
    return linkContentSize;
}

- (void)setLinkContentSize:(CGSize)size
{
    linkContentSize = size;
}

- (void)setLinkIndexPath:(NSIndexPath *)index
{
    indexPath = index;
}

- (void)loadLinkData:(UICollectionView *)collectionView API_AVAILABLE(ios(13.0))
{
    [self setLoadingUrl:YES];
    
    NSURL *url = [NSURL URLWithString:self.messageTxt];
    LPMetadataProvider *provider = [[LPMetadataProvider alloc] init];
    [provider startFetchingMetadataForURL:url completionHandler:^(LPLinkMetadata * _Nullable metadata, NSError *_Nullable error){
        
        [self setLoadingUrl:NO];
        
        if(metadata)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self setLinkMetadata:metadata];
                LPLinkView *linkView = [[LPLinkView alloc] init];
                [linkView setMetadata:metadata];
                linkView.frame = CGRectMake(0, 0, linkView.intrinsicContentSize.width, linkView.intrinsicContentSize.height);
                
                CGSize size = linkView.frame.size;
                [self setLinkContentSize:size];
                
                [collectionView reloadItemsAtIndexPaths:@[self->indexPath]];
            });
        }
    }];
}

@end
