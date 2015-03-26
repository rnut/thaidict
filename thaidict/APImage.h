//
//  APImage.h
//  TrueDict
//
//  Created by Rnut on 12/9/2557 BE.
//  Copyright (c) 2557 Rnut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Language.h"
@interface APImage : NSObject



@property(nonatomic,strong)NSMutableArray *Image;
@property(nonatomic,strong)NSArray *RawData;
-(id)initWithVocabSearch:(NSString *)search Language:(DictLanguage)lang;
@end
