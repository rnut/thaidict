//
//  MoreViewController.m
//  thaidict
//
//  Created by Rnut on 3/10/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.Tableview deselectRowAtIndexPath:[self.Tableview indexPathForSelectedRow] animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID;
    switch (indexPath.row) {
        case 0:
            cellID = @"feedback";
            break;
            
        default:
            cellID = @"about";
            break;
    }
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    UIView *select = [[UIView alloc] init];
    [select setBackgroundColor:[UIColor redColor]];
    cell.selectedBackgroundView = select;
    cell.textLabel.textColor = [UIColor blackColor];
//    cell.backgroundColor = [UIColor redColor];
    cell.textLabel.text = cellID;
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0f;
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
////    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
////    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
////    if ([cell.textLabel.text isEqualToString:@"feedback"]) {
////        [self performSegueWithIdentifier:@"feedback" sender:nil];
////    }
////    else if ([cell.textLabel.text isEqualToString:@"about"]){
////        [self performSegueWithIdentifier:@"about" sender:nil];
////    }
//}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor blackColor];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"feedback"]) {
        
    }
    else if ([[segue identifier] isEqualToString:@"about"]){
        
    }
}

@end
