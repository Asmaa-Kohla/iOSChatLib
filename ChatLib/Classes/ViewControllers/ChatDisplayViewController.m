//
//  ChatDisplayViewController.m
//  iOSChat
//
//  Created by Asmaa Kohla on 09/04/2022.
//

#import "ChatDisplayViewController.h"
#import <AVKit/AVKit.h>

#import "SentTextMessageCell.h"
#import "SentImageMessageCell.h"
#import "SentVoiceMessageCell.h"
#import "SentVideoMessageCell.h"
#import "SentDeletedMessageCell.h"
#import "SentMissedAudioCallMessageCell.h"
#import "SentCompleteAudioCallMessageCell.h"
#import "SentLinkMessageCell.h"
#import "ReceivedTextMessageCell.h"
#import "ReceivedImageMessageCell.h"
#import "ReceivedVoiceMessageCell.h"
#import "ReceivedVideoMessageCell.h"
#import "ReceivedDeletedMessageCell.h"
#import "ReceivedMissedAudioCallMessageCell.h"
#import "ReceivedCompleteAudioCallMessageCell.h"
#import "ReceivedLinkMessageCell.h"
#import "VoiceMessageCell.h"
#import "ImageMessageCell.h"
#import "VideoMessageCell.h"
#import "LinkMessageCell.h"
#import "TypingIndicatorFooterView.h"
#import "ImagePreviewViewController.h"

#import "UIImage+ChatLib.h"
#import "ChatUtilities.h"
#import <Photos/Photos.h>

@interface ChatDisplayViewController ()
{
    id<AudioPlayerDelegate> playingVoiceCell;
    UITapGestureRecognizer *tapGesture;
    
    BOOL isSelectionMode;
    int selectedIndex;
}
@end

@implementation ChatDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.delegate = self;
    lpgr.delaysTouchesBegan = YES;
    [collectionView addGestureRecognizer:lpgr];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.delegate = self;
    tapGesture.delaysTouchesBegan = YES;
    tapGesture.enabled = NO;
    [collectionView addGestureRecognizer:tapGesture];
    
    [self registerNibs];
    [self setUpNewMessageToolbarUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    dispatch_async(dispatch_get_main_queue(), ^{
        if(!self.isPhotosFullScreenOpened)
        {
            [self scrollToBottom:NO];
        }
    });

    [self addKeyboardObservers];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //stop any playing audio
    [self stopWorkingAudio];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerNibs
{
    [collectionView registerNib:[SentTextMessageCell nib] forCellWithReuseIdentifier:[SentTextMessageCell cellReuseIdentifier]];
    [collectionView registerNib:[SentImageMessageCell nib] forCellWithReuseIdentifier:[SentImageMessageCell cellReuseIdentifier]];
    [collectionView registerNib:[SentVoiceMessageCell nib] forCellWithReuseIdentifier:[SentVoiceMessageCell cellReuseIdentifier]];
    [collectionView registerNib:[SentVideoMessageCell nib] forCellWithReuseIdentifier:[SentVideoMessageCell cellReuseIdentifier]];
    [collectionView registerNib:[SentDeletedMessageCell nib] forCellWithReuseIdentifier:[SentDeletedMessageCell cellReuseIdentifier]];
    [collectionView registerNib:[SentMissedAudioCallMessageCell nib] forCellWithReuseIdentifier:[SentMissedAudioCallMessageCell cellReuseIdentifier]];
    [collectionView registerNib:[SentCompleteAudioCallMessageCell nib] forCellWithReuseIdentifier:[SentCompleteAudioCallMessageCell cellReuseIdentifier]];
    
    [collectionView registerNib:[ReceivedTextMessageCell nib] forCellWithReuseIdentifier:[ReceivedTextMessageCell cellReuseIdentifier]];
    [collectionView registerNib:[ReceivedImageMessageCell nib] forCellWithReuseIdentifier:[ReceivedImageMessageCell cellReuseIdentifier]];
    [collectionView registerNib:[ReceivedVoiceMessageCell nib] forCellWithReuseIdentifier:[ReceivedVoiceMessageCell cellReuseIdentifier]];
    [collectionView registerNib:[ReceivedVideoMessageCell nib] forCellWithReuseIdentifier:[ReceivedVideoMessageCell cellReuseIdentifier]];
    [collectionView registerNib:[ReceivedDeletedMessageCell nib] forCellWithReuseIdentifier:[ReceivedDeletedMessageCell cellReuseIdentifier]];
    [collectionView registerNib:[ReceivedMissedAudioCallMessageCell nib] forCellWithReuseIdentifier:[ReceivedMissedAudioCallMessageCell cellReuseIdentifier]];
    [collectionView registerNib:[ReceivedCompleteAudioCallMessageCell nib] forCellWithReuseIdentifier:[ReceivedCompleteAudioCallMessageCell cellReuseIdentifier]];
    
    if (@available(iOS 13.0, *))
    {
        [collectionView registerNib:[ReceivedLinkMessageCell nib] forCellWithReuseIdentifier:[ReceivedLinkMessageCell cellReuseIdentifier]];
        [collectionView registerNib:[SentLinkMessageCell nib] forCellWithReuseIdentifier:[SentLinkMessageCell cellReuseIdentifier]];
    }
    
    [collectionView registerNib:[TypingIndicatorFooterView nib] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[TypingIndicatorFooterView cellReuseIdentifier]];
}

#pragma mark - Setters

- (void)setShowTypingIndicator:(BOOL)showTypingIndicator
{
    if (_showTypingIndicator == showTypingIndicator) {
        return;
    }

    _showTypingIndicator = showTypingIndicator;
    
    //[collectionView.collectionViewLayout invalidateLayout];
    //[self scrollToBottom:NO];
    
    [collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - Collection View methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.chatDisplayDelegate getMessagesCount];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<MessageProtocol> message = [self.chatDisplayDelegate getMessageAtIndex:(int)indexPath.row];
    if(message == nil) return nil;
    
    MessageCell *cell;
    if([message getMessageType] == kTextMessage)// && [message isKindOfClass:id<TextMessageProtocol>])
    {
        cell = [self createTextMessageCell:(id<TextMessageProtocol>)message forIndexPath:indexPath];
    }
    else if([message getMessageType] == kLinkMessage)
    {
        if (@available(iOS 13.0, *))
            cell = [self createLinkMessageCell:(id<LinkMessageProtocol>)message forIndexPath:indexPath];
        else
            cell = [self createTextMessageCell:(id<TextMessageProtocol>)message forIndexPath:indexPath];
    }
    else if([message getMessageType] == kImageMessage)
    {
        cell = [self createImageMessageCell:(id<ImageMessageProtocol>)message forIndexPath:indexPath];
    }
    else if([message getMessageType] == kVoiceMessage)
    {
        cell = [self createVoiceMessageCell:(id<VoiceMessageProtocol>)message forIndexPath:indexPath];
    }
    else if([message getMessageType] == kVideoMessage)
    {
        cell = [self createVideoMessageCell:(id<VideoMessageProtocol>)message forIndexPath:indexPath];
    }
    else if([message getMessageType] == kDeletedMessage)
    {
        cell = [self createDeletedMessageCell:message forIndexPath:indexPath];
    }
    /*else if([message getMessageType] == kMissedAudioCallMessage)
    {
        cell = [self createMissedAudioCallCell:message forIndexPath:indexPath];
    }
    else if([message getMessageType] == kCompleteAudioCallMessage)
    {
        cell = [self createCompleteAudioCallCell:message forIndexPath:indexPath];
    }*/
    
    [cell.dateTimeLabel setAttributedText:[self getDateAttributedText:[message getSendTime]]];
    
    BOOL isDummed = isSelectionMode && selectedIndex != indexPath.row;
    cell.dummingView.hidden = !isDummed;
    collectionView.backgroundColor = isSelectionMode? [ChatUtilities getColorNamed:@"dummingColor"]: [ChatUtilities getColorNamed:@"ChatWhiteColor"];
    [cell setBackgroundColor:[ChatUtilities getColorNamed:@"ChatWhiteColor"]];
    
    if(isSelectionMode && selectedIndex == indexPath.row)
        [cell setSelected:YES];
    
    if([message getIsSentByMe])
        [cell setSendingStateImage:[message getSendingState] isRead:[message getIsSeen]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<MessageProtocol> message = [self.chatDisplayDelegate getMessageAtIndex:(int)indexPath.row];
    if(message == nil) return CGSizeZero;
    
    NSString *dateString = [self getDateString:[message getSendTime]];
    NSDictionary *dateTextAttributes = [MessageCell getDateTextAttributes];
    CGFloat dateTimeLabelHeight = [dateString boundingRectWithSize:CGSizeMake(collectionView.frame.size.width, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading) attributes:dateTextAttributes context:nil].size.height;
    
    
    CGFloat stateHeight = [message getIsSentByMe]? 15 : 0;
        
    if([message getMessageType] == kTextMessage)
    {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.5]};
        CGFloat textLabelHeight = [[(id<TextMessageProtocol>)message getMessageText] boundingRectWithSize:CGSizeMake(collectionView.frame.size.width - 75, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:nil].size.height;
        int marginsSum = [message getIsSentByMe]? 24 : 22;
        return CGSizeMake(collectionView.frame.size.width, dateTimeLabelHeight + textLabelHeight + stateHeight + marginsSum);
    }
    else if([message getMessageType] == kLinkMessage)
    {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.5]};
        id<LinkMessageProtocol> linkMessage = (id<LinkMessageProtocol>)message;
        
        int marginsSum = [message getIsSentByMe]? 32 : 28;
        CGFloat linkContentHeight = 0;
        CGFloat textLabelMaxWidth = collectionView.frame.size.width - 85;
        
        if (@available(iOS 13.0, *))
        {
            if([linkMessage getLinkMetadata])
            {
                CGSize linkContentSize = [linkMessage getLinkContentSize];
                linkContentHeight = linkContentSize.height;
                textLabelMaxWidth = linkContentSize.width - 10;
            }
        }
        
        CGFloat textLabelHeight = [[linkMessage getMessageText] boundingRectWithSize:CGSizeMake(textLabelMaxWidth, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:nil].size.height;
        
        return CGSizeMake(collectionView.frame.size.width, dateTimeLabelHeight + textLabelHeight + linkContentHeight + stateHeight + marginsSum);
    }
    else if([message getMessageType] == kVoiceMessage)
    {
        int marginsSum = [message getIsSentByMe]? 30 : 26;
        return CGSizeMake(collectionView.frame.size.width, dateTimeLabelHeight + 20 + stateHeight + marginsSum);
    }
    else if([message getMessageType] == kImageMessage)
    {
        int marginsSum = [message getIsSentByMe]? 14 : 12;
        return CGSizeMake(collectionView.frame.size.width, dateTimeLabelHeight + 130 + stateHeight + marginsSum);
    }
    else if([message getMessageType] == kVideoMessage)
    {
        int marginsSum = [message getIsSentByMe]? 14 : 12;
        return CGSizeMake(collectionView.frame.size.width, dateTimeLabelHeight + 130 + stateHeight + marginsSum);
    }
    else if([message getMessageType] == kDeletedMessage)
    {
        int marginsSum = [message getIsSentByMe]? 14 : 12;
        return CGSizeMake(collectionView.frame.size.width, dateTimeLabelHeight + 40 + stateHeight + marginsSum);
    }
    
    return CGSizeMake(collectionView.frame.size.width, 1);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<MessageProtocol> message = [self.chatDisplayDelegate getMessageAtIndex:(int)indexPath.row];
    if(message == nil) return;
    
    if([message getMessageType] == kImageMessage)
    {
        ImagePreviewViewController *imagePreviewViewController = [[ImagePreviewViewController alloc] initWithNibName:@"ImagePreviewViewController" bundle:[NSBundle bundleForClass:[ImagePreviewViewController class]]];
        imagePreviewViewController.message = (id<ImageMessageProtocol>)message;
        [self presentViewController:imagePreviewViewController animated:YES completion:nil];
    }
    else if([message getMessageType] == kVideoMessage)
    {
        self.isVideoPlaying = YES;
        
        NSURL *videoFileURL = [NSURL URLWithString:[(id<VideoMessageProtocol>)message getVideoUrl]];
        
        AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:videoFileURL];
        AVPlayer *playVideo = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        
        AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
        playerViewController.player = playVideo;
        playerViewController.view.frame = self.view.bounds;
        playerViewController.showsPlaybackControls = YES;
        [self.navigationController pushViewController:playerViewController animated:YES];
        
        [playVideo play];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if(self.showTypingIndicator)
        return CGSizeMake(collectionView.frame.size.width, 36.0f);
    return CGSizeZero;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (self.showTypingIndicator && [kind isEqualToString:UICollectionElementKindSectionFooter]) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[TypingIndicatorFooterView cellReuseIdentifier] forIndexPath:indexPath];
    }
    return nil;
}

#pragma mark - Collection View Cells Creation

- (__kindof UICollectionViewCell *)createTextMessageCell:(id<TextMessageProtocol>)textMessage forIndexPath:(NSIndexPath *)indexPath
{
    TextMessageCell *cell;
    if([textMessage getIsSentByMe])
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SentTextMessageCell cellReuseIdentifier] forIndexPath:indexPath];
    }
    else
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ReceivedTextMessageCell cellReuseIdentifier] forIndexPath:indexPath];
    }
    
    cell.messageTextView.text = [textMessage getMessageText];
    cell.messageTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    
    return cell;
}

- (__kindof UICollectionViewCell *)createImageMessageCell:(id<ImageMessageProtocol>)imageMessage forIndexPath:(NSIndexPath *)indexPath
{
    ImageMessageCell *cell;
    
    if([imageMessage getIsSentByMe])
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SentImageMessageCell cellReuseIdentifier] forIndexPath:indexPath];
    }
    else
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ReceivedImageMessageCell cellReuseIdentifier] forIndexPath:indexPath];
    }
    
    [cell clearData];
    if([imageMessage getThumbnailImage])
        cell.singleImageView.image = [imageMessage getThumbnailImage];
    else
    {
        [imageMessage setIndexPath:indexPath];
        if(![imageMessage isLoadingThumbnail])
            [imageMessage loadThumbnailImage:collectionView];
    }
    
    cell.singleImageLoadingIndecator.hidden = [imageMessage getSendingState] != kNotSent;
    [cell setDateTimeLabelText:[self getDateAttributedText:[imageMessage getSendTime]]];
    
    return cell;
}

- (__kindof UICollectionViewCell *)createVoiceMessageCell:(id<VoiceMessageProtocol>)voiceMessage forIndexPath:(NSIndexPath *)indexPath
{
    VoiceMessageCell *cell;
    
    if([voiceMessage getIsSentByMe])
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SentVoiceMessageCell cellReuseIdentifier] forIndexPath:indexPath];
    }
    else
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ReceivedVoiceMessageCell cellReuseIdentifier] forIndexPath:indexPath];
    }
    
    [cell.dateTimeLabel setAttributedText:[self getDateAttributedText:[voiceMessage getSendTime]]];
    
    cell.delegate = self;
    [cell setDuration:[voiceMessage getRecordingDuration] :[voiceMessage getIsSentByMe] :[voiceMessage getRecordingUrl]];
    
    return cell;
}

- (__kindof UICollectionViewCell *)createVideoMessageCell:(id<VideoMessageProtocol>)videoMessage forIndexPath:(NSIndexPath *)indexPath
{
    VideoMessageCell *cell;
    
    if([videoMessage getIsSentByMe])
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SentVideoMessageCell cellReuseIdentifier] forIndexPath:indexPath];
    }
    else
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ReceivedVideoMessageCell cellReuseIdentifier] forIndexPath:indexPath];
    }
    
    [cell clearData];
    if([videoMessage getThumbnailImage])
        cell.thumbnailImageView.image = [videoMessage getThumbnailImage];
    else
    {
        [videoMessage setIndexPath:indexPath];
        [videoMessage loadThumbnailImage:collectionView];
    }
    
    cell.playView.hidden = [videoMessage getSendingState] == kNotSent;
    cell.loadingIndecator.hidden = [videoMessage getSendingState] != kNotSent;
    
    [cell setDateTimeLabelText:[self getDateAttributedText:[videoMessage getSendTime]]];
    
    return cell;
}

- (__kindof UICollectionViewCell *)createDeletedMessageCell:(id<MessageProtocol>)message forIndexPath:(NSIndexPath *)indexPath
{
    if([message getIsSentByMe])
    {
        SentDeletedMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SentDeletedMessageCell cellReuseIdentifier] forIndexPath:indexPath];
        cell.messageLabel.text = NSLocalizedString(@"deleted_message", @"ChatLibraryLocalization");
        return cell;
    }
    else
    {
        ReceivedDeletedMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ReceivedDeletedMessageCell cellReuseIdentifier] forIndexPath:indexPath];
        cell.messageLabel.text = NSLocalizedString(@"deleted_message", @"");
        return cell;
    }
}

/*
- (__kindof UICollectionViewCell *)createMissedAudioCallCell:(MessageData *)message forIndexPath:(NSIndexPath *)indexPath
{
    if(message.isSentByMe)
    {
        SentMissedAudioCallMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SentMissedAudioCallMessageCell cellReuseIdentifier] forIndexPath:indexPath];
        return cell;
    }
    else
    {
        ReceivedMissedAudioCallMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ReceivedMissedAudioCallMessageCell cellReuseIdentifier] forIndexPath:indexPath];
        return cell;
    }
}

- (__kindof UICollectionViewCell *)createCompleteAudioCallCell:(MessageData *)message forIndexPath:(NSIndexPath *)indexPath
{
    if(message.isSentByMe)
    {
        SentCompleteAudioCallMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SentCompleteAudioCallMessageCell cellReuseIdentifier] forIndexPath:indexPath];
        return cell;
    }
    else
    {
        ReceivedCompleteAudioCallMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ReceivedCompleteAudioCallMessageCell cellReuseIdentifier] forIndexPath:indexPath];
        return cell;
    }
}

*/

- (__kindof UICollectionViewCell *)createLinkMessageCell:(id<LinkMessageProtocol>)message forIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(13.0))
{
    LinkMessageCell *cell;
    if([message getIsSentByMe])
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SentLinkMessageCell cellReuseIdentifier] forIndexPath:indexPath];
    }
    else
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ReceivedLinkMessageCell cellReuseIdentifier] forIndexPath:indexPath];
    }
    
    cell.messageTextView.text = [message getMessageText];
    
    [cell setDateTimeLabelText:[self getDateAttributedText:[message getSendTime]]];
    
    [cell clearData];
    [message setLinkIndexPath:indexPath];
    
    LPLinkMetadata *savedMetaData = [message getLinkMetadata];
    if(savedMetaData)
    {
        [cell setData:savedMetaData withSize:[message getLinkContentSize]];
    }
    else if(![message isLoadingUrl])
    {
        [message loadLinkData:collectionView];
    }
    
    return cell;
}

#pragma mark - Gesture recognizers

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    [messageTextView resignFirstResponder];
    
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
        return;
    
    CGPoint p = [gestureRecognizer locationInView:collectionView];

    NSIndexPath *indexPath = [collectionView indexPathForItemAtPoint:p];
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    }
    else
    {
        id<MessageProtocol> message = [self.chatDisplayDelegate getMessageAtIndex:(int)indexPath.row];
        if(message != nil && [message getMessageType] != kDeletedMessage)
        {
            selectedIndex = (int)indexPath.row;
            [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            [self showMessageSelectionOptions:collectionView forMessage:message];
            [self reloadData];
        }
    }
}

- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    [messageTextView resignFirstResponder];
}

- (void)showMessageSelectionOptions:(UIView *)sender forMessage:(id<MessageProtocol>)message
{
    isSelectionMode = YES;
    
    [messageTextView resignFirstResponder];
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

        [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            [self dismissViewControllerAnimated:YES completion:^{
                [self unSelectCell];
            }];
        }]];

    if([message getMessageType] == kTextMessage)
        [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"copy", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = [(id<TextMessageProtocol>)message getMessageText];
            [self dismissViewControllerAnimated:YES completion:^{
                [self unSelectCell];
            }];
        }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"delete_message", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self.chatDisplayDelegate deleteMessage:message];
        [self dismissViewControllerAnimated:YES completion:^{
            [self unSelectCell];
        }];
    }]];
    
    if([ChatUtilities isiPad])
    {
        [actionSheet setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [actionSheet popoverPresentationController];
        popPresenter.sourceView = sender;
        popPresenter.sourceRect = sender.bounds;
    }
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)unSelectCell
{
    isSelectionMode = NO;
    collectionView.allowsSelection = NO;
    collectionView.allowsSelection = YES;
    [collectionView reloadData];
}

#pragma mark - Data process

- (NSMutableAttributedString *)getDateAttributedText:(NSDate *)sendTime
{
    NSString *dateString = [self getDateString:sendTime];
    NSDictionary *dateTextAttributes = [MessageCell getDateTextAttributes];
    return [[NSMutableAttributedString alloc] initWithString:dateString attributes:dateTextAttributes];
    return nil;
}

- (NSString *)getDateString:(NSDate *)sendTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *dateString =  [dateFormatter stringFromDate:sendTime];
    
    if (!dateString)
        return @"";
    return dateString;
}

#pragma mark - External methods

- (void)reloadData
{
    [collectionView reloadData];
}

- (void)reloadData:(BOOL)scrollToBottom isAnimated:(BOOL)isAnimated
{
    [collectionView reloadData];
    if(scrollToBottom)
        [self scrollToBottom:isAnimated];
}

- (void)scrollToBottom:(BOOL)isAnimated
{
    [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[self.chatDisplayDelegate getMessagesCount]-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:isAnimated];
}

- (void)setToolBarHidden:(BOOL)isHidden
{
    if (isHidden) {
        // disable editing
        toolbarView.hidden = YES;
        messageTextView.userInteractionEnabled = NO;
    } else {
        // enable editing
        toolbarView.hidden = NO;
        messageTextView.userInteractionEnabled = YES;
    }
}

#pragma mark - AudioOwnerDelegate

- (void)startPlayingAudio:(id<AudioPlayerDelegate>)audioPlayer
{
    [self stopWorkingAudio];
    
    playingVoiceCell = audioPlayer;
}

- (void)stopWorkingAudio
{
    if(playingVoiceCell && [playingVoiceCell isPlayingAudio])
    {
        [playingVoiceCell audioPlayStopAction:nil];
    }
}

#pragma mark - Finish Sending

- (void)finishSendingMessageAnimated:(BOOL)animated
{
    messageTextView.text = nil;
    [messageTextView.undoManager removeAllActions];

    [self refreshSendButtonEnableState];

    [collectionView reloadData];
    [self scrollToBottom:animated];
}

- (void)finishSend:(BOOL)success scroll:(BOOL)shouldScroll lastMessage:(NSString*)lastMessage
{
    // somar don't automatically clear text, should only be if success in sending message
    if (!success)
        [messageTextView setText:lastMessage];
        
    
    [self textViewDidChange:messageTextView];
    
    [collectionView reloadData];
    
    if (shouldScroll)
        [self scrollToBottom:YES];
}

- (void)refreshSendButtonEnableState
{
    sendMessageBtn.enabled = [messageTextView hasText];
    sendBtnImageView.alpha = sendMessageBtn.enabled? 1.0 : 0.5;
}

#pragma mark - TextView delegate methods

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView != messageTextView)
        return;
    
    [self refreshSendButtonEnableState];
    
    NSString *text = [self getTextViewText];
    if (!text || text.length == 0)
        [self.chatDisplayDelegate sendStopTyping];
    else
    {
        [self.chatDisplayDelegate sendStartTyping];
        if(attachStackView.subviews.count > 2)
            [self contractAttachView];
    }
}

- (NSString*)getTextViewText
{
    if (!messageTextView)
        return nil;
    return [messageTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark - Sending new messages tool bar

- (void)setUpNewMessageToolbarUI
{
    UIImage *sendImage = [[ChatUtilities getImageNamed:@"send_black"] imageFlippedForRightToLeftLayoutDirection];
    [sendBtnImageView setImage:sendImage];
    [self refreshSendButtonEnableState];
}

- (UIButton *)addDefaultVideoBtn
{
    UIImage *videoImage = [ChatUtilities getImageNamed:@"video_icon"];
    UIImage *videoNormalImage = [videoImage imageMaskedWithColor:[ChatUtilities getColorNamed:@"blueBubbleColor"]];
    UIImage *videoHighlightedImage = [videoImage imageMaskedWithColor:[UIColor lightGrayColor]];
    UIButton *addVideoBtn = [UIButton new];
    [addVideoBtn setImage:videoNormalImage forState:UIControlStateNormal];
    [addVideoBtn setImage:videoHighlightedImage forState:UIControlStateHighlighted];
    [self addAttachButton:addVideoBtn];
    
    return addVideoBtn;
}

- (UIButton *)addDefaultCameraBtn
{
    UIImage *cameraImage = [ChatUtilities getImageNamed:@"camera_icon"];
    UIImage *cameraNormalImage = [cameraImage imageMaskedWithColor:[ChatUtilities getColorNamed:@"blueBubbleColor"]];
    UIImage *cameraHighlightedImage = [cameraImage imageMaskedWithColor:[UIColor lightGrayColor]];
    UIButton *openCameraBtn = [UIButton new];
    [openCameraBtn setImage:cameraNormalImage forState:UIControlStateNormal];
    [openCameraBtn setImage:cameraHighlightedImage forState:UIControlStateHighlighted];
    [self addAttachButton:openCameraBtn];
    return openCameraBtn;
}

- (UIButton *)addDefaultImageMessageBtn
{
    UIImage *imageIcon = [ChatUtilities getImageNamed:@"image_icon"];
    UIImage *imageNormalImage = [imageIcon imageMaskedWithColor:[ChatUtilities getColorNamed:@"blueBubbleColor"]];
    UIImage *imageHighlightedImage = [imageIcon imageMaskedWithColor:[UIColor lightGrayColor]];
    UIButton *addImageBtn = [UIButton new];
    [addImageBtn setImage:imageNormalImage forState:UIControlStateNormal];
    [addImageBtn setImage:imageHighlightedImage forState:UIControlStateHighlighted];
    [self addAttachButton:addImageBtn];
    return addImageBtn;
}

- (UIButton *)addDefaultVoiceMessageBtn
{
    UIImage *micImage = [ChatUtilities getImageNamed:@"mic_icon"];
    UIImage *micNormalImage = [micImage imageMaskedWithColor:[ChatUtilities getColorNamed:@"blueBubbleColor"]];
    UIImage *micHighlightedImage = [micImage imageMaskedWithColor:[UIColor lightGrayColor]];
    UIButton *addVoiceBtn = [UIButton new];
    [addVoiceBtn setImage:micNormalImage forState:UIControlStateNormal];
    [addVoiceBtn setImage:micHighlightedImage forState:UIControlStateHighlighted];
    [self addAttachButton:addVoiceBtn];
    return addVoiceBtn;
}

//may be used for emoji or customizing any other
- (void)addAttachButton:(UIButton *)button
{
    button.frame = CGRectMake(attachStackView.subviews.count * 32, 0, 32, 32);
    [attachStackView addSubview:button];
    attachStackWidthConstraint.constant = attachStackView.subviews.count * 32;
}

- (void)removeAttachButton:(UIButton *)button
{
    [button removeFromSuperview];
    attachStackWidthConstraint.constant = attachStackView.subviews.count * 32;
}

- (NSString *)currentlyComposedMessageText
{
    //  auto-accept any auto-correct suggestions
    [messageTextView.inputDelegate selectionWillChange:messageTextView];
    [messageTextView.inputDelegate selectionDidChange:messageTextView];

    return [ChatUtilities stringByTrimingWhitespace:messageTextView.text];
}

- (IBAction)sendMessageAction:(id)sender
{
    NSString *text = [self currentlyComposedMessageText];
    if(!text || text.length == 0)
        return;
    
    [self.chatDisplayDelegate sendNewTextMessage:text];
    
    [self finishSendingMessageAnimated:YES];
}

- (IBAction)expandAction:(UIButton *)sender
{
    [expandBtn setHidden:YES];
    expandBtnWidthConstraint.constant = 0;
    [attachStackView setHidden:NO];
    
    attachStackWidthConstraint.constant = attachStackView.subviews.count * 32;
    [toolbarView setNeedsLayout];
    [UIView animateWithDuration:0.2 animations:^{
        [self->toolbarView layoutIfNeeded];
    }];
}

- (void)contractAttachView
{
    [expandBtn setHidden:NO];
    expandBtnWidthConstraint.constant = 32;
    [attachStackView setHidden:YES];
    attachStackWidthConstraint.constant = 32;
}

#pragma mark - Keyboard handling

- (void)addKeyboardObservers {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];

}

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSInteger animationCurveOption = (animationCurve << 16);
    double animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardEndFrameConverted = [self.view convertRect:keyboardEndFrame fromView:nil];
    int safeArea = [ChatUtilities getInsetBottomValue];
    tapGesture.enabled = YES;

    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationCurveOption
                     animations:^{
                        self->bottomConstraint.constant = keyboardEndFrameConverted.size.height - safeArea;
                     }
                     completion:nil];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    bottomConstraint.constant = 0;
    tapGesture.enabled = NO;
}

@end
