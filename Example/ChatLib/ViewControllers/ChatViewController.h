//
//  ChatViewController.h
//  iOSChat
//
//  Created by Asmaa Kohla on 09/04/2022.
//

#import <UIKit/UIKit.h>
#import "ChatDisplayViewController.h"

@interface ChatViewController : UIViewController<ChatDisplayDelegate>
{
    __weak IBOutlet UIView *chatContainerView;
}

@end

