//
//  LinkMessageCell.m
//  iOSChat
//
//  Created by Asmaa Kohla on 04/04/2022.
//

#import <Foundation/Foundation.h>
#import "LinkMessageCell.h"

@implementation LinkMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.messageTextView.textContainerInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.messageTextView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.messageTextView.textAlignment = NSTextAlignmentNatural;
    
    self.linkView = [[LPLinkView alloc] init];
    [self.linkContentView addSubview:self.linkView];
}

- (void)setData:(LPLinkMetadata *)metadata withSize:(CGSize)size
{
    [self.linkView setMetadata:metadata];
    self.linkView.frame = CGRectMake(0, 0, size.width, size.height);
    
    self.linkContentHeightConstraint.constant = size.height;
    self.linkContentWidthConstraint.constant = size.width;
    [self.linkContentView layoutSubviews];
}

- (void)clearData
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.5]};
    CGFloat textLabelWidth = [self.messageTextView.text boundingRectWithSize:CGSizeMake(self.frame.size.width - 85, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:nil].size.width;
    
    self.linkContentWidthConstraint.constant = textLabelWidth + 10 + 20;
    
    self.linkContentHeightConstraint.constant = 0;
    self.linkView.frame = CGRectZero;
    //self.linkView.metadata = [LPLinkMetadata new];
}

@end
