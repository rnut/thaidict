//
//  FullImage.m
//  thaidict
//
//  Created by Rnut on 3/16/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import "FullImage.h"
#import "Connect.h"
@interface FullImage ()
{
    UIImage *img;
}
@end

@implementation FullImage
@synthesize FullImage;
-(void)viewWillAppear:(BOOL)animated{
    self.view.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *upSwipe =[[UISwipeGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(upSwipe:)];
    [upSwipe setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:upSwipe];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:self.bg]];
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = self.view.bounds;
    [self.view addSubview:visualEffectView];
    
    [self.view bringSubviewToFront:FullImage];
    [self.view bringSubviewToFront:self.Indicator];
    [self.view bringSubviewToFront:self.close];
    
}
- (void)upSwipe:(UISwipeGestureRecognizer *)recognizer {
//    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
//    NSLog(@"x : %f",location.x);
//    NSLog(@"y : %f",location.y);
    NSLog(@"UP");
    [self dismissMe];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
        [self.Indicator startAnimating];
        NSURL *url = [NSURL URLWithString:[[self.rawData objectAtIndex:self.indexChoose] objectForKey:@"unescapedUrl"]];
        img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (img != nil) {
                self.FullImage.image = img;
                [self.Indicator stopAnimating];
            }
            
        });
    });
    
    
    
    // 2
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)close:(id)sender {
    [self dismissMe];
}
-(void) dismissMe {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.7;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionFromTop;
    transition.subtype = kCATransitionFade;
    
    // NSLog(@"%s: controller.view.window=%@", _func_, controller.view.window);
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    
    [self dismissViewControllerAnimated:NO completion:^{}];
}
@end
