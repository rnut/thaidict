//
//  DetailVocabViewController.m
//  thaidict
//
//  Created by Rnut on 1/22/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import "DetailVocabViewController.h"

@interface DetailVocabViewController ()

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
    

    SearchLabel.text = ChooseVocab.Search;
    TranslateInfo = [Vocab translateVocab:ChooseVocab];

    [TranslateTable setDataSource:self];
    [TranslateTable setDataSource:self];
    [TranslateTable reloadData];
    
    //keep history
    [History keepHistory:ChooseVocab];
}


#pragma mark tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    NSArray *rowIn = [self countRowInSection];
////    NSLog(@"section : %ld",section);
//    for (int i =0; i<[rowIn count]; i++) {
//        if (section == i) {
//            NSLog(@"%d",[[rowIn objectAtIndex:i] intValue]);
//            return [[rowIn objectAtIndex:i] intValue];
//        }
//    }
//    return 0;
    for (int i = 0; i<[TranslateInfo count]; i++) {
        if (section == i) {
//            NSLog(@"numinSec : %lu",(unsigned long)[[TranslateInfo objectAtIndex:i] count]);
//            NSLog(@"numsec : %lu",(unsigned long)[[TranslateInfo objectAtIndex:i] count]);
            return [[TranslateInfo objectAtIndex:i] count];
        }
    }
    return 0;
    
    
//    int i = 0;
//    for (NSArray *arr in TranslateInfo) {
//        if (section == i) {
//            return [arr count];
//        }
//        
//    }
//    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    NSLog(@"%lu",(unsigned long)[TranslateInfo count]);
    return  [TranslateInfo count];
//        return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"vocabCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
//    NSMutableArray *CountRowIn = [self countRowInSection];
//    NSInteger CountSection = [self countSection];
    for (NSInteger i =0; i< [TranslateInfo count]; i++) {
        
        if (indexPath.section == i) {
            Vocab *v = [[TranslateInfo objectAtIndex:i] objectAtIndex:indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"cell : %@   section : %ld",[v Entry],(long)i];
            }
    }
    
    
//    int start = 0;
//    int end = 0;
//    NSMutableArray *CountRowIn = [self countRowInSection];
//    for (int i =0; i<[self countSection]; i++) {
//        end = end + [[CountRowIn objectAtIndex:i] intValue];
//        if (indexPath.section == i) {
////            cell.textLabel.text = [NSString stringWithFormat:@"xxx section : %d",i];
//            for (int j= start; j<end; j++) {
//                NSLog(@"start:%d",start);
//                NSLog(@"entry : %@",[[TranslateInfo objectAtIndex:j] Entry]);
//                cell.textLabel.text = [[TranslateInfo objectAtIndex:j] Entry];
//            }
//            start = end;
//            
//        }
//    }

    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    for (int i =0; i<[TranslateInfo count]; i++) {
        if (section == i) {
            return [NSString stringWithFormat:@"section : %@",[[[TranslateInfo objectAtIndex:i] objectAtIndex:0] Cat]];
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
