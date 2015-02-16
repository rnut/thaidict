//
//  Connect.m
//  socialDJ_Phase2
//
//  Created by Rnut on 5/5/2557 BE.
//  Copyright (c) 2557 Rnut. All rights reserved.
//

#import "Connect.h"

@implementation Connect

+(id)connectWithPath : (NSString *)path{
    
    NSString *stringURL = [NSString stringWithFormat:@"%@",path];
    NSString *encodeURL = [stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodeURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return jsonObject;
    
}
+(id)connectHtmlWithPath : (NSString *)path{
    NSError *error = nil;
    NSString *stringURL = [NSString stringWithFormat:@"%@",path];
    NSString *encodeURL = [stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodeURL];
//    NSData *data = [NSData dataWithContentsOfURL:url];
    NSString *webData = [NSString stringWithContentsOfURL:url encoding:4 error:&error];
    return webData;
    
}
@end
