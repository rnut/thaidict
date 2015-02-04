//
//  Language.m
//  TrueDict
//
//  Created by Rnut on 12/9/2557 BE.
//  Copyright (c) 2557 Rnut. All rights reserved.
//

#import "Language.h"

@implementation Language
@synthesize FirstChar;



- (int)getDictLanguage:(DictLanguage)lang
{
    switch (lang) {
        case LanguageENG: return 1;
        case LanguageTHA: return 0;
        default: return 0;
    }
}

+(DictLanguage)checkLanguage:(NSString*)search{
    DictLanguage lang;
    int ascii = [search characterAtIndex:0];
    NSLog(@"search : %@ ;ascii : %d",search,ascii);
//    int xx = 3660;
//    NSString *string = [NSString stringWithFormat:@"%c", xx];
//    NSLog(@"int %d  : ascii : %@",xx,string);
//    ascii > 3584 && ascii < 3631
//    ก-ฮ  :  3585 - 3630  , สระ 3632-3676
    if ((ascii > 3584 && ascii <3631)||(ascii > 3631 && ascii < 3676)) {
        lang = LanguageTHA;
    }
    else if ((ascii > 64 && ascii < 91 ) || (ascii >96 && ascii < 123)){
        lang = LanguageENG;
        
    }
    return lang;
}
@end
