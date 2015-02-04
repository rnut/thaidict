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
    
    [TableWords setRowHeight:44];
    
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[self view] endEditing:TRUE];
    
}

//
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
//    NSLog(@"%lu",(unsigned long)range.length);
    
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    return YES;
}

-(void)textFieldDidChange :(UITextField *)theTextField{
//    NSLog(@"%lu",(unsigned long)[theTextField.text length]);
//    int x = [theTextField.text characterAtIndex:0];
//    NSLog(@"ascii : %@ is %d",theTextField.text,x);
    if ([theTextField.text length] > 0) {
        ArrayWords = [Vocab listDictByVocab:theTextField.text];
        [TableWords reloadData];
    }
    
}

- (NSArray *)rightButtons
{
    //make the button when swipe
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor redColor] title:@"Favorite"];
    
    
    return rightUtilityButtons;
}


- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
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
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//}

//- (NSMutableArray *)findWordInfos: (NSString *) str
//{
//    //to look up the string user typed in database
//    NSMutableArray *retrieval = [[NSMutableArray alloc] init];
//    DB *db = [[DB alloc ]init];
//    if ([str length] == 0) {
//        str = @"a";
//    }
//    if([WordInfo checkLanguage:str] == 0)
//    {
//        NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM th2eng_%@ WHERE tsearch like '%@%%' GROUP BY tsearch ORDER BY tsearch", [str substringToIndex:1], str];
//        
//        [db queryWithString:strQuery];
//        while([db.ObjResult next]) {
//            WordInfo *temp = [[WordInfo alloc] initWithUniqueId:LanguageTHA uniqueId:[db.ObjResult intForColumn:@"id"] esearch:[db.ObjResult stringForColumn:@"tsearch"] eentry:[db.ObjResult stringForColumn:@"tentry"] tentry:[db.ObjResult stringForColumn:@"eentry"] ecat:[db.ObjResult stringForColumn:@"tcat"] ethai:[db.ObjResult stringForColumn:@"tenglish"] esyn:[db.ObjResult stringForColumn:@"tsyn"] eant:[db.ObjResult stringForColumn:@"tant"]];
//            [retrieval addObject:temp];
//        }
//        [db closeDB];
//    }
//    else
//    {
//        NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM eng2th_%@ WHERE esearch like '%@%%' GROUP BY esearch ORDER BY LOWER(esearch), esearch", [[str substringToIndex:1] capitalizedString], str];
//        
//        [db queryWithString:strQuery];
//        while([db.ObjResult next]) {
//            WordInfo *temp = [[WordInfo alloc] initWithUniqueId:LanguageENG uniqueId:[db.ObjResult intForColumn:@"id"] esearch:[db.ObjResult stringForColumn:@"esearch"] eentry:[db.ObjResult stringForColumn:@"eentry"] tentry:[db.ObjResult stringForColumn:@"tentry"] ecat:[db.ObjResult stringForColumn:@"ecat"] ethai:[db.ObjResult stringForColumn:@"ethai"] esyn:[db.ObjResult stringForColumn:@"esyn"] eant:[db.ObjResult stringForColumn:@"eant"]];
//            [retrieval addObject:temp];
//        }
//        [db closeDB];
//    }
//    
//    return retrieval;
//}

- (void) insertFavInDatabase:(Vocab *) favword;
{
    //int favID = fav;
    if ([Favorite checkExistanceOfFavWord:favword.Search] == FALSE) {
        Favorite *Added = [[Favorite alloc] initWithVocab:favword];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Repeated Favorite Word" message:@"This word has been already added on your favorite list" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
    
}
-(int)getIDLastRecord
{
    //    select id_fav from fav ORDER by id_fav desc LIMIT 1
    DB *db = [[DB alloc] init];
    [db queryWithString:@"select id_fav from fav ORDER by id_fav desc LIMIT 1"];
    while([db.ObjResult next]) {
        idrec =  [db.ObjResult intForColumn:@"id_fav"];
    }
    [db closeDB];
    return idrec;
    
    
}
//


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"ChooseVocab" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ChooseVocab"])
    {
        // Get reference to the destination view controller
        DetailVocabViewController *vc = [segue destinationViewController];
        Vocab *choose = [ArrayWords objectAtIndex:[[TableWords indexPathForSelectedRow] row]];
        // Pass any objects to the view controller here, like...
        [vc setChooseVocab:choose];
    }
}


@end
