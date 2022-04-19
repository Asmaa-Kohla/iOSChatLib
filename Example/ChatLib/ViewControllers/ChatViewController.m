//
//  ChatViewController.m
//  iOSChat
//
//  Created by Asmaa Kohla on 09/04/2022.
//

#import "ChatViewController.h"
#import "TextMessageData.h"
#import "ImageMessageData.h"
#import "VoiceMessageData.h"
#import "VideoMessageData.h"
#import "LinkMessageData.h"
#import "UIImage+ChatLib.h"
#import "ChatUtilities.h"

@interface ChatViewController ()
{
    NSMutableArray *messagesList;
}
@end

@implementation ChatViewController
{
    ChatDisplayViewController *chatDisplayViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"User Name";
    
    [self initTestData];
    
    [self initChatDisplay];
}

- (void)initTestData
{
    messagesList = [NSMutableArray new];
    
    long userA = 1;
    long userB = 2;
    
    [messagesList addObject:[[TextMessageData alloc] init:0 sendTime:[NSDate new] senderId:userA receiverId:userB isSentByMe:YES sendingState:kSent isSeen:YES messageTxt:@"Hello World!"]];
    
    [messagesList addObject:[[TextMessageData alloc] init:1 sendTime:[NSDate new] senderId:userB receiverId:userA isSentByMe:NO sendingState:kSent isSeen:YES messageTxt:@"Hello There"]];
    
    [messagesList addObject:[[TextMessageData alloc] init:12 sendTime:[NSDate new] senderId:userA receiverId:userB isSentByMe:YES sendingState:kSent isSeen:YES messageTxt:@"this is a very very very long long message for testing propose"]];
    
    [messagesList addObject:[[TextMessageData alloc] init:13 sendTime:[NSDate new] senderId:userB receiverId:userA isSentByMe:NO sendingState:kSent isSeen:YES messageTxt:@"this is a very very very long long message for testing propose"]];
    
    NSString *link = @"https://images.unsplash.com/photo-1566004100631-35d015d6a491?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8d2VsY29tZSUyMGJhYnl8ZW58MHx8MHx8&w=1000&q=80";
    [messagesList addObject:[[ImageMessageData alloc] init:2 sendTime:[NSDate new] senderId:userA receiverId:userB isSentByMe:YES sendingState:kSent isSeen:YES imageUrl:link thumbnailUrl:link]];
    
    NSString *link2 = @"https://images.unsplash.com/photo-1617331140180-e8262094733a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8Ym95JTIwYmFieXxlbnwwfHwwfHw%3D&w=1000&q=80";
    [messagesList addObject:[[ImageMessageData alloc] init:3 sendTime:[NSDate new] senderId:userB receiverId:userA isSentByMe:NO sendingState:kSent isSeen:YES imageUrl:link2 thumbnailUrl:link2]];
    
    [messagesList addObject:[[VoiceMessageData alloc] init:4 sendTime:[NSDate new] senderId:userA receiverId:userB isSentByMe:YES sendingState:kSent isSeen:YES recordingUrl:@"" duration:70]];
    
    [messagesList addObject:[[VoiceMessageData alloc] init:5 sendTime:[NSDate new] senderId:userB receiverId:userA isSentByMe:NO sendingState:kSent isSeen:YES recordingUrl:@"" duration:6]];
    
    [messagesList addObject:[[VideoMessageData alloc] init:6 sendTime:[NSDate new] senderId:userA receiverId:userB isSentByMe:YES sendingState:kSent isSeen:YES thumbnailUrl:@"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQML45_xmr-JPnIM4krQmNEZAyLdVjEmK1Cvw&usqp=CAU" videoUrl:nil]];
    
    [messagesList addObject:[[VideoMessageData alloc] init:7 sendTime:[NSDate new] senderId:userB receiverId:userA isSentByMe:NO sendingState:kSent isSeen:YES thumbnailUrl:@"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTc3YNE-PhDOwgCWFpdikit8UsN_tezmCe53w&usqp=CAU" videoUrl:nil]];
    
    MessageData *message = [[MessageData alloc] init:8 sendTime:[NSDate new] senderId:userA receiverId:userB isSentByMe:YES sendingState:kSent isSeen:YES];
    message.isDeleted = YES;
    [messagesList addObject:message];
    message = [[MessageData alloc] init:9 sendTime:[NSDate new] senderId:userB receiverId:userA isSentByMe:NO sendingState:kSent isSeen:YES];
    message.isDeleted = YES;
    [messagesList addObject:message];
    
    [messagesList addObject:[[LinkMessageData alloc] init:10 sendTime:[NSDate new] senderId:userA receiverId:userB isSentByMe:YES sendingState:kSent isSeen:YES messageTxt:@"https://www.google.com"]];
    
    [messagesList addObject:[[LinkMessageData alloc] init:11 sendTime:[NSDate new] senderId:userB receiverId:userA isSentByMe:NO sendingState:kSent isSeen:YES messageTxt:@"https://www.github.com"]];
}

- (void)initChatDisplay
{
    chatDisplayViewController = [[ChatDisplayViewController alloc] initWithNibName:@"ChatDisplayViewController" bundle:[NSBundle bundleForClass:[ChatDisplayViewController class]]];
    chatDisplayViewController.chatDisplayDelegate = self;
    
    [self addChildViewController:chatDisplayViewController];
    chatDisplayViewController.view.frame = CGRectMake(0, 0, chatContainerView.frame.size.width, chatContainerView.frame.size.height);
    [chatContainerView addSubview:chatDisplayViewController.view];
    [chatDisplayViewController didMoveToParentViewController:self];
    
    [chatDisplayViewController setToolBarHidden:NO];
    
    
    UIImage *accessoryImage = [ChatUtilities getImageNamed:@"clip"];
    UIImage *normalImage = [accessoryImage imageMaskedWithColor:[ChatUtilities getColorNamed:@"blueBubbleColor"]];
    UIImage *highlightedImage = [accessoryImage imageMaskedWithColor:[UIColor lightGrayColor]];
    UIButton *attachBtn = [UIButton new];
    [attachBtn setImage:normalImage forState:UIControlStateNormal];
    [attachBtn setImage:highlightedImage forState:UIControlStateHighlighted];
    [attachBtn addTarget:self action:@selector(attachAction:) forControlEvents:UIControlEventTouchUpInside];
    [chatDisplayViewController addAttachButton:attachBtn];
    
    UIButton *videoBtn = [chatDisplayViewController addDefaultVideoBtn];
    [videoBtn addTarget:self action:@selector(addVideoAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *CameraBtn = [chatDisplayViewController addDefaultCameraBtn];
    [CameraBtn addTarget:self action:@selector(openCameraAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *ImageBtn = [chatDisplayViewController addDefaultImageMessageBtn];
    [ImageBtn addTarget:self action:@selector(addImageAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *VoiceBtn = [chatDisplayViewController addDefaultVoiceMessageBtn];
    [VoiceBtn addTarget:self action:@selector(addVoiceAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Add message actions

- (void)addVideoAction:(id)button
{
    
}

- (void)openCameraAction:(id)button
{
    
}

- (void)addImageAction:(id)button
{
    
}

- (void)addVoiceAction:(id)button
{
    
}

- (void)attachAction:(id)button
{
    
}

#pragma mark - ChatDisplayDelegate methods

- (long)getMessagesCount
{
    return messagesList.count;
}

- (id<MessageProtocol>)getMessageAtIndex:(int)index
{
    return [messagesList objectAtIndex:index];
}

- (void)sendStartTyping
{
    //[chatDisplayViewController setShowTypingIndicator:YES];
}

- (void)sendStopTyping
{
    //[chatDisplayViewController setShowTypingIndicator:NO];
}

- (void)deleteMessage:(id<MessageProtocol>)message
{
    ((MessageData *)message).isDeleted = YES;
    [chatDisplayViewController reloadData];
}

- (void)sendNewTextMessage:(NSString *)text
{
    TextMessageData *message = [[TextMessageData alloc] init:0 sendTime:[NSDate new] senderId:1 receiverId:2 isSentByMe:YES sendingState:kNotSent isSeen:NO messageTxt:text];
    [messagesList addObject:message];
    [chatDisplayViewController reloadData];
    
    [self performSelector:@selector(messageSent:) withObject:message afterDelay:2];
}

- (void)messageSent:(MessageData *)message
{
    [message setSendingState:kSent];
    [chatDisplayViewController reloadData];
    [self performSelector:@selector(messageRead:) withObject:message afterDelay:2];
}

- (void)messageRead:(MessageData *)message
{
    [message setIsSeen:YES];
    [chatDisplayViewController reloadData];
}

@end
