//
//  ImageCell.m
//  thaidict
//
//  Created by Rnut on 2/27/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import "ImageCell.h"
#import "DetailVocab.h"
@implementation ImageCell
@synthesize pageImages = _pageImages,ChooseVocab,Collectionview,ctrl;

-(id)initWithViewController:(UIViewController*)c {
    if (self = [super init]) {
        ctrl = c;
    }
    return self;
}

- (void)awakeFromNib {
    //add touch gesture
//    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//    [self.ViewImage addGestureRecognizer:singleFingerTap];
    ((UICollectionViewFlowLayout *)self.Collectionview.collectionViewLayout).minimumLineSpacing = 2.0f;
    ((UICollectionViewFlowLayout *)self.Collectionview.collectionViewLayout).scrollDirection = UICollectionViewScrollDirectionHorizontal;

}
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"tap ImageView");
//        [self loadImage];

}
-(void)load{
    [self.IndicatorImage startAnimating];
    dispatch_queue_t externalque = dispatch_queue_create("getInformation", nil);
    
    dispatch_async(externalque, ^{
        self.apI = [[APImage alloc] initWithVocabSearch:[ChooseVocab Search] Language:[ChooseVocab Language]];
        _pageImages = [self.apI Image];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.Collectionview reloadData];
            [self.IndicatorImage stopAnimating];
        });
    });
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self load];

}


#pragma mark collectionview
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_pageImages == nil) {
        return 0;
    }
    return [_pageImages count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.Collectionview){
        static NSString *identifier = @"Cell";
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        UIImageView *IMG = (UIImageView *)[cell viewWithTag:100];
        IMG.image = [self.pageImages objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    FullImage *ivc = [storyboard instantiateViewControllerWithIdentifier:@"FullImage"];
//        ivc.rawData = [self.apI RawData];
//        ivc.indexChoose = (int)indexPath.row;
//        ivc.view.opaque = NO;
//        ivc.view.backgroundColor = [UIColor clearColor];
//    ivc.bg = [self captureScreen:ctrl];
//    ctrl.modalPresentationStyle = UIModalPresentationCurrentContext;
//    [ctrl presentViewController:ivc animated:YES completion:nil];
    
    chooseIndex = indexPath.row;
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    
    BOOL displayActionButton = NO;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = NO;
    BOOL startOnGrid = NO;

    for (UIImage *img in _pageImages) {
        MWPhoto *thumbx = [[MWPhoto alloc] initWithImage:img];
        [thumbs addObject:thumbx];
    }
    for(NSDictionary *dict in [self.apI RawData]){
        NSString *str = [dict objectForKey:@"url"];
        MWPhoto *photox = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:str]];
        [photos addObject:photox];
    }
    // Options
    startOnGrid = NO;
    displayNavArrows = NO;
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
    [ctrl.navigationController pushViewController:browser animated:YES];
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
