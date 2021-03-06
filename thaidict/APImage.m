//
//  APImage.m
//  TrueDict
//
//  Created by Rnut on 12/9/2557 BE.
//  Copyright (c) 2557 Rnut. All rights reserved.
//

#import "APImage.h"

@implementation APImage
{
    NSMutableData *receivedData;
    NSURLConnection *theConnection;
}
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
    NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&localError];
    
    
    NSArray *result = [[parsedObject objectForKey:@"responseData"] objectForKey:@"results"];
    if ([result count] > 0) {
        for (NSDictionary *obj in result) {
            NSURL *tempURL = [NSURL URLWithString:[obj objectForKey:@"tbUrl"]];
            // Create the request.
            NSURLRequest *postRequest = [NSURLRequest requestWithURL:tempURL];
            NSHTTPURLResponse *response = nil;
            NSError *error = nil;
            NSData *responseData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&error];
            
            NSDictionary *dict = [response allHeaderFields];
            NSLog(@"Status code: %ld",(long)[response statusCode]);
            NSLog(@"Headers:\n %@",dict.description);
            NSLog(@"Error: %@",error.description);
            UIImage *img = [UIImage imageWithData:responseData];
            [self.Image addObject:img];
        }
    }
    if (localError != nil) {
        error = localError;
        return nil;
    }
    
    
    
    return self;
}

#pragma mark delegate urlconnection
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
//    [receivedData appendData:data];

}
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    
    theConnection = nil;
    receivedData = nil;
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}
@end
