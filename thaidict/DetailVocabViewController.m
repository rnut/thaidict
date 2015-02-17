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
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize pageImages = _pageImages;
@synthesize pageViews = _pageViews;

- (void)viewDidLoad {
    [super viewDidLoad];
    [TranslateTable setDataSource:self];
    [TranslateTable setDelegate:self];
    [TranslateTable reloadData];
    [TranslateTable setHidden:YES];
    
    
    if (ChooseVocab != nil) {
        [TranslateTable setHidden:NO];
        SearchLabel.text = ChooseVocab.Search;
        TranslateInfo = [Vocab translateVocab:ChooseVocab];
        [TranslateTable reloadData];
    }


    //loadSample phrase
//    [ChooseVocab loadSampleENG];
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


#pragma mark scrollview
- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;
    
    // Work out which pages we want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
        [self purgePage:i];
    }
}

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Load an individual page, first seeing if we've already loaded it
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        [self.scrollView addSubview:newPageView];
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Set up the content size of the scroll view
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
    
    // Load the initial set of pages that are on screen
    [self loadVisiblePages];
}


#pragma mark sound
- (IBAction)otherInformation:(id)sender {
    
    [self.pageControl reloadInputViews];
    
    APImage *img = [[APImage alloc] initWithVocabSearch:[ChooseVocab Search] Language:[ChooseVocab Language]];
    _pageImages = [img Image];
    NSInteger pageCount = self.pageImages.count;
    
    // Set up the page control
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageCount;
    
    // Set up the array to hold the views for each page
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }
    
}

-(IBAction)speakSpeech:(id)sender{
    
    
    //load image
    [self.pageControl reloadInputViews];
    
    APImage *img = [[APImage alloc] initWithVocabSearch:[ChooseVocab Search] Language:[ChooseVocab Language]];
    _pageImages = [img Image];
    NSInteger pageCount = self.pageImages.count;
    
    // Set up the page control
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageCount;
    
    // Set up the array to hold the views for each page
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }
    [self loadVisiblePages];
    
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
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
