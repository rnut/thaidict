//
//  MyAlert.h
//  
//
//  Created by tu on 6/4/2552.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAuthenticating @"Loading"
#define kWaitingMessage @"Please Waiting..."


UIAlertView *alertViewProgress;

void MyAlertWithError(NSError *error);
void MyAlertWithMessage(NSString *message);
void MyAlertWithMessageAndDelegate(NSString *message, id delegate);

void MyAlertWithActivityIndicatorStop(void);
void MyAlertWithActivityIndicatorShow(void);
void MyAlertWithActivityIndicatorShowWihtMessage(NSString *title, NSString *message);
void MyAlertWithProgressIndicatorShowWithTitle(NSString *title, UIProgressView *progressIndicator);