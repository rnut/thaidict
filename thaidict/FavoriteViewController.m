//
//  FavoriteViewController.m
//  thaidict
//
//  Created by Rnut on 1/27/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import "FavoriteViewController.h"
#import "Edit_Fav_ViewController.h"
@interface FavoriteViewController ()
{
    UIRefreshControl *refresh;
}
@end

@implementation FavoriteViewController

-(void)viewDidAppear:(BOOL)animated{
    [self viewDidLoad];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [Table setDelegate:self];
    [Table setDataSource:self];
    self.lang = LanguageENG;

    [self setInterface];
    self.favWords = [Favorite listFavorite];
    [segment setSelectedSegmentIndex:0];
    [Table reloadData];

}

-(void)setInterface{
    
    refresh = [[UIRefreshControl alloc]init];
    [refresh addTarget:self
                action:@selector(refreshData:)
      forControlEvents:UIControlEventValueChanged];
    [Table addSubview:refresh];
}

-(void)refreshData:(UIRefreshControl *)refreshControl{
    self.favWords = [Favorite listFavorite];
    [Table reloadData];
    [refreshControl endRefreshing];
    
}

-(IBAction)editMode:(id)sender{
    [Table setEditing:YES animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source/delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.lang == LanguageENG) {
        return [[self.favWords objectAtIndex:1] count]; //english
    }
    else
        return [[self.favWords objectAtIndex:0] count]; //thai
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"FavCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//     SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.rightUtilityButtons = [self rightButtons];
//        cell.delegate = self;
        cell.showsReorderControl=YES;
    }
    if (self.lang == LanguageENG)
    {
        cell.textLabel.text = [[[[self.favWords objectAtIndex:1] objectAtIndex:indexPath.row] Fav_vocab] Search];
    }
    
    else if (self.lang == LanguageTHA)
    {
        cell.textLabel.text = [[[[self.favWords objectAtIndex:0] objectAtIndex:indexPath.row] Fav_vocab] Search];
    }
    
    
    
    return cell;
    
    
}
-(UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *temp;
        if (self.lang == LanguageENG) {
            [Favorite deleteFavorite:[[self.favWords objectAtIndex:1] objectAtIndex:indexPath.row]];
            temp = [self.favWords objectAtIndex:1];
            [temp removeObjectAtIndex:indexPath.row];
            [self.favWords replaceObjectAtIndex:1 withObject:temp];


        }
        if (self.lang == LanguageTHA) {
            [Favorite deleteFavorite:[[self.favWords objectAtIndex:0] objectAtIndex:indexPath.row]];
            temp = [self.favWords objectAtIndex:0];
            [temp removeObjectAtIndex:indexPath.row];
            [self.favWords replaceObjectAtIndex:0 withObject:temp];
        }
        
        [Table reloadData];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.editing == YES) {
        NSLog(@"%d",(int)indexPath.row);
    }
    else{
        [self performSegueWithIdentifier:@"chooseVocab" sender:nil];
    }
}
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

#pragma mark swipeable
//- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
//{
//    // allow just one cell's utility button to be open at once
//    return YES;
//}
//- (NSArray *)rightButtons
//{
//    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
//    [rightUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor redColor] title:@"Delete"];
//    
//    
//    return rightUtilityButtons;
//}
//
//- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
//    
//    //NSIndexPath *indexPath = [self.words indexPathForCell:cell];
//    //NSLog(@"%lu",indexPath.row);
//    NSIndexPath *cellIndexPath = [Table indexPathForCell:cell];
//    NSLog(@"%@",[[self.favWords objectAtIndex:0] objectAtIndex:cellIndexPath.row]);
//    switch (index) {
//        case 0:
//        {
//            if (self.lang == LanguageENG) {
//                [Favorite deleteFavorite:[[self.favWords objectAtIndex:0] objectAtIndex:index]];
//                [[self.favWords objectAtIndex:0] removeObjectAtIndex:cellIndexPath.row];
//                
//            }
//            else
//            {
//                [Favorite deleteFavorite:[[self.favWords objectAtIndex:1] objectAtIndex:index]];
//                [[self.favWords objectAtIndex:1] removeObjectAtIndex:cellIndexPath.row];
//                
//            }
//            
//            [Table deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
//            NSLog(@"DELETE");
//            break;
//        }
//            
//            
//        default:
//            break;
//    }
//}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"editFavLine"]) {
        Edit_Fav_ViewController *edv = [segue destinationViewController];
        NSMutableArray *data;
        if(self.lang == LanguageTHA)
            data = [self.favWords objectAtIndex:0];
        else
            data = [self.favWords objectAtIndex:1];
        
        [edv setFavInfo:data];
    }
    else if ([[segue identifier] isEqualToString:@"chooseVocab"])
    {
        // Get reference to the destination view controller
        
        DetailVocabViewController *vc = [segue destinationViewController];
        NSMutableArray *data;
        if(self.lang == LanguageTHA)
            data = [self.favWords objectAtIndex:0];
        else
            data = [self.favWords objectAtIndex:1];
        Favorite *choose = [data objectAtIndex:[[Table indexPathForSelectedRow] row]];
        [History keepHistory:choose.Fav_vocab];
        [vc setChooseVocab:choose.Fav_vocab];
    }
}
/**/


- (IBAction)segmentedChange:(id)sender {
        switch (segment.selectedSegmentIndex)
        {
            case 0: //eng
            {
                self.lang = LanguageENG;
    //            self.favWords = [self getFavWords];
                [Table reloadData];
            }
                break;
            case 1: //tha
            {
                self.lang=LanguageTHA;
    //            self.favWords = [self getFavWords];
                [Table reloadData];
            }
                break;
            default:
                break;
        }
}
@end
