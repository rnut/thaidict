//
//  Edit_Fav_ViewController.m
//  thaidict
//
//  Created by Rnut on 2/5/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import "Edit_Fav_ViewController.h"
#import "FavoriteViewController.h"
@interface Edit_Fav_ViewController ()

@end

@implementation Edit_Fav_ViewController

@synthesize FavInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *red = [UIColor colorWithRed:(228/255.0) green:3/255.0 blue:21/255.0 alpha:1.0f];
    [self.view setBackgroundColor:red];
    [self.TableView setDelegate:self];
    [self.TableView setDataSource:self];
    [self.TableView setEditing:YES];
    [self.TableView reloadData];

}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#pragma mark - Table view data source/delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return [self.FavInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"FavCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //     SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.showsReorderControl=YES;
    }
        cell.textLabel.text = [[[self.FavInfo objectAtIndex:indexPath.row] Fav_vocab] Search];

    return cell;
    
    
}
-(UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    return 3;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.editing == YES) {

//        NSLog(@"%d",(int)[[chooseArray objectAtIndex:0] row]);
//        [chooseArray addObject:indexPath];
        
        
    }
    
    
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath != destinationIndexPath) {
        Favorite *favToMove = [self.FavInfo objectAtIndex:sourceIndexPath.row];
        [self.FavInfo removeObjectAtIndex:sourceIndexPath.row];
        [self.FavInfo insertObject:favToMove atIndex:destinationIndexPath.row];
        [Favorite reOrderFav:self.FavInfo];
    }
}
#pragma mark alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSArray *selected = [self.TableView indexPathsForSelectedRows];
        for (int i =0 ; i<[selected count]; i++) {
            [Favorite deleteFavorite:[FavInfo objectAtIndex:[[selected objectAtIndex:i] row]]];
            
        }
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
    
}



#pragma mark ibaction
- (IBAction)delete:(id)sender {
    NSArray *selected = [self.TableView indexPathsForSelectedRows];
    if ([selected count] > 0) {
        
        UIAlertView *alert;
        if (selected.count != self.FavInfo.count) {
            alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Are you sure want to delete %lu items?",(unsigned long)selected.count] delegate:self cancelButtonTitle:@"no" otherButtonTitles:@"yes", nil];
        }
        else alert = [[UIAlertView alloc] initWithTitle:@"Delete favorite" message:@"Are you sure want to delete all ?" delegate:self cancelButtonTitle:@"no" otherButtonTitles:@"yes", nil];
        [alert show];
        
    }
}
- (IBAction)closeEditView:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
-(IBAction)selectAll:(id)sender{
    if ([[self.SelectAllbtn title] isEqualToString:@"Check All"]) {
        [self.SelectAllbtn setTitle:@"Uncheck All"];
        for (int j = 0; j < [self.TableView numberOfRowsInSection:0]; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:0];
            [self.TableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
    }
    else{
        [self.SelectAllbtn setTitle:@"Check All"];
        for (int j = 0; j < [self.TableView numberOfRowsInSection:0]; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:0];
            [self.TableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }

}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
