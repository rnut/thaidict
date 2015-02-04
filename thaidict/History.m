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
    return NO;
}
-(id)initWithNOTInsertVocab:(Vocab *)voc ID:(int)id_his{
    [self setVoc:voc];
    [self setID_his:id_his];
    return self;
}

+(BOOL)clearHistoryWithLanguage:(DictLanguage)lang{
    DB *db = [[DB alloc] init];
    if ([db.ObjDb executeUpdate:[NSString stringWithFormat:@"delete from history where language = %d",lang]]) {
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

#pragma mark HELPER METHOD
-(BOOL)insertVocab:(Vocab *)voc{
    DB *db = [[DB alloc] init];
    NSString *strQuery;
    
    if ([voc Language] == LanguageENG) {
        if ([self checkLimitHistoryWithLanguage:LanguageENG]) {
            strQuery = [NSString stringWithFormat:@"insert into history (id_history,id,language) values (%d,%d,%d)",[self getLastID]+1,[voc IDvocab],[voc Language]];
            if([db.ObjDb executeUpdate:strQuery]){
                [db closeDB];
                
                [self setID_his:[self getLastID]+1];
                [self setVoc:voc];
                return YES;
            }
        }else{
            if ([self deleteFirstRow]) {
                strQuery = [NSString stringWithFormat:@"insert into history (id_history,id,language) values (%d,%d,%d)",[self getLastID]+1,[voc IDvocab],[voc Language]];
                if([db.ObjDb executeUpdate:strQuery]){
                    [self setID_his:[self getLastID]+1];
                    [self setVoc:voc];
                    return YES;
                }
            }
        }
    }
    else if([voc Language] == LanguageTHA){
        if ([self checkLimitHistoryWithLanguage:LanguageTHA]) {
            strQuery = [NSString stringWithFormat:@"insert into history (id_history,id,language) values (%d,%d,%d)",[self getLastID]+1,[voc IDvocab],[voc Language]];
            if([db.ObjDb executeUpdate:strQuery]){
                [db closeDB];
                [self setID_his:[self getLastID]+1];
                [self setVoc:voc];
                return YES;
            }
        }else{
            if ([self deleteFirstRow]) {
                strQuery = [NSString stringWithFormat:@"insert into history (id_history,id,language) values (%d,%d,%d)",[self getLastID]+1,[voc IDvocab],[voc Language]];
                if([db.ObjDb executeUpdate:strQuery]){
                    [self setID_his:[self getLastID]+1];
                    [self setVoc:voc];
                    return YES;
                }
            }
        }
        
    }

    [db closeDB];
    return NO;

}
-(BOOL)checkLimitHistoryWithLanguage:(DictLanguage)lang{
    DB *db = [[DB alloc] init];
    if (lang == LanguageTHA) {
        if ([db checkNumRecordWithTable:@"history" Condition:[NSString stringWithFormat:@"language = %d",LanguageTHA]]<100) {
            [db closeDB];
            return YES;
        }
    }else if (lang == LanguageENG){
        if ([db checkNumRecordWithTable:@"history" Condition:[NSString stringWithFormat:@"language = %d",LanguageENG]]<100) {
            [db closeDB];
            return YES;
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

+(NSMutableArray *)listHistoryByLanguage:(DictLanguage)lang{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    NSString *strQuery;
    DB *db = [[DB alloc ]init];
    if (lang == LanguageENG) {
        strQuery = [NSString stringWithFormat:@"select IFNULL(a.id_his, '') as ID_his,IFNULL(b.id, '') as id, IFNULL(b.esearch, '') as search,IFNULL(b.tentry, '') as entry,IFNULL(b.ecat, '') as cat,IFNULL(b.esyn, '') as syn,IFNULL(b.eant, '') as ant from history a ,eng2th b where a.language = %d and a.id = b.id GROUP by search order by ID_his DESC",lang];
        
        [db queryWithString:strQuery];
        while([db.ObjResult next]) {
            
            Vocab *tempv = [[Vocab alloc] initWithLanguage:lang IDvocab:[db.ObjResult intForColumn:@"id"] Search:[db.ObjResult stringForColumn:@"search"] Entry:[db.ObjResult stringForColumn:@"entry"] Cat:[db.ObjResult stringForColumn:@"cat"] Synonym:[db.ObjResult stringForColumn:@"syn"] Antonym:@"ant"];
            History *temp = [[History alloc] initWithNOTInsertVocab:tempv ID:[db.ObjResult intForColumn:@"ID_his"]];
            [ret addObject:temp];
        }
        [db closeDB];
        
        
        
    }
    else if(lang == LanguageTHA){
        strQuery = [NSString stringWithFormat:@"select IFNULL(a.id_his, '') as ID_his,IFNULL(b.id, '') as id, IFNULL(b.tsearch, '') as search,IFNULL(b.eentry, '') as entry,IFNULL(b.tcat, '') as cat,IFNULL(b.tsyn, '') as syn,IFNULL(b.tant, '') as ant from history a ,th2eng b where a.language = %d and a.id = b.id GROUP by search order by ID_his DESC",lang];
        [db queryWithString:strQuery];
        while([db.ObjResult next]) {
            Vocab *tempv = [[Vocab alloc] initWithLanguage:lang IDvocab:[db.ObjResult intForColumn:@"id"] Search:[db.ObjResult stringForColumn:@"search"] Entry:[db.ObjResult stringForColumn:@"entry"] Cat:[db.ObjResult stringForColumn:@"cat"] Synonym:[db.ObjResult stringForColumn:@"syn"] Antonym:@"ant"];
            History *temp = [[History alloc] initWithNOTInsertVocab:tempv ID:[db.ObjResult intForColumn:@"ID_his"]];
            [ret addObject:temp];
        }
        [db closeDB];
    }
    
    
    
    return ret;
}


@end
