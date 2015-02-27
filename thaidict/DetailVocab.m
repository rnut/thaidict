    //
//  DetailVocabViewController.m
//  thaidict
//
//  Created by Rnut on 1/22/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import "DetailVocab.h"

@interface DetailVocab ()
{
    BOOL flagDetail;//yes->search , no ->Ignore
    BOOL flagSample;//yes->search , no ->Ignore
    UIView *overlayView;
    WYPopoverController* popoverController;
}
@end

@implementation DetailVocab


- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;

}
//-(CGFloat)tableView: (UITableView*)tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath{
//    if (indexPath.row==0) {
//        return 343.0f;
//    }
//    else if (indexPath.row ==1){
//        return 106.0f;
//    }
//    else
//        return 160.0f;
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
            CellIdentifier = @"Definition";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            break;
        case 1:
            CellIdentifier = @"Sample";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            break;
        case 2:
            CellIdentifier = @"Image";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            break;
            
        default:
            break;
    }
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return  @"Definition";
            break;
        case 1:
            return @"Sample";
            break;
        case 2:
            return @"Image";
            break;

        default:
            return @"";
            break;
    }
}
#pragma mark retrun resource
-(void)viewWillDisappear:(BOOL)animated{

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
