//
//  MessageCell.h
//  iOSChat
//
//  Created by Asmaa Kohla on 24/03/2022.
//

#import <UIKit/UIKit.h>
#import "SendingState.h"
#import "ChatUtilities.h"

@interface MessageCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *dummingView;
@property (weak, nonatomic) IBOutlet UIImageView *sendingStateImage;

+ (UINib *)nib;
+ (NSString *)cellReuseIdentifier;
+ (NSDictionary *)getDateTextAttributes;

- (void)setDateTimeLabelText:(NSAttributedString *)dateTimeString;
- (void)setSendingStateImage:(SendingState)state isRead:(BOOL)isRead;

@end
