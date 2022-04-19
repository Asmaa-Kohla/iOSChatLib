//
//  TextMessageCell.h
//  iOSChat
//
//  Created by Asmaa Kohla on 10/04/2022.
//

#import "BubbleMessageCell.h"

@interface TextMessageCell : BubbleMessageCell

@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@end
