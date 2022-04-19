//
//  VideoMessageData.m
//  iOSChat
//
//  Created by Asmaa Kohla on 10/04/2022.
//

#import <Foundation/Foundation.h>
#import "VideoMessageData.h"

@implementation VideoMessageData
{
    NSIndexPath *indexPath;
    UIImage *downloadedThumbnail;
}

- (id)init:(long)msgId sendTime:(NSDate *)date senderId:(long)sender receiverId:(long)receiver isSentByMe:(BOOL)byMe sendingState:(SendingState)state isSeen:(BOOL)seen thumbnailUrl:(NSString *)thumbUrl videoUrl:(NSString *)videoUrl
{
    if (self = [super init:msgId sendTime:date senderId:sender receiverId:receiver isSentByMe:byMe sendingState:state isSeen:seen])
    {
        self.thumbnailUrl = thumbUrl;
        self.videoUrl = videoUrl;
    }
    return self;
}

#pragma mark - override MessageData

- (MessageType)getMessageType
{
    return self.isDeleted? kDeletedMessage : kVideoMessage;
}

#pragma mark - Video Message Protocol

- (NSString *)getThumbnailUrl
{
    return self.thumbnailUrl;
}

- (NSString *)getVideoUrl
{
    return self.videoUrl;
}

- (UIImage *)getThumbnailImage
{
    return downloadedThumbnail;
}

- (void)setIndexPath:(NSIndexPath *)index
{
    indexPath = index;
}

- (void)loadThumbnailImage:(UICollectionView *)collectionView
{
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:self.thumbnailUrl]];
        if (!data)
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            // WARNING: is the cell still using the same data by this point??
            self->downloadedThumbnail = [UIImage imageWithData: data];
            [collectionView reloadItemsAtIndexPaths:@[self->indexPath]];
        });
    });
}

@end
