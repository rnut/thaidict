//
//  TMTrueID.h
//  TMTrueMoveOnly
//
//  Created by Jerapong Nampetch on 2/21/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 Get device's unique identifier method. Get a real device UID on iOS4, Generated UID on iOS5.
 
 @warning You should use this method instead all on -uniqueIdentifier of your project and should not generate UID by yourself. It's will have more than 1 UID in your application. UID returned from this method is UID storaged in application's user default which should not generate again. 
*/

UIKIT_EXTERN NSString * uniqueIdentifier();
UIKIT_EXTERN void removeTUID();

@interface TMTrueID : NSObject

+ (NSString *)version;

+ (NSString *)currentTrueID;
+ (BOOL)updateCurrentTrueID;

@end

@interface TMTrueID (tmo20)

+ (NSString *)deviceMacAddress;

@end