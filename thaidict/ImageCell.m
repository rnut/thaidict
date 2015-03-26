//
//  ImageCell.m
//  thaidict
//
//  Created by Rnut on 2/27/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import "ImageCell.h"
#import "DetailVocab.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
@implementation ImageCell
@synthesize pageImages = _pageImages,ChooseVocab,Collectionview,ctrl;

-(id)initWithViewController:(UIViewController*)c {
    if (self = [super init]) {
        ctrl = c;
    }
    return self;
}

- (void)awakeFromNib {
    _pageImages = [[NSMutableArray alloc] init];
    ((UICollectionViewFlowLayout *)self.Collectionview.collectionViewLayout).minimumLineSpacing = 2.0f;
    ((UICollectionViewFlowLayout *)self.Collectionview.collectionViewLayout).scrollDirection = UICollectionViewScrollDirectionHorizontal;
}
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"tap ImageView");
//        [self loadImage];

}
//-(void)load{
//    [self.IndicatorImage startAnimating];
//    dispatch_queue_t externalque = dispatch_queue_create("getInformation", nil);
//    
//    dispatch_async(externalque, ^{
//        self.apI = [[APImage alloc] initWithVocabSearch:[ChooseVocab Search] Language:[ChooseVocab Language]];
//        _pageImages = [self.apI Image];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.Collectionview reloadData];
//            [self.IndicatorImage stopAnimating];
//        });
//    });
//}
-(void)load{
    if (self.rawData == nil) {
        self.rawData = [[NSMutableArray alloc] init];
    }
    NSString *ln;
    if ([Language checkLanguage:ChooseVocab.Search] == LanguageENG) {
        ln = @"en";
    }else ln = @"th";
    NSString *path = [NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&hl=%@&q=%@&rsz=5",ln,ChooseVocab.Search];

    NSString *encoded = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.IndicatorImage startAnimating];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:encoded parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if (responseObject != nil) {
            [self.IndicatorImage stopAnimating];
            self.rawData = [[responseObject objectForKey:@"responseData"] objectForKey:@"results"];
            [self.Collectionview reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    _pageImages = [[NSMutableArray alloc] init];
    [self load];

}


#pragma mark collectionview
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.rawData == nil) {
        return 0;
    }
    return [self.rawData count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImageView *IMG = (UIImageView *)[cell viewWithTag:100];
 
    [IMG setImageWithURL:[NSURL URLWithString:[[self.rawData objectAtIndex:indexPath.row] objectForKey:@"tbUrl"]] placeholderImage:[UIImage imageNamed:@"banner.jpg"]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{


    chooseIndex = (int)indexPath.row;
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = YES;
    BOOL enableGrid = YES;
    BOOL startOnGrid = YES;

    for (NSDictionary *dict in [self rawData]) {
        NSString *str = [dict objectForKey:@"tbUrl"];
        MWPhoto *thumbx = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:str]];
        NSString *strurl = [dict objectForKey:@"url"];
        MWPhoto *photox = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:strurl]];
        
        [photos addObject:photox];
        [thumbs addObject:thumbx];
    }
    // Options
    startOnGrid = NO;
    displayNavArrows = YES;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;
#endif

    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = YES;
    
    self.thumbs = thumbs;
    self.photos = photos;
    [browser setCurrentPhotoIndex:chooseIndex];
//    if ([ctrl isKindOfClass:[UISplitViewController class]])
//        [[[ctrl.childViewControllers objectAtIndex:1] navigationController] pushViewController:browser animated:YES];
//    else{
//        //[ctrl.parentViewController.parentViewController.navigationController pushViewController:browser animated:YES];
////        [ctrl.parentViewController.parentViewController.tabBarController.tabBar setHidden:YES];
////        [ctrl.parentViewController hidesBottomBarWhenPushed];
//        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
//        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        [ctrl presentViewController:nc animated:YES completion:nil];
////        [ctrl.navigationController pushViewController:browser animated:YES];
//
//    }
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [ctrl presentViewController:nc animated:YES completion:nil];
    
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return YES;
}
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
//    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [ctrl dismissViewControllerAnimated:YES completion:nil];
}

//-(UIImage *)captureScreen:(UIViewController *)vc{
//    UIImage *ret = [[UIImage alloc] init];
//    CALayer *layer = [[UIApplication sharedApplication] keyWindow].layer;
//    CGFloat scale = [UIScreen mainScreen].scale;
//    CGSize size =  CGSizeMake(vc.view.layer.frame.size.width, vc.view.layer.frame.size.height);
//    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
//    [layer renderInContext:UIGraphicsGetCurrentContext()];
//    ret = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return ret;
//}
@end
