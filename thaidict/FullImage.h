//
//  FullImage.h
//  thaidict
//
//  Created by Rnut on 3/16/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullImage : UIViewController
@property(nonatomic,strong)NSString *UrlImage;
- (IBAction)close:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *FullImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *Indicator;

@end
