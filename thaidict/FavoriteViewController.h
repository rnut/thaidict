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
//#import "SWTableViewCell.h"
#import "Favorite.h"
#import "DetailVocabViewController.h"

@interface FavoriteViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>//, SWTableViewCellDelegate>
{

    IBOutlet UITableView *Table;
    IBOutlet UIBarButtonItem *Edit_bbt;
    IBOutlet UISegmentedControl *segment;
}

@property (nonatomic, retain) NSMutableArray *favWords;
@property (strong, nonatomic) IBOutlet UIView *toparea;

@property int lang;

//- (NSMutableArray *)getFavWords;
//- (void) deleteFavWord:(NSString *)favword;
-(IBAction)editMode:(id)sender;
- (IBAction)segmentedChange:(id)sender;
@end
