//
//  FeedbackService.m
//  TrueMovie
//
//  Created by tu on 2/13/56 BE.
//
//

#import "FeedbackService.h"
#import "AFHTTPRequestOperationManager.h"
//#import "NSObject+Exception.h"

@implementation FeedbackService

@synthesize delegate;

- (void) sendFeedBackWithDictionary:(NSDictionary *) dict_
{
    
    NSLog(@"%@",dict_);
    
    
    
    NSString *theURL = @"http://widget4.truelife.com/feedback/rest/?method=feedback&format=json";
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [dict_ objectForKey:@"topic"], @"topic",
                            [dict_ objectForKey:@"comment"], @"comment",
                            [dict_ objectForKey:@"device"], @"device",
                            [dict_ objectForKey:@"os"], @"os",
                            [dict_ objectForKey:@"os_version"], @"os_version",
                            [dict_ objectForKey:@"appname"], @"appname",
                            [dict_ objectForKey:@"displayname"], @"displayname",
                            [dict_ objectForKey:@"version"], @"version",
                            [dict_ objectForKey:@"cn"], @"cn",
                            [dict_ objectForKey:@"network"], @"network",
                            [dict_ objectForKey:@"user_id"], @"user_id",
                            [dict_ objectForKey:@"account"], @"account",
                            [dict_ objectForKey:@"lat"], @"lat",
                            [dict_ objectForKey:@"long"], @"long",
                            nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:theURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSData *data = [NSData dataWithData:(NSData *)responseObject];
        NSError *error = nil;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"responseObject = %@",json);
        if (json)
        {
            [self.delegate feedbackCompleteWithDictionaray:json];
        }
        else
        {
            [self.delegate feedbackFailedWithError:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.delegate feedbackFailedWithError:error];
    }];
    
    
}

@end
