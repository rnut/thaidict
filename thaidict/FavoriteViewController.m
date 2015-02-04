//
//  FavoriteViewController.m
//  thaidict
//
//  Created by Rnut on 1/27/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import "FavoriteViewController.h"

@interface FavoriteViewController ()

@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Table setDelegate:self];
    [Table setDataSource:self];
//    [self setInterface];
    self.lang = 1;
    
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //[self.favList setEditing:YES animated:YES];
    //[self.editmode setHidden:YES];
    self.favWords = [Favorite listFavorite]; //default: get fav first (array of array)
    [Table reloadData];

}
-(IBAction)editMode:(id)sender{
    [Table setEditing:YES animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) segmentedControlIndexChanged
{
    switch (Segmented.selectedSegmentIndex)
    {
        case 0: //english
        {
            self.lang =1;
//            self.favWords = [self getFavWords];
            [Table reloadData];
        }
            break;
        case 1: //thai
        {
            self.lang=0;
//            self.favWords = [self getFavWords];
            [Table reloadData];
        }
            break;
        default:
            break;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.lang == LanguageENG) {
        return [[self.favWords objectAtIndex:0] count]; //english
    }
    else
        return [[self.favWords objectAtIndex:1] count]; //thai
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"FavCell";
    
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
    }
    
    //WordInfo *info = [self.favWords objectAtIndex:indexPath.row];
    //Language *myLang = [[Language alloc] init];
    //NSLog(@"%@",info.esearch);
    if (self.lang == LanguageENG)
    {
        cell.textLabel.text = [[self.favWords objectAtIndex:0] objectAtIndex:indexPath.row];
    }
    
    else if (self.lang == LanguageTHA)
    {
        cell.textLabel.text = [[self.favWords objectAtIndex:1] objectAtIndex:indexPath.row];
    }
    
    
    return cell;
    
    
}
-(UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    return 3;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.editing == YES) {
        NSLog(@"%d",(int)indexPath.row);
    }
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor redColor] title:@"Delete"];
    
    
    return rightUtilityButtons;
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    //NSIndexPath *indexPath = [self.words indexPathForCell:cell];
    //NSLog(@"%lu",indexPath.row);
    NSIndexPath *cellIndexPath = [Table indexPathForCell:cell];
    NSLog(@"%@",[[self.favWords objectAtIndex:0] objectAtIndex:cellIndexPath.row]);
    switch (index) {
        case 0:
        {
            if (self.lang == 1) {
                
                //WordInfo *info = [[self.favWords objectAtIndex:0] objectAtIndex:cellIndexPath.row];
                [self deleteFavWord:[[self.favWords objectAtIndex:0] objectAtIndex:cellIndexPath.row]];
                [[self.favWords objectAtIndex:0] removeObjectAtIndex:cellIndexPath.row];
                
            }
            else
            {
                //WordInfo *info = [[self.favWords objectAtIndex:1] objectAtIndex:cellIndexPath.row];
                [self deleteFavWord:[[self.favWords objectAtIndex:1] objectAtIndex:cellIndexPath.row]];
                [[self.favWords objectAtIndex:1] removeObjectAtIndex:cellIndexPath.row];
                
            }
            
            [Table deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            NSLog(@"DELETE");
            break;
        }
            
            
        default:
            break;
    }
}

//- (NSMutableArray *)getFavWords
//{
//    NSMutableArray *retrievalEng = [[NSMutableArray alloc] init];
//    NSMutableArray *retrievalThai = [[NSMutableArray alloc] init];
//    DB *db = [[DB alloc ]init];
//    
//    NSString *strQuery = [NSString stringWithFormat:@"SELECT search FROM fav"];
//    
//    [db queryWithString:strQuery];
//    while([db.ObjResult next]) {
//        NSString *temp = [db.ObjResult stringForColumn:@"search"];
//        if([Language checkLanguage:temp] == LanguageTHA)
//            [retrievalThai addObject:temp];
//        else
//            [retrievalEng addObject:temp];
//    }
//    [db closeDB];
//    NSMutableArray *retrieval = [[NSMutableArray alloc] init];
//    [retrieval addObject:retrievalEng];
//    [retrieval addObject:retrievalThai];
//    return retrieval;
//}

- (void) deleteFavWord:(NSString *)favword
{
    DB *db = [[DB alloc ]init];
    //int favID = fav;
    NSString *strQuery = [NSString stringWithFormat:@"DELETE FROM fav WHERE search = '%@'", favword];
    
    [db queryWithString:strQuery];
    [db closeDB];
}



@end
