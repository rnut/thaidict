//
//  DetailVocabViewController.h
//  thaidict
//
//  Created by Rnut on 1/22/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vocab.h"
#import "APImage.h"
#import "DefinitionCell.h"
#import "SampleCell.h"
#import "ImageCell.h"
#import "PopOverDetail.h"
#import "WYPopoverController.h"
@interface DetailVocab : UIViewController<UITableViewDataSource,UITableViewDelegate>
{

}

@property (strong, nonatomic) IBOutlet UITableView *BaseTableview;

@property(nonatomic,strong)Vocab *ChooseVocab;
//- (IBAction)otherInformation:(id)sender;

-(IBAction)speakSpeech:(id)sender;
@end
