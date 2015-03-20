//
//  TMSplashScreenViewController.m
//  thaidict
//
//  Created by Rnut on 3/11/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import "ScreenViewController.h"

@interface ScreenViewController ()

@end

@implementation ScreenViewController
- (BOOL)shouldAutorotate
{
    return NO;
}
- (void)splashScreenBecomeLoadingState{
    NSLog(@"become");
}

/**
 Action after splashScreen play finished.
 */

- (void)splashScreenDidPlayFinished{
    NSLog(@"did");
}

/**
 Custom splash screen orientation.
 */

- (UIInterfaceOrientation)splashScreenOrientation{
    NSLog(@"ori");
    return UIInterfaceOrientationIsPortrait(UIInterfaceOrientationPortrait);
}
@end
