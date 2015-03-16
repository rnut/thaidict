//
//  ImageCell.m
//  thaidict
//
//  Created by Rnut on 2/27/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import "ImageCell.h"

@implementation ImageCell
@synthesize pageImages = _pageImages,ChooseVocab,Collectionview;
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
    NSString *url = [[self.apI.RawData objectAtIndex:indexPath.row] objectForKey:@"url"];
    NSLog(@"test :%@",url);
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    FullImage *ivc = [storyboard instantiateViewControllerWithIdentifier:@"FullImage"];
//    ivc.UrlImage = url;
//    ivc.view.opaque = NO;
//    ivc.view.backgroundColor = [UIColor clearColor];
//    [(UINavigationController*)self.window.rootViewController presentViewController:ivc animated:NO completion:nil];
    

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"FullImage"]) {
        NSString *url = @"test";
        FullImage *fullView = [segue destinationViewController];
        [fullView setUrlImage:url];
    }
}
//-(void)loadImage{
//    APImage *img = [[APImage alloc] initWithVocabSearch:[ChooseVocab Search] Language:[ChooseVocab Language]];
//    _pageImages = [img Image];
//    [self.Collectionview reloadData];
//}
@end
