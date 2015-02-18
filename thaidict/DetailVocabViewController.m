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
}
@end

@implementation DetailVocabViewController
@synthesize ChooseVocab;
@synthesize Player;
@synthesize pageImages = _pageImages;
@synthesize pageViews = _pageViews;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (ChooseVocab == nil) {
        [self setHiddenInterface:YES];
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
        
        SearchLabel.text = ChooseVocab.Search;
        TranslateInfo = [Vocab translateVocab:ChooseVocab];
        [TranslateTable reloadData];
        if (ChooseVocab.Language == LanguageTHA) {
            if ([TranslateInfo count] > 0) {
                self.SampleLabel.text = [[[TranslateInfo objectAtIndex:0] objectAtIndex:0] Sample];
            }
        }
    }
    
}

-(void)setHiddenInterface:(BOOL)boolean{
    [speakBtn setHidden:boolean];
    [TranslateTable setHidden:boolean];
    [SearchLabel setHidden:boolean];
    [self.SampleLabel setHidden:boolean];
    [self.CollectionImage setHidden:boolean];
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


#pragma mark sound
//- (IBAction)otherInformation:(id)sender {
//    
//    [self.pageControl reloadInputViews];
//    
//    APImage *img = [[APImage alloc] initWithVocabSearch:[ChooseVocab Search] Language:[ChooseVocab Language]];
//    _pageImages = [img Image];
//    NSInteger pageCount = self.pageImages.count;
//    
//    // Set up the page control
//    self.pageControl.currentPage = 0;
//    self.pageControl.numberOfPages = pageCount;
//    
//    // Set up the array to hold the views for each page
//    self.pageViews = [[NSMutableArray alloc] init];
//    for (NSInteger i = 0; i < pageCount; ++i) {
//        [self.pageViews addObject:[NSNull null]];
//    }
//    
//}

-(IBAction)speakSpeech:(id)sender{
    APImage *img = [[APImage alloc] initWithVocabSearch:[ChooseVocab Search] Language:[ChooseVocab Language]];
    _pageImages = [img Image];
    [self.CollectionImage reloadData];
    //load sound
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
        [ChooseVocab loadSound];
        //
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
    //use when go out from this view
    if ([APSpeech deleteSpeech:[ChooseVocab Search]]) {
        NSLog(@"delete success");
    }
    //----
    
    
    //load Sample
    [ChooseVocab loadSampleENG];
    self.SampleLabel.text = [ChooseVocab Sample];
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
