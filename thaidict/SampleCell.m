//
//  SampleCell.m
//  thaidict
//
//  Created by Rnut on 2/27/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import "SampleCell.h"

@implementation SampleCell
@synthesize ChooseVocab;
- (void)awakeFromNib {
    flagSample = YES;
    
    [self removeOverlayAndIndicator];
    //add touch gesture
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.ExampleView addGestureRecognizer:singleFingerTap];
}




- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"tap exampleview");
    if (flagSample) {
        [self addOverlayAndIndicator];
//        [self.IndicatorImage startAnimating];
        dispatch_queue_t externalque = dispatch_queue_create("getInformation", nil);
        
        dispatch_async(externalque, ^{
            [self loadExample];
//            APImage *img = [[APImage alloc] initWithVocabSearch:[ChooseVocab Search] Language:[ChooseVocab Language]];
//            _pageImages = [img Image];
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.CollectionImage reloadData];
//                [self.IndicatorImage stopAnimating];
            });
        });
        flagSample= NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)loadExample{
    if(ChooseVocab.Language == LanguageENG){
        dispatch_queue_t exQueue_ = dispatch_queue_create("exampleque", NULL);
        dispatch_async(exQueue_, ^{
            
            [ChooseVocab loadSampleENG];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[ChooseVocab Sample] isEqualToString:@""] || [ChooseVocab Sample] == nil) {
                    self.Example.text = @"not found example";
                    [self removeOverlayAndIndicator];
                    flagSample = NO;
                }
                else{
                    self.Example.text = [ChooseVocab Sample];
                    [self removeOverlayAndIndicator];
                    flagSample = NO;
                }
            });
        });
    }
}

#pragma mark Overlay
-(void)addOverlayAndIndicator{
    [self.IndicatorExample setHidden:NO];
    [self.IndicatorExample startAnimating];
    overlayView = [[UIView alloc] initWithFrame:[self.ExampleView bounds]];
    overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.ExampleView addSubview:overlayView];
}
-(void)removeOverlayAndIndicator{
    [self.IndicatorExample setHidden:YES];
    [self.IndicatorExample stopAnimating];
    [overlayView removeFromSuperview];
}

@end
