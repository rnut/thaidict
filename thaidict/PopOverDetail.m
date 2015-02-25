//
//  PopOverDetail.m
//  thaidict
//
//  Created by Rnut on 2/25/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import "PopOverDetail.h"

@interface PopOverDetail ()

@end

@implementation PopOverDetail

- (void)viewDidLoad {
    [super viewDidLoad];

    shareSource = [[NSMutableArray alloc] initWithObjects:@"Favorite",@"Facebook", nil];
    
    [self.Tableview reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [shareSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    cell.imageView.image = [UIImage imageNamed:@"no.png"];
    cell.textLabel.text = [shareSource objectAtIndex:indexPath.row];
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Share this vocab to..";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.0f;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
