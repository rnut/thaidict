//
//  Language.h
//  TrueDict
//
//  Created by Rnut on 12/9/2557 BE.
//  Copyright (c) 2557 Rnut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Language : NSObject

typedef enum {
    LanguageTHA,
    LanguageENG
} DictLanguage;

@property(nonatomic,strong)NSString *FirstChar;
+(DictLanguage)checkLanguage:(NSString*)search;

@end
