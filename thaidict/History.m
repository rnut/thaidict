//
//  History.m
//  TrueDict
//
//  Created by Rnut on 11/27/2557 BE.
//  Copyright (c) 2557 Rnut. All rights reserved.
//

#import "History.h"

@implementation History

@synthesize ID_his,Voc;


-(id)initWithVocab:(Vocab *)voc{
    if ([self insertVocab:voc]) {
        return self;
    }
    return self;
}
-(id)initWithNOTInsertVocab:(Vocab *)voc ID:(int)id_his{
    [self setVoc:voc];
    [self setID_his:id_his];
    return self;
}


+(NSMutableArray *)listHistory{
    
    NSMutableArray *retrieval = [[NSMutableArray alloc] init];
    DB *db = [[DB alloc ]init];
    
    NSString *strQueryEn = [NSString stringWithFormat:@"SELECT IFNULL(id_his,'') as id_his,IFNULL(search,'')as search FROM history "];
    
    [db queryWithString:strQueryEn];
    while([db.ObjResult next]) {
        int id_fav = [db.ObjResult intForColumn:@"id_his"];
        NSString *word = [db.ObjResult stringForColumn:@"search"];
        
        History *t = [[History alloc] init];
        Vocab *vt = [[Vocab alloc] init];
        
        if ([Language checkLanguage:word] == LanguageENG) [vt setLanguage:LanguageENG];
        else [vt setLanguage:LanguageTHA];
        
        [vt setSearch:word];
        [t setID_his:id_fav];
        [t setVoc:vt];
        [retrieval addObject:t];
    }
    [db closeDB];
    
    
    return retrieval;
    
}
+(BOOL)keepHistory:(Vocab*)voc{
    History *retHis = [[History alloc] init];
    if ([retHis insertVocab:voc]) {
        return YES;
    }
    return NO;
    
}

+(BOOL)clearHistory{
    DB *db = [[DB alloc] init];
    if ([db.ObjDb executeUpdate:[NSString stringWithFormat:@"delete from history"]]) {
        [db closeDB];
        return YES;
    }
    [db closeDB];
    return NO;
}
+(BOOL)deleteHistory:(History*)hist{

    DB *db = [[DB alloc] init];
    if ([db.ObjDb executeUpdate:[NSString stringWithFormat:@"delete from history where id_his = %d",[hist ID_his]]]) {
        [db closeDB];
        return YES;
    }
    [db closeDB];
    return NO;
}


#pragma mark HELPER METHOD
-(BOOL)deleteFirstRow{
    
    
    DB *db = [[DB alloc] init];
    NSString *str = @"select * from history order by id_his asc limit 1";
    [db queryWithString:str];
    int first_id = 0;
    while([db.ObjResult next]) {
        first_id = [db.ObjResult intForColumn:@"id_his"];
    }
    
    if ([db.ObjDb executeUpdate:[NSString stringWithFormat:@"delete from history where id_his = %d",first_id]]) {
        [db closeDB];
        return YES;
    }
    [db closeDB];
    return NO;
}
-(BOOL)insertVocab:(Vocab *)voc{
    DB *db = [[DB alloc] init];
    NSString *strQuery;
        if ([self checkLimitHistory]) {
            strQuery = [NSString stringWithFormat:@"insert into history (id_his,search) values (%d,'%@')",[self getLastID]+1,[voc Search]];
            if([db.ObjDb executeUpdate:strQuery]){
                [db closeDB];
                [self setID_his:[self getLastID]+1];
                [self setVoc:voc];
                return YES;
            }
        }else{
            if ([self deleteFirstRow]) {
                strQuery = [NSString stringWithFormat:@"insert into history (id_his,search) values (%d,'%@')",[self getLastID]+1,[voc Search]];
                if([db.ObjDb executeUpdate:strQuery]){
                    [self setID_his:[self getLastID]+1];
                    [self setVoc:voc];
                    return YES;
                }
            }
        }

    [db closeDB];
    return NO;

}
-(int)getLastID{
    DB *db = [[DB alloc] init];
    int ret = [db getLastRecordIDWithTable:@"history" Column:@"id_his"];
    [db closeDB];
    return ret;
}
-(BOOL)checkLimitHistory{
    DB *db = [[DB alloc] init];
    if ([db checkNumRecordWithTable:@"history" Condition:@""]<200) {
        [db closeDB];
        return YES;
    }
    [db closeDB];
    return NO;
}



@end
