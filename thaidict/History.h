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
+(NSMutableArray *)listHistoryByLanguage:(DictLanguage)lang;
+(BOOL)clearHistoryWithLanguage:(DictLanguage)lang;
+(BOOL)deleteHistory:(History*)hist;
@end
