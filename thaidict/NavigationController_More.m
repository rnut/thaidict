//
//  NavigationController_More.m
//  thaidict
//
//  Created by Rnut on 3/10/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import "NavigationController_More.h"
#import "MoreViewController.h"
@interface NavigationController_More ()

@end

@implementation NavigationController_More

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotate
{
    id currentViewController = self.topViewController;
    
    if ([currentViewController isKindOfClass:[MoreViewController class]])
        return NO;
    
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
