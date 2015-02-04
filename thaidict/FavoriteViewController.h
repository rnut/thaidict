//
//  FavoriteViewController.h
//  thaidict
//
//  Created by Rnut on 1/27/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DB.h"
#import "Vocab.h"
#import "SWTableViewCell.h"
#import "Favorite.h"

@interface FavoriteViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate>
{
    IBOutlet UISegmentedControl *Segmented;
    IBOutlet UITableView *Table;
    IBOutlet UIBarButtonItem *Edit_bbt;
}

@property (nonatomic, retain) NSMutableArray *favWords;
@property (strong, nonatomic) IBOutlet UIView *toparea;
@property int lang;

//- (NSMutableArray *)getFavWords;
- (void) deleteFavWord:(NSString *)favword;
- (IBAction)segmentedControlIndexChanged;
-(IBAction)editMode:(id)sender;

@end
