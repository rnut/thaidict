//
//  DB.h
//  DemoSqlite
//
//  Created by Rnut on 11/25/2557 BE.
//  Copyright (c) 2557 Rnut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
@interface DB : NSObject
{
    FMDatabase *ObjDb;
    FMResultSet *ObjResult;
}
@property(nonatomic,strong)FMDatabase *ObjDb;
@property(nonatomic,strong)FMResultSet *ObjResult;

-(id)init;
-(void)openDB;
-(void)closeDB;

-(void)queryWithString:(NSString*)query;
-(int)checkNumRecordWithTable:(NSString*)table Condition:(NSString*)condition;
-(int)getLastRecordIDWithTable:(NSString*)table Column:(NSString*)col;
-(BOOL)insertWithString:(NSString*)query;
@end
