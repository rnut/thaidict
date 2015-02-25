//
//  PopOverDetail.h
//  thaidict
//
//  Created by Rnut on 2/25/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopOverDetail : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *shareSource;
}
@property (strong, nonatomic) IBOutlet UITableView *Tableview;

@end
