//
//  SampleCell.h
//  thaidict
//
//  Created by Rnut on 2/27/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VocabCell.h"
#import "Vocab.h"
#import "APSample.h"
@interface SampleCell : UITableViewCell
{
    
    UIView *overlayView;
}
@property (strong, nonatomic) IBOutlet UILabel *Example;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *IndicatorExample;
@property (strong, nonatomic) IBOutlet UIView *ExampleView;
@property (assign, nonatomic)BOOL flagSample;
@property(nonatomic,strong)Vocab *ChooseVocab;

@end
