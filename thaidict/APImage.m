//
//  APImage.m
//  TrueDict
//
//  Created by Rnut on 12/9/2557 BE.
//  Copyright (c) 2557 Rnut. All rights reserved.
//

#import "APImage.h"

@implementation APImage

@synthesize Image;
-(id)initWithVocabSearch:(NSString *)search Language:(DictLanguage)lang{
    if (self.Image == nil) {
        Image = [[NSMutableArray alloc] init];
    }
    NSString *ln;
    if (lang == LanguageENG) {
        ln = @"en";
    }
    else if (lang == LanguageTHA){
        ln = @"th";
    }
    
    NSString *path = [NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&hl=%@&q=%@",ln,search];
    NSURL *url = [NSURL URLWithString:path];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&localError];
    
    
    NSArray *result = [[parsedObject objectForKey:@"responseData"] objectForKey:@"results"];
    if ([result count] > 0) {
        for (NSDictionary *obj in result) {
            NSURL *tempURL = [NSURL URLWithString:[obj objectForKey:@"url"]];
//            UIImageView *imgV = [[UIImageView alloc] init];
//            UIImage *placeholder = [UIImage imageNamed:@"photo1.png"];
//            [imgV setImageWithURL:tempURL placeholderImage:placeholder];
            NSData *dataImg = [NSData dataWithContentsOfURL:tempURL];
            UIImage *img = [UIImage imageWithData:dataImg];
            
            [self.Image addObject:img];
        }
    }
    
    if (localError != nil) {
        error = localError;
        return nil;
    }
    
    
    
    return self;
}
@end
