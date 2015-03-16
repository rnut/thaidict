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
- (void)viewDidLoad {
    [super viewDidLoad];
    //1
    NSURL *url = [NSURL URLWithString:self.UrlImage];
    
    // 2
    [self.Indicator startAnimating];
    NSURLSessionDownloadTask *downloadPhotoTask = [[NSURLSession sharedSession]
                                                   downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                       // 3
                                                       img = [UIImage imageWithData:
                                                                                   [NSData dataWithContentsOfURL:location]];
                                                       
                                                       self.FullImage.image = img;
                                                       [self.Indicator stopAnimating];
                                                   }];
    
    // 4	
    [downloadPhotoTask resume];
    self.FullImage.image = img;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)close:(id)sender {
     [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
