//
//  SearchViewController.m
//  thaidict
//
//  Created by Rnut on 1/21/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()
{
    
}
@end
NSInteger lastclickrow;
int idrec = 0;

@implementation SearchViewController
@synthesize ArrayWords,SelectedCellText;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInterface];

    [TableWords setDelegate:self];
    [TableWords setDataSource:self];
    [SearchBox setDelegate:self];
    
//    [TableWords setRowHeight:44];
    
    ArrayWords = [Vocab listDictByVocab:@"test"];
    [TableWords reloadData];
}
-(void)setInterface{
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:(228/255.0) green:3/255.0 blue:21/255.0 alpha:1.0f]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.tabBarController.tabBar setBarTintColor:[UIColor colorWithRed:(228/255.0) green:3/255.0 blue:21/255.0 alpha:1.0f]];
    [self.tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
}

#pragma mark textfield
-(void)textFieldDidChange :(UITextField *)theTextField{
    //    NSLog(@"%lu",(unsigned long)[theTextField.text length]);
    //    int x = [theTextField.text characterAtIndex:0];
    //    NSLog(@"ascii : %@ is %d",theTextField.text,x);
    if ([theTextField.text length] > 0) {
        
        ArrayWords = [Vocab listDictByVocab:theTextField.text];
        if ([ArrayWords count] == 0) {
            NSLog(@"search by internet");
        }
        else{
          [TableWords reloadData];
        }
        
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //    NSLog(@"%lu",(unsigned long)range.length);
    
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    return YES;
}


- (NSArray *)rightButtons
{
    //make the button when swipe
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor redColor] title:@"Favorite"];
    
    
    return rightUtilityButtons;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self performSegueWithIdentifier:@"chooseVocab" sender:@"textfield"];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [[self view] endEditing:TRUE];
    UITouch *touch = [[event allTouches] anyObject];
    if ([SearchBox isFirstResponder] && [touch view] != SearchBox) {
        [SearchBox resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

#pragma mark tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.ArrayWords count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"xxx";
    
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
    }
    
    Vocab *info = [ArrayWords objectAtIndex:indexPath.row];
    cell.textLabel.text = info.Search;
    return cell;
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
    return 3;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"chooseVocab" sender:nil];
}

#pragma mark swipeable

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [TableWords indexPathForCell:cell];
    switch (index) {
        case 0:
        {
            //when favorite button is pressed, add to database
            Vocab *info = [ArrayWords objectAtIndex:indexPath.row];
            [self insertFavInDatabase:info];
            [cell hideUtilityButtonsAnimated:YES];
            [SearchBox resignFirstResponder];
            
            break;
        }
        default:
            break;
    }
}


- (void) insertFavInDatabase:(Vocab *) favword;
{
    //int favID = fav;
    Favorite *obj = [[Favorite alloc] init];
    
    if ([obj keepFavorite:favword]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success Favorite Word++" message:@"Added word to your favorite list" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Repeated Favorite Word" message:@"This word has been already added on your favorite list" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"chooseVocab"])
    {
        [SearchBox resignFirstResponder];
        
        DetailVocabViewController *vc = [segue destinationViewController];
         Vocab *choose;
        if (sender  != nil) {
            choose = [[Vocab alloc] initWithLanguage:[Language checkLanguage:SearchBox.text] IDvocab:0 Search:SearchBox.text Entry:nil Cat:nil Synonym:nil Antonym:nil];
        }else{
            choose = [ArrayWords objectAtIndex:[[TableWords indexPathForSelectedRow] row]];
        }
        
        [History keepHistory:choose];
        [vc setChooseVocab:choose];
    }
}


@end
