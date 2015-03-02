    //
//  DetailVocabViewController.m
//  thaidict
//
//  Created by Rnut on 1/22/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import "DetailVocab.h"

@interface DetailVocab ()
{
    BOOL flagFav; //yes = not exist , no = exist
    Favorite *objFav;
    UIView *overlayView;
    WYPopoverController* popoverController;
}
@end

@implementation DetailVocab
@synthesize ChooseVocab,Player,speakBtn;

-(void)viewWillAppear:(BOOL)animated{
    [self stateFavoriteButton];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.BaseTableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.IndicatorSpeak setHidden:YES];
    if (ChooseVocab == nil) {
        [self setHiddenInterface:YES];
    }
    else{
        self.SearchLabel.text = [ChooseVocab Search];
        [self setHiddenInterface:NO];
    }
}

-(void)stateFavoriteButton{
            //check concurrnt fav
    if ([Favorite checkFavoriteConcurrent:ChooseVocab]) {
        flagFav = YES;
        [self.FavBtn setImage:[UIImage imageNamed:@"fav_off.png"] forState:UIControlStateNormal];
    }else
    {
        flagFav = NO;
        [self.FavBtn setImage:[UIImage imageNamed:@"fav_on.png"] forState:UIControlStateNormal];
    }

}

-(void)setHiddenInterface:(BOOL)boolean{

    [self.BaseTableview setHidden:boolean];
    [self.speakBtn setHidden:boolean];
    [self.SearchLabel setHidden:boolean];
    [self.FavBtn setHidden:boolean];
    [self.ShareBtn setHidden:boolean];
}
#pragma mark tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;

}
-(CGFloat)tableView: (UITableView*)tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath{
    if (indexPath.section==0) {
        return 343.0f;
    }
    else if (indexPath.section ==1){
        return 106.0f;
    }
    else
        return 160.0f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:{
            CellIdentifier = @"Definition";
            DefinitionCell *cell = (DefinitionCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            cell.chooseVocab = ChooseVocab;
            return cell;
        break;}
        case 1:{
            CellIdentifier = @"Sample";
            SampleCell *cell = (SampleCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.ChooseVocab = ChooseVocab;
            return cell;
            break;
        }
        case 2:{
            CellIdentifier = @"Image";
            ImageCell *cell = (ImageCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.ChooseVocab = ChooseVocab;
            return cell;
            break;
        }
        default:
            return cell;
            break;
    }
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return  @"Definition";
            break;
        case 1:
            return @"Sample";
            break;
        case 2:
            return @"Image";
            break;

        default:
            return @"";
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        SampleCell *cell = (SampleCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell setChooseVocab:ChooseVocab];
//        [self loadExample];
    }
}
#pragma mark Favorite
- (IBAction)favorite:(id)sender {
    //check concurrnt fav
    if ([Favorite checkFavoriteConcurrent:ChooseVocab]) {
        
        objFav = [Favorite favoriteVocab:ChooseVocab];
        flagFav = NO;
        [self.FavBtn setImage:[UIImage imageNamed:@"fav_on.png"] forState:UIControlStateNormal];
    }else
    {
        if (objFav == nil) {
            objFav = [[Favorite alloc] initWithVocab:ChooseVocab FAVID:0];
        }
        [Favorite deleteFavorite:objFav];
        flagFav = NO;
        [self.FavBtn setImage:[UIImage imageNamed:@"fav_off.png"] forState:UIControlStateNormal];
    }
}



#pragma mark External API

- (IBAction)share:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController * fbSheetOBJ = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [fbSheetOBJ setInitialText:@"Post from my iOS application"];
        [fbSheetOBJ addURL:[NSURL URLWithString:@"http://www.weblineindia.com"]];
        [fbSheetOBJ addImage:[UIImage imageNamed:@"my_image_to_share.png"]];
        [self presentViewController:fbSheetOBJ animated:YES completion:Nil];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warningb" message:@"please login facebook in your device" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
    }
}

-(IBAction)speakSpeech:(id)sender{
    [self loadSound];
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



#pragma mark retrun resource
-(void)viewWillDisappear:(BOOL)animated{
    [self deleteSound];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
