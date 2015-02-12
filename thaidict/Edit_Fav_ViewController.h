//
//  Edit_Fav_ViewController.h
//  thaidict
//
//  Created by Rnut on 2/5/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Favorite.h"
#import "Vocab.h"
@interface Edit_Fav_ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>


@property(nonatomic,strong)NSMutableArray *FavInfo;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *Closebtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *SelectAllbtn;
@property (strong, nonatomic) IBOutlet UITableView *TableView;
@property (strong, nonatomic) IBOutlet UIButton *Deletebtn;
@property (strong, nonatomic) IBOutlet UIView *ViewDelete;
- (IBAction)delete:(id)sender;
- (IBAction)closeEditView:(id)sender;
-(IBAction)selectAll:(id)sender;
@end
