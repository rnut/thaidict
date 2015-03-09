//
//  MyAlert.m
//  
//
//  Created by tu on 6/4/2552.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MyAlert.h"
//#import "TLGlobal-Constants.h"

#define OK_BUTTON @"OK"

void MyAlertWithError(NSError *error)
{
    NSString *message = [NSString stringWithFormat:@"Error! %@ %@", [error localizedDescription],[error localizedFailureReason]];
	MyAlertWithMessage (message);
}


void MyAlertWithMessage(NSString *message)
{
	NSDictionary *infoPlistDict = [[NSBundle mainBundle] infoDictionary];
	NSString *appName = [infoPlistDict objectForKey:@"CFBundleDisplayName"];

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appName message:message delegate:nil cancelButtonTitle:OK_BUTTON otherButtonTitles: nil];
	[alert show];

}


void MyAlertWithMessageAndDelegate(NSString *message, id delegate)
{
	NSDictionary *infoPlistDict = [[NSBundle mainBundle] infoDictionary];
	NSString *appName = [infoPlistDict objectForKey:@"CFBundleDisplayName"];

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appName message:message delegate:delegate cancelButtonTitle:OK_BUTTON otherButtonTitles:nil, nil];
	[alert show];

}


void MyAlertWithActivityIndicatorStop(void)
{
	if (alertViewProgress)
	{
		[alertViewProgress dismissWithClickedButtonIndex:0 animated:NO];

		alertViewProgress = nil;
	}
}

void MyAlertWithActivityIndicatorShow(void)
{
	UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[activityIndicatorView startAnimating];
	activityIndicatorView.frame = CGRectMake(120.0, 72.0, 35.0, 35.0);
	alertViewProgress = [[UIAlertView alloc] initWithTitle:kAuthenticating message:kWaitingMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
	[alertViewProgress addSubview:activityIndicatorView];

	
	[alertViewProgress show];
}

void MyAlertWithActivityIndicatorShowWihtMessage(NSString *title, NSString *message)
{
	UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[activityIndicatorView startAnimating];
	activityIndicatorView.frame = CGRectMake(120.0, 72.0, 35.0, 35.0);
	alertViewProgress = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
	[alertViewProgress addSubview:activityIndicatorView];

	
	[alertViewProgress show];
}

void MyAlertWithProgressIndicatorShowWithTitle(NSString *title, UIProgressView *progressIndicator)
{
	
	progressIndicator.frame = CGRectMake(20.0, 85.0, 250.0, 20.0);
	progressIndicator.progress = 0.0;
	alertViewProgress = [[UIAlertView alloc] initWithTitle:title message:@"Uploading..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
	[alertViewProgress addSubview:progressIndicator];

	
	[alertViewProgress show];
}

