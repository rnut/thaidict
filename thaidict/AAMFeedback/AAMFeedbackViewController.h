//
//  AAMFeedbackViewController.h
//  AAMFeedbackViewController
//
//  Created by 深津 貴之 on 11/11/30.
//  Copyright (c) 2011年 Art & Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "FeedbackService.h"
//#import "APIService.h"

@interface AAMFeedbackViewController : UITableViewController <UITextViewDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate>
{
    UITextView  *_descriptionTextView;
    UITextField *_descriptionPlaceHolder;
    NSInteger _selectedTopicsIndex;
    BOOL _isFeedbackSent;
    
    FeedbackService *feedbackService;
    //APIService *apiService;
}

@property (retain, nonatomic) NSString *descriptionText;
@property (retain, nonatomic) NSArray *topics;
@property (retain, nonatomic) NSArray *topicsToSend;
@property (retain, nonatomic) NSArray *toRecipients;
@property (retain, nonatomic) NSArray *ccRecipients;
@property (retain, nonatomic) NSArray *bccRecipients;
@property (retain, nonatomic) NSString *currentUserName;
@property (retain, nonatomic) NSString *currentSSOID;
@property (retain, nonatomic) NSMutableArray *array;

+ (BOOL)isAvailable;
- (id)initWithTopics:(NSArray*)theTopics;

@end
