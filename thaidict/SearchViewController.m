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
    NSString *SearchText;
    BOOL flagSearch;
}
@end
NSInteger lastclickrow;
int idrec = 0;

@implementation SearchViewController
@synthesize ArrayWords,SelectedCellText,SearchView;
-(void)viewWillAppear:(BOOL)animated{
    [TableWords reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInterface];

    [TableWords setDelegate:self];
    [TableWords setDataSource:self];
    [SearchBox setDelegate:self];
    SearchText = @"a";
    ArrayWords = [Vocab listDictByVocab:SearchText];
    [TableWords reloadData];
    [self setNeedsStatusBarAppearanceUpdate];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)setInterface{
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
//                                   initWithTarget:self
//                                   action:@selector(dismissKeyboard)];
//    
//    [self.view addGestureRecognizer:tap];
    UIColor *red = [UIColor colorWithRed:(228/255.0) green:3/255.0 blue:21/255.0 alpha:1.0f];
    [self.view.layer setBackgroundColor:[red CGColor]];
    [self.SearchView.layer setBorderWidth:0.0f];
    [self.SearchView.layer setBorderColor:[red CGColor]];
    [self.SearchView setBackgroundColor:red];
    [self.SearchView setClipsToBounds:YES];
}
-(void)dismissKeyboard {
    [SearchBox resignFirstResponder];
}
#pragma mark textfield
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3
                          delay:0
                        options: UIViewAnimationOptionLayoutSubviews
                     animations:^
     {
         [[self navigationController] setNavigationBarHidden:YES animated:YES];
         CGRect frame = self.SearchView.frame;
         frame.origin.y = 0;
         frame.origin.x = 0;
         self.SearchView.frame = frame;
     }
                     completion:^(BOOL finished)
     {
//         NSLog(@"Completed");
         
     }];
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    
    if ([[theTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]  > 0) {
        SearchText = [theTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        ArrayWords = [Vocab listDictByVocab:SearchText];
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
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor whiteColor] icon:[UIImage imageNamed:@"fav_off.png"]];
    
    
    return rightUtilityButtons;
}

- (NSArray *)fav_on
{
    //make the button when swipe
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor whiteColor] icon:[UIImage imageNamed:@"fav_on.png"]];
    
    
    return rightUtilityButtons;
}
- (NSArray *)fav_off
{
    //make the button when swipe
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor whiteColor] icon:[UIImage imageNamed:@"fav_off.png"]];
    
    
    return rightUtilityButtons;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self performSegueWithIdentifier:@"chooseVocab" sender:@"textfield"];
    return YES;
}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//
//    UITouch *touch = [[event allTouches] anyObject];
//    if ([SearchBox isFirstResponder] && [touch view] != SearchBox) {
//        [SearchBox resignFirstResponder];
//    }
//    [super touchesBegan:touches withEvent:event];
//}

#pragma mark tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.ArrayWords count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"xxx";
    
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    if (indexPath.row == [ArrayWords count] -1) {
        NSArray *temp = [Vocab listDictByVocab:SearchText ByIndex:(int)indexPath.row+1];
        for (Vocab *v in temp) {
            [ArrayWords addObject:v];
            [tableView reloadData];
        }
    }
    cell.delegate = self;
    Vocab *info = [ArrayWords objectAtIndex:indexPath.row];
    cell.textLabel.text = info.Search;
    if ([Favorite checkFavoriteConcurrent:[ArrayWords objectAtIndex:indexPath.row]]) {
        cell.rightUtilityButtons = [self fav_off];
    }else cell.rightUtilityButtons = [self fav_on];
    
    
    return cell;
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
    return 3;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"chooseVocab" sender:nil];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [SearchBox resignFirstResponder];
}
#pragma mark swipeable

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [TableWords indexPathForCell:cell];
    Vocab *info = [ArrayWords objectAtIndex:indexPath.row];
    if ([Favorite checkFavoriteConcurrent:info]) {
        [self insertFavInDatabase:info];

    }
    else{
        Favorite *obf = [[Favorite alloc] init];
        [obf setFav_vocab:info];
        [Favorite deleteFavorite:obf];
    }
        
        [cell hideUtilityButtonsAnimated:YES];
    [TableWords reloadData];
    [SearchBox resignFirstResponder];
//    switch (index) {
//        case 0:
//        {
//            //when favorite button is pressed, add to database
//            Vocab *info = [ArrayWords objectAtIndex:indexPath.row];
//            [self insertFavInDatabase:info];
//            [cell hideUtilityButtonsAnimated:YES];
//            [TableWords reloadData];
//            [SearchBox resignFirstResponder];
//            break;
//        }
//        default:
//            break;
//    }

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

#pragma mark view Disappear
-(void)viewWillDisappear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
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
        [vc setChooseVocab:choose];
    }
}


@end
