//
//  TMWebSheetViewController.h
//  TMTrueMoveOnly
//
//  Created by True Digial and Media Content on 9/14/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMWebSheetViewController : UIViewController

@property (nonatomic, strong) NSURL *loadURL;

+ (NSString *)currentVersion;

- (id)initWithURL:(NSURL *)url;

@end
