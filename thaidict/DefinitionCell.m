//
//  DefinitionCell.m
//  thaidict
//
//  Created by Rnut on 2/27/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import "DefinitionCell.h"

@implementation DefinitionCell
@synthesize TableDefinition,chooseVocab,TranslateInfo;

-(void)layoutSubviews
{
//    NSLog(@"test");
//    TranslateInfo = [Vocab translateVocab:chooseVocab];
//    [self.TableDefinition reloadData];
}
- (void)awakeFromNib {
    UITableView *tb =TableDefinition;
    tb.scrollEnabled=YES;
//    Vocab *test = [[Vocab alloc] initWithLanguage:LanguageENG IDvocab:0 Search:@"test" Entry:nil Cat:nil Synonym:nil Antonym:nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    [TableDefinition reloadData];

    // Configure the view for the selected state
}

#pragma mark tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    for (int i = 0; i<[TranslateInfo count]; i++) {
        if (section == i) {
            return [[TranslateInfo objectAtIndex:i] count];
        }
    }
    return 0;
    
}
-(CGFloat)tableView: (UITableView*)tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath{
    Vocab *vTemp = [[TranslateInfo objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *temp =[vTemp Search];
    CGSize size = [temp sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f ]}];
//    CGRect rect = [temp boundingRectWithSize:CGSizeMake(size.width, CGFLOAT_MAX)
//                                              options:NSStringDrawingUsesLineFragmentOrigin
//                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f ]} context:nil];
//    NSLog(@"width : %f",rect.size.width);
//    NSLog(@"height : %f",rect.size.height);
//    NSLog(@"retun : %f",rect.size.height + 20);
    if ([vTemp.Synonym isEqualToString:@""] && [vTemp.Antonym isEqualToString:@""] ) {
        return size.height+40;
    }
    else return size.height + 80;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  [TranslateInfo count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"vocabCell";
    VocabCell *cell = (VocabCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[VocabCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    for (NSInteger i =0; i< [TranslateInfo count]; i++) {
        
        if (indexPath.section == i) {
            NSString *total;
            Vocab *v = [[TranslateInfo objectAtIndex:i] objectAtIndex:indexPath.row];
            cell.Entry.text = [NSString stringWithFormat:@"%@",[v Entry]];

            //entry
            if ([v Entry] == nil || [[v Entry] isEqualToString:@""]) {
                [cell.Entry setHidden:YES];
            }
            else{
                cell.Entry.text = [NSString stringWithFormat:@"%@",[v Entry]];
            }
            
            //synnonym
            if ([v Synonym] == nil || [[v Synonym] isEqualToString:@""]) {
            }
            else{
                total = [NSString stringWithFormat:@"Synonym : %@",[v Synonym]];
            }
            //antonym
            if ([v Antonym] != nil && ![[v Antonym] isEqualToString:@""]) {
                if ([total isEqualToString:@""] || total == nil) {
                    total =[NSString stringWithFormat:@"Antonym : %@",[v Antonym]];
                }
                else{
                    [total stringByAppendingString:[NSString stringWithFormat:@"   Antonym : %@",[v Antonym]]];
                }
                
            }
            
            if (![total isEqualToString:@""]) cell.Syn.text = total;
            else [cell.Syn setHidden:YES];
            
        }
    }
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    for (int i =0; i<[TranslateInfo count]; i++) {
        if (section == i) {
            return [NSString stringWithFormat:@"%@",[[[TranslateInfo objectAtIndex:i] objectAtIndex:0] Cat]];
        }
    }
    return @"";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 30.0f;
    }
    return 20.0f;
}


@end
