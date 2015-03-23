//
//  Splash.m
//  thaidict
//
//  Created by Rnut on 3/23/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import "Splash.h"

@interface Splash ()

@end

@implementation Splash

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)splashScreenBecomeLoadingState{
}
- (BOOL)shouldAutorotate
{
    return NO;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return NO;
}
-(UIUserInterfaceIdiom)checkIdiomsize{
    UIUserInterfaceIdiom idiom;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        NSLog(@"iphone");
        return UIUserInterfaceIdiomPhone;
    }else{
        NSLog(@"ipad");
        return UIUserInterfaceIdiomPad;
    }
    return idiom;
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
