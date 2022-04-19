//
//  ChatDisplayViewController.h
//  iOSChat
//
//  Created by Asmaa Kohla on 09/04/2022.
//

#import <UIKit/UIKit.h>
#import "MessageProtocol.h"
#import "TextMessageProtocol.h"
#import "LinkMessageProtocol.h"
#import "ImageMessageProtocol.h"
#import "VoiceMessageProtocol.h"
#import "VideoMessageProtocol.h"
#import "AudioOwnerDelegate.h"

@protocol ChatDisplayDelegate <NSObject>

- (long)getMessagesCount;
- (id<MessageProtocol>)getMessageAtIndex:(int)index;

- (void)sendStartTyping;
- (void)sendStopTyping;

- (void)deleteMessage:(id<MessageProtocol>)message;
- (void)sendNewTextMessage:(NSString *)text;

@end

@interface ChatDisplayViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, AudioOwnerDelegate>
{
    __weak IBOutlet UICollectionView *collectionView;
    
    //sending new messages tool bar
    __weak IBOutlet UIView *toolbarView;
    __weak IBOutlet UITextView *messageTextView;
    __weak IBOutlet UIButton *sendMessageBtn;
    __weak IBOutlet UIImageView *sendBtnImageView;
    __weak IBOutlet NSLayoutConstraint *bottomConstraint;
    __weak IBOutlet UIStackView *attachStackView;
    __weak IBOutlet NSLayoutConstraint *attachStackWidthConstraint;
    __weak IBOutlet UIButton *expandBtn;
    __weak IBOutlet NSLayoutConstraint *expandBtnWidthConstraint;
}

@property (nonatomic, weak) id<ChatDisplayDelegate> chatDisplayDelegate;

@property (assign, nonatomic) BOOL isPhotosFullScreenOpened;
@property (assign, nonatomic) BOOL isVideoPlaying;

/**
 *  Specifies whether or not the view controller should show the typing indicator for an incoming message.
 *
 *  @discussion Setting this property to `YES` will animate showing the typing indicator immediately.
 *  Setting this property to `NO` will animate hiding the typing indicator immediately. You will need to scroll
 *  to the bottom of the collection view in order to see the typing indicator. You may use `scrollToBottomAnimated:` for this.
 */
@property (assign, nonatomic) BOOL showTypingIndicator;

- (IBAction)sendMessageAction:(id)sender;
- (IBAction)expandAction:(UIButton *)sender;

- (void)reloadData;
- (void)reloadData:(BOOL)scrollToBottom isAnimated:(BOOL)isAnimated;
- (void)scrollToBottom:(BOOL)isAnimated;
- (void)setToolBarHidden:(BOOL)isHidden;

- (void)addAttachButton:(UIButton *)button;
- (UIButton *)addDefaultVideoBtn;
- (UIButton *)addDefaultCameraBtn;
- (UIButton *)addDefaultImageMessageBtn;
- (UIButton *)addDefaultVoiceMessageBtn;

@end
