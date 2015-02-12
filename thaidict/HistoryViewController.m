//
//  HistoryViewController.m
//  thaidict
//
//  Created by Rnut on 2/9/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController
@synthesize hisInfo;
- (void)viewDidLoad {
    [super viewDidLoad];
    [TableView setDataSource:self];
    [TableView setDelegate:self];
    hisInfo = [History listHistory];
    [self setInterface];
    
    for (int i = 0; i<[hisInfo count]; i++) {
        NSLog(@"id : %d ,,,,,search : %@",[[hisInfo objectAtIndex:i] ID_his],[[[hisInfo objectAtIndex:i] Voc] Search]);
    }
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self setHisInfo:[History listHistory]];
    [TableView reloadData];
}
-(void)setInterface{
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:(228/255.0) green:3/255.0 blue:21/255.0 alpha:1.0f]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.tabBarController.tabBar setBarTintColor:[UIColor colorWithRed:(228/255.0) green:3/255.0 blue:21/255.0 alpha:1.0f]];
    [self.tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc]init];
    [refresh addTarget:self
                action:@selector(refreshData:)
      forControlEvents:UIControlEventValueChanged];
    [TableView addSubview:refresh];
}

-(void)refreshData:(UIRefreshControl *)refreshControl{
    hisInfo = [History listHistory];
    [TableView reloadData];
    [refreshControl endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [hisInfo count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    History *obj = [hisInfo objectAtIndex:indexPath.row];
    cell.textLabel.text = [[obj Voc] Search];
    
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
        [History deleteHistory:[hisInfo objectAtIndex:indexPath.row]];
        [hisInfo removeObjectAtIndex:indexPath.row];
        [TableView reloadData];
    }
}

#pragma mark IBAction
- (IBAction)editBtn:(id)sender {

    [History clearHistory];
    [hisInfo removeAllObjects];
    [TableView reloadData];
    NSLog(@"clear");
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
