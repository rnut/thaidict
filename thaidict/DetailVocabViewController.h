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
@interface DetailVocabViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NSMutableArray *TranslateInfo;
    Vocab *ChooseVocab;
    IBOutlet UILabel *SearchLabel;
    IBOutlet UITableView *TranslateTable;
    __weak IBOutlet UIBarButtonItem *otherButton;
    
}

@property(nonatomic,strong)NSMutableArray *ArrayTranslate;
@property(nonatomic,strong)AVAudioPlayer *Player;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;


@property(nonatomic,strong)Vocab *ChooseVocab;
- (IBAction)otherInformation:(id)sender;

-(IBAction)speakSpeech:(id)sender;
@end
