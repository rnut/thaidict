//
//  History.h
//  TrueDict
//
//  Created by Rnut on 11/27/2557 BE.
//  Copyright (c) 2557 Rnut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vocab.h"
#import "DB.h"
@interface History : NSObject
{
    int ID_his;
    Vocab *Voc;
}
@property(nonatomic,assign)int ID_his;
@property(nonatomic,strong)Vocab *Voc;
-(id)initWithVocab:(Vocab *)voc;
-(BOOL)checkLimitHistory;

+(BOOL)keepHistory:(Vocab*)voc;
+(NSMutableArray *)listHistory;

+(BOOL)clearHistory;
+(BOOL)deleteHistory:(History*)hist;
@end
