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
#import <AssetsLibrary/AssetsLibrary.h>
#import "MWPhotoBrowser.h"

@interface ImageCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,MWPhotoBrowserDelegate>{

    int chooseIndex;
}
@property(nonatomic,strong)UIView *dt;
@property(nonatomic,strong)APImage *apI;//mark

@property(nonatomic,strong)UIViewController *ctrl;
@property(nonatomic,strong)NSMutableArray *rawData;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *IndicatorImage;
@property(nonatomic,strong)Vocab *ChooseVocab;
@property (strong, nonatomic) IBOutlet UIView *ViewImage;
@property (strong, nonatomic) IBOutlet UICollectionView *Collectionview;
@property (nonatomic, strong) NSMutableArray *pageImages;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;


-(id)initWithViewController:(UIViewController*)c;

@end
