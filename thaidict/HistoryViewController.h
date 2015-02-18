//
//  HistoryViewController.h
//  thaidict
//
//  Created by Rnut on 2/9/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "History.h"
#import "DetailVocabViewController.h"
@interface HistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *hisInfo;
    IBOutlet UITableView *TableView;
    IBOutlet UIBarButtonItem *edit;
}
@property(nonatomic,strong) NSMutableArray *hisInfo;
- (IBAction)editBtn:(id)sender;

@end
