//
//  TypingIndicatorFooterView.h
//  iOSChat
//
//  Created by Asmaa Kohla on 30/03/2022.
//

#import <UIKit/UIKit.h>

@interface TypingIndicatorFooterView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *bubbleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *typingIndicatorImageView;

+ (UINib *)nib;
+ (NSString *)cellReuseIdentifier;

@end
