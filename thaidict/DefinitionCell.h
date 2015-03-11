//
//  DefinitionCell.h
//  thaidict
//
//  Created by Rnut on 2/27/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VocabCell.h"
#import "Vocab.h"
#import "History.h"

@interface DefinitionCell : UITableViewCell//<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property(nonatomic,assign)BOOL Source; //yes = internal , no = external
@property(nonatomic,strong)IBOutlet UITableView *TableDefinition;
@property(strong,nonatomic)Vocab *chooseVocab;
@property (strong, nonatomic) IBOutlet UIWebView *Webview;
@property(nonatomic,strong)NSMutableArray *TranslateInfo;
@end
