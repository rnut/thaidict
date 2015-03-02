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
#import "APSpeech.h"
#import "APSample.h"
#import "DefinitionCell.h"
#import "SampleCell.h"
#import "ImageCell.h"
#import "PopOverDetail.h"
#import "WYPopoverController.h"
#import <Social/Social.h>
#import "Favorite.h"
@interface DetailVocab : UIViewController<UITableViewDataSource,UITableViewDelegate>
{

}


@property(nonatomic,strong)AVAudioPlayer *Player;


@property(nonatomic,strong)Vocab *ChooseVocab;


@property (strong, nonatomic) IBOutlet UITableView *BaseTableview;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *IndicatorSpeak;
@property (strong, nonatomic) IBOutlet UIButton *speakBtn;
@property (strong, nonatomic) IBOutlet UILabel *SearchLabel;
@property (strong, nonatomic) IBOutlet UIButton *FavBtn;
@property (strong, nonatomic) IBOutlet UIButton *ShareBtn;



- (IBAction)favorite:(id)sender;
- (IBAction)share:(id)sender;
-(IBAction)speakSpeech:(id)sender;
@end
