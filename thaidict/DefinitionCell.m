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

}
- (void)awakeFromNib {
    UITableView *tb =TableDefinition;
    tb.scrollEnabled=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self.Webview loadHTMLString:[self genHtmlString] baseURL:nil];
//    [TableDefinition reloadData];

}
-(NSString *)genHtmlString{
    [self translateVocab];
    
    NSString *ret;
//    if ([self.TranslateInfo count] > 0) {
//        ret = @"<html><table><tr><td>TESTTTTTT HTML </td></tr></table></html>";
//    }
//    NSError *error;line-height:100px
    ret = @"<html><head><style>body{width:100%; margin : 0 ; padding : 0;} table{width : 100%; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;} .entry{width:100%;color:#000;font-size:17px;} .category{font-size:11px; color:#006600; padding: 15px 0 10px 0 ;}.circle{width:15px;height:15px;border-radius:50px;font-size:11px;color:#fff;;text-align:center;background:#FF6666} .synnonym{width:70px;height:15px;border-radius:50px;font-size:11px;color:#fff;;text-align:center;background:#339900} .antonym{width:70px;height:15px;border-radius:50px;font-size:11px;color:#fff;;text-align:center;background:#CC0000}</style></head><body><table border='0'>";
//    for (int i = 0; i<[self.TranslateInfo count]; i++) {
    for (int i = 0; i<[TranslateInfo count]; i++) {
        ret = [ret stringByAppendingString:[NSString stringWithFormat:@"<tr><td colspan='' class='category'>%@</td></tr>",[[[TranslateInfo objectAtIndex:i] objectAtIndex:0] Cat]]];
        for (int j=0; j<[[TranslateInfo objectAtIndex:i] count]; j++) {
            Vocab *v = [[TranslateInfo objectAtIndex:i] objectAtIndex:j];
            ret = [ret stringByAppendingString:@"<tr>"];
            ret = [ret stringByAppendingString:[NSString stringWithFormat:@"<td align='right'><div class='circle'>%d</div></td>",j+1]];
            ret = [ret stringByAppendingString:[NSString stringWithFormat:@"<td class='entry'>%@</td>",v.Entry]];
            ret = [ret stringByAppendingString:@"</tr>"];
            if (![v.Synonym isEqualToString:@""] && v.Synonym != nil) {
                    ret = [ret stringByAppendingString:[NSString stringWithFormat:@"<tr><td><div class='synnonym'>synnonym</div></td><td>%@</td></tr>",v.Synonym]];
            }
            if (![v.Antonym isEqualToString:@""] && v.Antonym != nil) {
                ret = [ret stringByAppendingString:[NSString stringWithFormat:@"<tr><td><div class='antonym'>antonym</div></td><td>%@</td></tr>",v.Antonym]];
            }
        }
    
    }
    //<tr><td></td></tr><tr><td>ทดสอบความหมาย</td></tr><tr><td>synnonym</td></tr><tr><td>antonym</td></tr>
    ret = [ret stringByAppendingString:@"</table></body></html>"];
    return ret;
}
-(BOOL)translateVocab{
    TranslateInfo = [Vocab translateVocab:chooseVocab];
    return NO;
}
#pragma mark tableview
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    
//    for (int i = 0; i<[TranslateInfo count]; i++) {
//        if (section == i) {
//            return [[TranslateInfo objectAtIndex:i] count];
//        }
//    }
//    return 0;
//    
//}
//-(CGFloat)tableView: (UITableView*)tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath{
//    Vocab *vTemp = [[TranslateInfo objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//    NSString *temp =[vTemp Search];
//    CGSize size = [temp sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f ]}];
////    CGRect rect = [temp boundingRectWithSize:CGSizeMake(size.width, CGFLOAT_MAX)
////                                              options:NSStringDrawingUsesLineFragmentOrigin
////                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f ]} context:nil];
////    NSLog(@"width : %f",rect.size.width);
////    NSLog(@"height : %f",rect.size.height);
////    NSLog(@"retun : %f",rect.size.height + 20);
//    if ([vTemp.Synonym isEqualToString:@""] && [vTemp.Antonym isEqualToString:@""] ) {
//        return size.height+40;
//    }
//    else return size.height + 80;
//    
//}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return  [TranslateInfo count];
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *CellIdentifier = @"vocabCell";
//    VocabCell *cell = (VocabCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if(cell == nil){
//        cell = [[VocabCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        
//    }
//    for (NSInteger i =0; i< [TranslateInfo count]; i++) {
//        
//        if (indexPath.section == i) {
//            NSString *total;
//            Vocab *v = [[TranslateInfo objectAtIndex:i] objectAtIndex:indexPath.row];
//            cell.Entry.text = [NSString stringWithFormat:@"%@",[v Entry]];
//
//            //entry
//            if ([v Entry] == nil || [[v Entry] isEqualToString:@""]) {
//                [cell.Entry setHidden:YES];
//            }
//            else{
//                cell.Entry.text = [NSString stringWithFormat:@"%@",[v Entry]];
//            }
//            
//            //synnonym
//            if ([v Synonym] == nil || [[v Synonym] isEqualToString:@""]) {
//            }
//            else{
//                total = [NSString stringWithFormat:@"Synonym : %@",[v Synonym]];
//            }
//            //antonym
//            if ([v Antonym] != nil && ![[v Antonym] isEqualToString:@""]) {
//                if ([total isEqualToString:@""] || total == nil) {
//                    total =[NSString stringWithFormat:@"Antonym : %@",[v Antonym]];
//                }
//                else{
//                    [total stringByAppendingString:[NSString stringWithFormat:@"   Antonym : %@",[v Antonym]]];
//                }
//                
//            }
//            
//            if (![total isEqualToString:@""]) cell.Syn.text = total;
//            else [cell.Syn setHidden:YES];
//            
//        }
//    }
//    return cell;
//}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    for (int i =0; i<[TranslateInfo count]; i++) {
//        if (section == i) {
//            return [NSString stringWithFormat:@"%@",[[[TranslateInfo objectAtIndex:i] objectAtIndex:0] Cat]];
//        }
//    }
//    return @"";
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return 30.0f;
//    }
//    return 20.0f;
//}


@end
