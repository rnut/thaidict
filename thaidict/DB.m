//
//  DB.m
//  DemoSqlite
//
//  Created by Rnut on 11/25/2557 BE.
//  Copyright (c) 2557 Rnut. All rights reserved.
//

#import "DB.h"

@implementation DB

@synthesize ObjDb,ObjResult;
-(id)init{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"lexitron.sqlite"];
    ObjDb = [FMDatabase databaseWithPath:dbPath];
    [self openDB];
    return self;
}
-(void)closeDB{
    [ObjDb close];
}
-(void)openDB{
    [ObjDb open];
}
-(void)queryWithString:(NSString*)query{
        ObjResult = [ObjDb executeQuery:query];
}
-(BOOL)insertWithString:(NSString*)query{
    return [ObjDb executeUpdate:query];
}
-(BOOL)executeUpdateWithString:(NSString*)query{
    NSError *error;
    return [ObjDb executeUpdate:query withErrorAndBindings:&error];
}

#pragma mark Helper Method

-(int)checkNumRecordWithTable:(NSString*)table Condition:(NSString*)condition{
    int idrec = 0;
    if (![condition isEqualToString:@""]) {
        [self queryWithString:[NSString stringWithFormat:@"select count(*)as count from %@ where %@",table,condition]];
    }
    else{
        [self queryWithString:[NSString stringWithFormat:@"select count(*)as count from %@",table]];

    }
       while([ObjResult next]) {
        idrec =  [ObjResult intForColumn:@"count"];
    }
    return idrec;
}
-(int)getLastRecordIDWithTable:(NSString*)table Column:(NSString*)col{
    NSString *strQuery = [NSString stringWithFormat:@"select %@ as lastID from %@ order by %@ desc limit 1",col,table,col];
    [self queryWithString:strQuery];
    while ([ObjResult next]) {
        return [ObjResult intForColumn:@"lastID"];
    }
    return 0;
}


+(NSString *)checkDatabase{
    NSString *str = @"";
    int count = 0;
    DB *db = [[DB alloc] init];
    [db openDB];
    NSString *strQuery = [NSString stringWithFormat:@"select count(*)as count from eng2th_A"];
    [db queryWithString:strQuery];
    while ([db.ObjResult next]) {
        count = [db.ObjResult intForColumn:@"count"];
    }
//    str = [str stringByAppendingString:strQuery];
//    str = [str stringByAppendingString:@"\n\n"];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"count : %d",count]];
//    str =  [NSString stringWithFormat:@"count : %d",[db.ObjResult intForColumn:@"lastID"]];
    [db closeDB];
    return str;
}
@end




