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
    BOOL flagtranslate; //yes = internal , no = external;
    CGFloat definitionHeight;
}
@end

@implementation DetailVocab
@synthesize ChooseVocab,Player,speakBtn,TranslateInfo;

-(void)viewWillAppear:(BOOL)animated{
    [self setNeedsStatusBarAppearanceUpdate];
    flagtranslate = [self translateVocab];
    [self stateFavoriteButton];
    definitionHeight = [self checklengthOfcharecter];
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
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.BaseTableview.frame.origin.y, self.view.bounds.size.width, 3)];
        lineView2.backgroundColor = [UIColor blackColor];
        [self.view addSubview:lineView2];
    }
}
-(BOOL)translateVocab{
    if (ChooseVocab != nil && ![ChooseVocab.Search isEqualToString:@""]) {
        TranslateInfo = [Vocab translateVocab:ChooseVocab];
        if (TranslateInfo.count > 0) {
            return YES;
        }
        else{
            TranslateInfo = [Vocab translateByExternal:ChooseVocab];
            return  NO;
        }
    }
    
    return nil;
}

-(void)stateFavoriteButton{
            //check concurrnt fav
    if (TranslateInfo.count > 0) {
        Vocab * v = [[TranslateInfo objectAtIndex:0] objectAtIndex:0];
        if (v!= nil) {
            if ([Favorite checkFavoriteConcurrent:v]) {
                flagFav = YES;
                [self.FavBtn setImage:[UIImage imageNamed:@"fav_off.png"] forState:UIControlStateNormal];
            }else
            {
                flagFav = NO;
                [self.FavBtn setImage:[UIImage imageNamed:@"fav_on.png"] forState:UIControlStateNormal];
            }
        }
    }
    

}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
            cell.TranslateInfo = TranslateInfo;
            cell.Source = flagtranslate;
            return cell;
        break;}
        case 1:{
            CellIdentifier = @"Sample";
            SampleCell *cell = (SampleCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            
            if (ChooseVocab.Language == LanguageTHA) {
                if (TranslateInfo.count > 0) {
                    for (int i =0; i<[TranslateInfo count]; i++) {
                        if ([[[TranslateInfo objectAtIndex:0] objectAtIndex:i] Sample] != nil) {
                            cell.Example.text = [[[TranslateInfo objectAtIndex:0] objectAtIndex:i] Sample];
                            cell.ChooseVocab =[[TranslateInfo objectAtIndex:0] objectAtIndex:i];
                            cell.flagSample = NO;
                            break;
                        }
                    }
                    
                }
            }
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

-(CGFloat)checklengthOfcharecter{
    unsigned long length = 0;
    int line = 0;
    for (NSArray *arr in TranslateInfo) {
        line++;
        for (Vocab *v in arr) {
            if (![v.Antonym isEqualToString:@""] || ![v.Synonym isEqualToString:@""]){
                if (v.Entry.length > 28) {
                    line++;
                }
                if (![v.Synonym isEqualToString:@""]) {
                    line++;
                    if (v.Synonym.length > 34) {
                        line++;
                    }
                }
                if (![v.Antonym isEqualToString:@""]) {
                    line++;
                    if (v.Antonym.length > 34) {
                        line++;
                    }
                }
                
            }
            else{
                if (v.Entry.length > 110) {
                    line = line+2;
                }
                else if (v.Entry.length > 45) {
                    line++;
                }
                if (![v.Synonym isEqualToString:@""]) {
                    line++;
                    if (v.Synonym.length > 44) {
                        line++;
                    }
                }
                if (![v.Antonym isEqualToString:@""]) {
                    line++;
                    if (v.Antonym.length > 44) {
                        line++;
                    }
                }
                
            }
            line++;

        }
    }
    NSLog(@"line : %d",line);
    NSLog(@"check : %lu",length);
    
    if (line >= 9  )return 343.0f;
    else if(line >=8)return 316.0f;
    else if ( line>=7)return 289.0f;
    else if(line >=6)return 252.0f;
    else if (line >=5) return 210.0f;
    else if(line >=4)return 180.0f;
    else if(line >=3)return 150.0f;
    else if(line >=2)return 120.0f;
    else if(line >=1)return 100.0f;
    else return 100.0f;
}


-(CGFloat)tableView: (UITableView*)tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath{
    if (indexPath.section==0) {
        if (definitionHeight != 0) return definitionHeight;
        else return 100.0f;
    }
    else if (indexPath.section ==1){
        return 106.0f;
    }
    else
        return 160.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 16;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section== 0) {
        return 40;
    }
    return 30 ;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    [view setBackgroundColor:[UIColor colorWithRed:0.906 green:0.906 blue:0.906 alpha:1]]; //your background color...
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    UILabel *label;
    UIView *lineView;
    lineView = [[UIView alloc] initWithFrame:CGRectMake(10, view.frame.origin.y+30, self.view.bounds.size.width, 1)];
    label = [[UILabel alloc] initWithFrame:CGRectMake(15,10 , tableView.frame.size.width, 17)];
    
    switch (section) {
            
        case 0:
        {
            title =   [NSString stringWithFormat:@"Definition"];
            label = [[UILabel alloc] initWithFrame:CGRectMake(15,20 , tableView.frame.size.width, 17)];
            lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 40, self.view.bounds.size.width, 1)];
            break;
        }
        case 1:
            title =    @"Sample";
            break;
        case 2:
            title =    @"Image";
            break;
            
        default:
            title =    @"";
            break;
    }
    [label setFont:[UIFont fontWithName:@"Helvetica neue" size:14]];
    [label setText:title];
    [label setTextColor:[UIColor colorWithRed:0.345 green:0.345 blue:0.345 alpha:1]];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor whiteColor]];
    //line view
    lineView.backgroundColor = [UIColor grayColor];
    [view addSubview:lineView];
    return view;
}


#pragma mark Favorite
- (IBAction)favorite:(id)sender {
    //check concurrnt fav
    if (TranslateInfo.count > 0) {
        Vocab * v = [[TranslateInfo objectAtIndex:0] objectAtIndex:0];
        if (v!= nil) {
            if ([Favorite checkFavoriteConcurrent:v]) {
                
                objFav = [Favorite favoriteVocab:v];
                flagFav = NO;
                [self.FavBtn setImage:[UIImage imageNamed:@"fav_on.png"] forState:UIControlStateNormal];
            }else
            {
                if (objFav == nil) {
                    objFav = [[Favorite alloc] initWithVocab:v FAVID:0];
                }
                [Favorite deleteFavorite:objFav];
                flagFav = NO;
                [self.FavBtn setImage:[UIImage imageNamed:@"fav_off.png"] forState:UIControlStateNormal];
            }
        }
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
        Player.volume =1.0f;
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
