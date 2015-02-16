//
//  APSample.m
//  thaidict
//
//  Created by Rnut on 2/16/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import "APSample.h"

@implementation APSample


+(NSString *)SearchSample:(NSString *)search{
    NSString *ret;
    if ([Language checkLanguage:search] == LanguageENG) {
        NSError *error = nil;
        NSString *html = [Connect connectHtmlWithPath:[NSString stringWithFormat:@"http://dict.longdo.com/mobile.php?search=%@",search]];
        NSRange rang1 = [html rangeOfString:@"ตัวอย่างประโยคจาก Tanaka JP-EN Corpus"];
        if (rang1.location != NSNotFound) {
            NSInteger start = rang1.location;
            NSInteger stop = html.length-start;
            NSRange finRang = NSMakeRange(start,stop);
            html = [html substringWithRange:finRang];
            
            HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
            
            if (error) {
                NSLog(@"Error: %@", error);
            }
            
            HTMLNode *bodyNode = [parser body];
            
            NSArray *tableNodes = [bodyNode findChildTags:@"table"];
            
            HTMLNode *SampleTable = [tableNodes objectAtIndex:0];
            NSArray *trNodes = [SampleTable findChildTags:@"td"];
            for (HTMLNode *n in trNodes) {
                if (![[n getAttributeNamed:@"width"] isEqualToString:@"40%"]) {
                    ret = [n.rawContents stripHtml];
                    return ret;
                }
                
            }
        }
    }
    else{
        
        
    }
    

    return ret;
}
-(NSString *) stringByStrippingHTML {
    NSRange r;
    NSString *s;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}
@end
