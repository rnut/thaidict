//
//  wordInfo.m
//  Dict
//
//  Created by Apple on 11/25/2557 BE.
//  Copyright (c) 2557 BASIC1_ON. All rights reserved.
//

#import "WordInfo.h"

@implementation WordInfo

-(id)initWithUniqueId:(DictLanguage)lang uniqueId:(int)uniqueId esearch:(NSString *)esearch eentry:(NSString *)eentry tentry:(NSString *) tentry ecat:(NSString *)ecat ethai:(NSString *)ethai esyn:(NSString *)esyn eant:(NSString *)eant 
{
    if (self = [super init]) {
        self.lang = lang;
        self.uniqueId = uniqueId;
        self.esearch = esearch;
        self.eentry = eentry;
        self.tentry = tentry;
        self.ecat = ecat;
        self.ethai = ethai;
        self.esyn = esyn;
        self.eant = eant;
    }
    return self;
}

+(DictLanguage)checkLanguage:(NSString*)search{
    DictLanguage lang;
    
    int ascii = [search characterAtIndex:0];
    if (ascii > 3584 && ascii < 3631) {
        lang = LanguageTHA;
    }
    else if ((ascii > 64 && ascii < 91 ) || (ascii >96 && ascii < 123)){
        lang = LanguageENG;
    }
    return lang;
}
@end
