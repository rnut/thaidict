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
#import "VocabCell.h"

@interface DetailVocabViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate> //
{
    NSMutableArray *TranslateInfo;
    Vocab *ChooseVocab;
    IBOutlet UILabel *SearchLabel;
    IBOutlet UITableView *TranslateTable;
    IBOutlet UIButton *speakBtn;
    
}

@property(nonatomic,strong)NSMutableArray *ArrayTranslate;
@property(nonatomic,strong)AVAudioPlayer *Player;
@property (nonatomic, strong) NSArray *pageImages;
@property (strong, nonatomic) IBOutlet UILabel *SampleLabel;
@property (strong, nonatomic) IBOutlet UIView *ExapmpleView;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *exmapleIndi;

@property (strong, nonatomic) IBOutlet UICollectionView *CollectionImage;
@property(nonatomic,strong)Vocab *ChooseVocab;
//- (IBAction)otherInformation:(id)sender;

-(IBAction)speakSpeech:(id)sender;
@end
