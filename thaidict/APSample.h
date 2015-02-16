//
//  APSample.h
//  thaidict
//
//  Created by Rnut on 2/16/2558 BE.
//  Copyright (c) 2558 Rnut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLNode.h"
#import "HTMLParser.h"
#import "Language.h"
#import "Connect.h"
#import "NSString_stripHtml.h"

@interface APSample : NSObject

+(NSString *)SearchSample:(NSString *)search;
@end
