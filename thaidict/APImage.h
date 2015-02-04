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
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
@interface APImage : NSObject



@property(nonatomic,strong)NSMutableArray *Image;
-(id)initWithVocabSearch:(NSString *)search Language:(DictLanguage)lang;
@end
