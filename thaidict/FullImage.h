//
//  FullImage.h
//  thaidict
//
//  Created by Rnut on 3/16/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "APImage.h"
@interface FullImage : UIViewController
//@property(nonatomic,strong)NSString *UrlImage;

@property (strong, nonatomic) IBOutlet UIImageView *FullImage;
@property (strong, nonatomic) IBOutlet UIButton *close;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *Indicator;
@property(nonatomic,strong)NSArray *rawData;
@property(nonatomic,assign)int indexChoose;
@property(nonatomic,strong)UIImage *bg;

- (IBAction)close:(id)sender;
@end
