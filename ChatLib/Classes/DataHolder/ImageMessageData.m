//
//  ImageMessageData.m
//  iOSChat
//
//  Created by Asmaa Kohla on 10/04/2022.
//

#import <Foundation/Foundation.h>
#import "ImageMessageData.h"

@implementation ImageMessageData
{
    NSIndexPath *indexPath;
    UIImage *downloadedThumbnailImage;
    BOOL isLoadingThumbnail;
    
    UIImage *downloadedImage;
}

- (id)init:(long)msgId sendTime:(NSDate *)date senderId:(long)sender receiverId:(long)receiver isSentByMe:(BOOL)byMe sendingState:(SendingState)state isSeen:(BOOL)seen imageUrl:(NSString *)image thumbnailUrl:(NSString *)thumbnail
{
    if (self = [super init:msgId sendTime:date senderId:sender receiverId:receiver isSentByMe:byMe sendingState:state isSeen:seen])
    {
        self.imageUrl = image;
        self.thumbnailUrl = thumbnail;
    }
    return self;
}

#pragma mark - override MessageData

- (MessageType)getMessageType
{
    return self.isDeleted? kDeletedMessage : kImageMessage;
}

#pragma mark - Image Message Protocol

- (NSString *)getImageUrl
{
    return self.imageUrl;
}

- (NSString *)getThumbnailUrl
{
    return self.imageUrl;
}

- (UIImage *)getThumbnailImage
{
    return downloadedThumbnailImage;
}

- (void)setIndexPath:(NSIndexPath *)index
{
    indexPath = index;
}

- (BOOL)isLoadingThumbnail
{
    return isLoadingThumbnail;
}

- (void)loadThumbnailImage:(UICollectionView *)collectionView
{
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:self.imageUrl]];
        if (!data)
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            // WARNING: is the cell still using the same data by this point??
            self->downloadedThumbnailImage = [UIImage imageWithData: data];
            [collectionView reloadItemsAtIndexPaths:@[self->indexPath]];
        });
    });
}

- (UIImage *)getImage
{
    return downloadedImage;
}

- (void)loadImage:(UIImageView *)imageView
{
    isLoadingThumbnail = YES;
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:self.imageUrl]];
        if (!data)
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            self->downloadedImage = [UIImage imageWithData: data];
            imageView.image = self->downloadedImage;
            self->isLoadingThumbnail = NO;
        });
    });
}

@end
