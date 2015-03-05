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
@interface DefinitionCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
{
   
}
@property(nonatomic,strong)IBOutlet UITableView *TableDefinition;
@property(strong,nonatomic)Vocab *chooseVocab;
@property(nonatomic,strong)NSMutableArray *TranslateInfo;
@end
