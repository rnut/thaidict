    //
//  DetailVocabViewController.m
//  thaidict
//
//  Created by Rnut on 1/22/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import "DetailVocabViewController.h"

@interface DetailVocabViewController ()
{
    BOOL flagDetail;//yes->search , no ->Ignore
    BOOL flagSample;//yes->search , no ->Ignore
    UIView *overlayView;
}
@end

@implementation DetailVocabViewController
@synthesize ChooseVocab;
@synthesize Player;
@synthesize pageImages = _pageImages;

- (void)viewDidLoad {
    [super viewDidLoad];
    flagDetail = YES;
    flagSample = YES;
    if (ChooseVocab == nil) {
        [self setHiddenInterface:YES];
    }
    else{
        SearchLabel.text = ChooseVocab.Search;
        TranslateInfo = [Vocab translateVocab:ChooseVocab];
        if (TranslateInfo.count == 0) {
            [self setHiddenInterface:YES];
            
            //ทำ dispatch
            
            TranslateInfo = [Vocab translateByExternal:ChooseVocab];
            if (TranslateInfo.count > 0) {
                [self setHiddenInterface:NO];
                //set delegate
                [TranslateTable setDataSource:self];
                [TranslateTable setDelegate:self];
                [self.CollectionImage setDelegate:self];
                [self.CollectionImage setDataSource:self];
                ((UICollectionViewFlowLayout *)self.CollectionImage.collectionViewLayout).minimumLineSpacing = 2.0f;
                ((UICollectionViewFlowLayout *)self.CollectionImage.collectionViewLayout).scrollDirection = UICollectionViewScrollDirectionHorizontal;
                [TranslateTable reloadData];
            }
            else{
                [SearchLabel setHidden:NO];
                [SearchLabel setText:@"Word Not Found"];
            }
        }
        else{
            [self setHiddenInterface:NO];
            //set delegate
            [TranslateTable setDataSource:self];
            [TranslateTable setDelegate:self];
            [self.CollectionImage setDelegate:self];
            [self.CollectionImage setDataSource:self];
            ((UICollectionViewFlowLayout *)self.CollectionImage.collectionViewLayout).minimumLineSpacing = 2.0f;
            ((UICollectionViewFlowLayout *)self.CollectionImage.collectionViewLayout).scrollDirection = UICollectionViewScrollDirectionHorizontal;
            [TranslateTable reloadData];
            

        }
        if (ChooseVocab.Language == LanguageTHA) {
            if (TranslateInfo.count > 0) {
                for (int i =0; i<[TranslateInfo count]; i++) {
                    if ([[[TranslateInfo objectAtIndex:0] objectAtIndex:i] Sample] != nil) {
                        self.SampleLabel.text = [[[TranslateInfo objectAtIndex:0] objectAtIndex:i] Sample];
                        flagSample = NO;
                        break;
                    }
                }
                
            }
        }
    }
    
    
    //add touch gesture
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.ExapmpleView addGestureRecognizer:singleFingerTap];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"tap exampleview");
    if (flagDetail) {
        [self addOverlayAndIndicator];
        [self.IndicatorImage setHidden:NO];
        [self.IndicatorImage startAnimating];
        dispatch_queue_t externalque = dispatch_queue_create("getInformation", nil);
        
        dispatch_async(externalque, ^{
            [self loadExample];
            APImage *img = [[APImage alloc] initWithVocabSearch:[ChooseVocab Search] Language:[ChooseVocab Language]];
            _pageImages = [img Image];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.CollectionImage reloadData];
                [self.IndicatorImage stopAnimating];
            });
        });
        flagDetail= NO;
    }
    
    
    
//    [self loadImage];
//    [UIView animateWithDuration:2.0 animations:^{
//        self.ExapmpleView.layer.backgroundColor = [UIColor greenColor].CGColor;
//    }completion:^(BOOL finished){}];
    
}

-(void)setHiddenInterface:(BOOL)boolean{
    [speakBtn setHidden:boolean];
    [TranslateTable setHidden:boolean];
    [SearchLabel setHidden:boolean];
}

-(void)setHiddenExternalInfoInterface:(BOOL)boolean{
    [self.ExapmpleView setHidden:boolean];
    [self.SampleLabel setHidden:boolean];
    [self.CollectionImage setHidden:boolean];
    [self.exmapleIndi setHidden:boolean];
    [self.IndicatorSpeak setHidden:boolean];
    [self.IndicatorImage setHidden:boolean];
}

#pragma mark Overlay
-(void)addOverlayAndIndicator{
    [self.exmapleIndi startAnimating];
    overlayView = [[UIView alloc] initWithFrame:[self.ExapmpleView bounds]];
    overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.ExapmpleView addSubview:overlayView];
}
-(void)removeOverlayAndIndicator{
    [self.exmapleIndi stopAnimating];
    [overlayView removeFromSuperview];
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

    return 70.0f;
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


#pragma mark External API
-(IBAction)speakSpeech:(id)sender{
    [self loadSound];
}
-(void)loadImage{
     APImage *img = [[APImage alloc] initWithVocabSearch:[ChooseVocab Search] Language:[ChooseVocab Language]];
    _pageImages = [img Image];
    [self.CollectionImage reloadData];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
//       
//       
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (img.Image.count > 0) {
//                
//            }
//            
//            
//        });
//    });
    
    
    
}
-(void)loadExample{

    dispatch_queue_t exQueue_ = dispatch_queue_create("exampleque", NULL);
    dispatch_async(exQueue_, ^{

        [ChooseVocab loadSampleENG];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[ChooseVocab Sample] isEqualToString:@""] || [ChooseVocab Sample] == nil) {
                self.SampleLabel.text = @"not found example";
                [self removeOverlayAndIndicator];
                flagSample = NO;
            }
            else{
                self.SampleLabel.text = [ChooseVocab Sample];
                [self removeOverlayAndIndicator];
                flagSample = NO;
            }
        });
    });
    
    
//    [ChooseVocab loadSampleENG];
//    self.SampleLabel.text = [ChooseVocab Sample];
}
-(void)loadSound{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",[ChooseVocab Search]]];
    NSLog(@"%@",path);
    NSError *err;
    if ( [[NSFileManager defaultManager] fileExistsAtPath:path] )
    {
        if ( Player && [Player isPlaying] ) {
            [Player stop];
            Player = nil;
        }
        
        Player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&err];
        Player.volume =2.0f;
        [Player prepareToPlay];
        [Player setNumberOfLoops:0];
        [Player play];
    }
    else{
        // load sound
        [speakBtn setHidden:YES];
        [self.IndicatorSpeak setHidden:NO];
        [self.IndicatorSpeak startAnimating];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul), ^{
            BOOL flag = [ChooseVocab loadSound];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (flag) {
                    if ( Player && [Player isPlaying] ) {
                        [Player stop];
                        Player = nil;
                    }
                    
                    Player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
                    Player.volume =2.0f;
                    [Player prepareToPlay];
                    [Player setNumberOfLoops:0];
                    [Player play];
                    [self.IndicatorSpeak stopAnimating];
                    [speakBtn setHidden:NO];
                }
            });
        });

        
    }
}

-(void)deleteSound{
    if ([APSpeech deleteSpeech:[ChooseVocab Search]]) {
        NSLog(@"delete success");
    }
}

#pragma mark collectionview
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.CollectionImage)return [self.pageImages count];
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.CollectionImage){
        static NSString *identifier = @"Cell";
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        UIImageView *IMG = (UIImageView *)[cell viewWithTag:100];
        IMG.image = [self.pageImages objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
}


#pragma mark retrun resource
-(void)viewWillDisappear:(BOOL)animated{
    [self deleteSound];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
