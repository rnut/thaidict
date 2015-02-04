//
//  wordInfo.h
//  Dict
//
//  Created by Apple on 11/25/2557 BE.
//  Copyright (c) 2557 BASIC1_ON. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordInfo : NSObject
{
    int _uniqueId;
    NSString *_esearch;
    NSString *_eentry;
    NSString *_tentry;
    NSString *_ecat;
    NSString *_ethai;
    NSString *_esyn;
    NSString *_eant;
}

typedef enum {
    LanguageTHA,
    LanguageENG
} DictLanguage;

@property(nonatomic,assign) DictLanguage lang;
@property (nonatomic, assign) int uniqueId;
@property (nonatomic, copy) NSString *esearch;
@property (nonatomic, copy) NSString *eentry;
@property (nonatomic, copy) NSString *tentry;
@property (nonatomic, copy) NSString *ecat;
@property (nonatomic, copy) NSString *ethai;
@property (nonatomic, copy) NSString *esyn;
@property (nonatomic, copy) NSString *eant;
@property BOOL *beingfaved;

-(id)initWithUniqueId:(DictLanguage)lang uniqueId:(int)uniqueId esearch:(NSString *)esearch eentry:(NSString *)eentry tentry:(NSString *) tentry ecat:(NSString *)ecat ethai:(NSString *)ethai esyn:(NSString *)esyn eant:(NSString *)eant;
+(DictLanguage)checkLanguage:(NSString*)search;

@end
