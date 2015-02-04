//
//  APSpeech.m
//
//  Created by alberto pasca on 10/04/13.
//  Copyright (c) 2013 albertopasca.it All rights reserved.
//

#import "APSpeech.h"


#define URL @"http://translate.google.com/translate_tts?tl=%@&q=%@"
#define UA  @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7.5; rv:2.0.1) Gecko/20100101 Firefox/4.1.2"


@interface APSpeech ()
{
  float _Volume;
  int   _Loop;

}
@end


@implementation APSpeech
@synthesize Volume=_Volume, Loop=_Loop;

- (id) init
{
  if ( self = [super init] )
  {
    _Volume = 1.0f;
    _Loop   = 0;
  }
  
  return self;
}

- (NSString*) getLanguage:(APSpeechLanguage)lang
{
  switch (lang) {
    case APSpeechLanguageITA: return @"it";
    case APSpeechLanguageENG: return @"en";
    case APSpeechLanguageFRE: return @"fr";
    case APSpeechLanguageDEU: return @"de";
    case APSpeechLanguageESP: return @"es";
    case APSpeechLanguageTHA: return @"th";
    default: return @"en";
  }
}
+ (NSString*) getSpeechThis:(NSString*)text inLanguage:(APSpeechLanguage)lang
{
    APSpeech *ap = [[APSpeech alloc] init];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",text]];
    
    
    NSString *urlString = [NSString stringWithFormat:URL, [ap getLanguage:lang], text];
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setValue:UA forHTTPHeaderField:@"User-Agent"];
    
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ( error ) return @"failed";
    
    [data writeToFile:path atomically:YES];
    
    if ( [[NSFileManager defaultManager] fileExistsAtPath:path] )
    {
        return path;
    }
    
    return @"failed";
}
+(BOOL)deleteSpeech:(NSString*)speechName{

    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",speechName]];

    if([[NSFileManager defaultManager] fileExistsAtPath:path] == YES)
    {
        NSError *err;
        BOOL stat = [[NSFileManager defaultManager] removeItemAtPath:path error:&err];
        if (stat) {
            return YES;
        }
    }
    return NO;
}



@end

