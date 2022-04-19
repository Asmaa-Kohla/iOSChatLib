//
//  LinkMessageCell.h
//  iOSChat
//
//  Created by Asmaa Kohla on 04/04/2022.
//

#import "BubbleMessageCell.h"
#import <LinkPresentation/LinkPresentation.h>

#define kLinkMessageMaxHeight 250
#define kLinkMessageCellMargin 26

API_AVAILABLE(ios(13.0))
@interface LinkMessageCell : BubbleMessageCell

@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@property (weak, nonatomic) IBOutlet UIView *linkContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *linkContentHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *linkContentWidthConstraint;

@property (strong, nonatomic) LPLinkView *linkView;

- (void)clearData;
- (void)setData:(LPLinkMetadata *)metadata withSize:(CGSize)size;

@end
