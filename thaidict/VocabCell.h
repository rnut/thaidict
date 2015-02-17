//
//  VocabCell.h
//  thaidict
//
//  Created by Rnut on 2/17/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VocabCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *Entry;
@property (strong, nonatomic) IBOutlet UILabel *Syn;
@property (strong, nonatomic) IBOutlet UILabel *Ant;


@end
