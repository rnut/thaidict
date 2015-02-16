//
//  SplitViewSearch.m
//  thaidict
//
//  Created by Rnut on 2/16/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import "SplitViewSearch.h"

@interface SplitViewSearch ()

@end

@implementation SplitViewSearch

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -split view
- (BOOL)splitViewController:(UISplitViewController *)splitViewController showDetailViewController:(UIViewController *)vc sender:(id)sender{
    return NO;
}
-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}
- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController{
    return YES;
}

@end
