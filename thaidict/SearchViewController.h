//
//  SearchViewController.h
//  thaidict
//
//  Created by Rnut on 1/21/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "DB.h"
#import "Vocab.h"
#import "DetailVocabViewController.h"
#import "Favorite.h"
#import "APSample.h"
#import "History.h"

@interface SearchViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, SWTableViewCellDelegate>
{
    IBOutlet UITextField *SearchBox;
    IBOutlet UITableView *TableWords;
}
@property (nonatomic, retain) NSArray *ArrayWords;
@property (nonatomic, copy) NSString *SelectedCellText;
//- (NSMutableArray *)findWordInfos: (NSString *) str;



//-(int) getIDLastRecord;



@end
