//
//  ImageCell.h
//  thaidict
//
//  Created by Rnut on 2/27/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APImage.h"
#import "Vocab.h"
#import "FullImage.h"
#import "DetailVocab.h"

@interface ImageCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>{
    __weak UIViewController *ctrl;
}
@property(nonatomic,strong)UIView *dt;
@property(nonatomic,strong)APImage *apI;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *IndicatorImage;
@property(nonatomic,strong)Vocab *ChooseVocab;
@property (strong, nonatomic) IBOutlet UIView *ViewImage;
@property (strong, nonatomic) IBOutlet UICollectionView *Collectionview;
@property (nonatomic, strong) NSArray *pageImages;
@property(nonatomic,weak)UIViewController *ctrl;
-(id)initWithViewController:(UIViewController*)c;

@end
