//
//  Favorite.m
//  TrueDict
//
//  Created by Rnut on 12/1/2557 BE.
//  Copyright (c) 2557 Rnut. All rights reserved.
//

#import "Favorite.h"
#import "Vocab.h"
@implementation Favorite

@synthesize Fav_ID,Fav_vocab;



-(id)initWithVocab:(Vocab*)favWord{
    self = [self init];
    if(self){
        [self keepFavorite:favWord];
    }
    return self;
}
-(BOOL)keepFavorite:(Vocab*)fav_vocab{
    DB *db = [[DB alloc] init];
    int idrec = 0;
    NSString *strQuery;
    idrec = [self getIDLastRecord]+1;
    [self setFav_ID:idrec];
    [self setFav_vocab:fav_vocab];
    strQuery = [NSString stringWithFormat:@"INSERT INTO fav(id_fav, search) VALUES( %d, '%@')", [self Fav_ID],[self.Fav_vocab Search]];
    [db insertWithString:strQuery];
    [db closeDB];

    if (![[self.Fav_vocab Search] isEqualToString:@""]) {
        return YES;
    }
    return NO;
}
+(NSMutableArray *)listFavorite{
//    NSMutableArray *ret = [[NSMutableArray alloc] init];
//    NSString *strQuery;
//    DB *db = [[DB alloc ]init];
//    if (lang == LanguageENG) {
//        strQuery = [NSString stringWithFormat:@"select IFNULL(b.id, '') as id, IFNULL(b.esearch, '') as search,IFNULL(b.tentry, '') as entry,IFNULL(b.ecat, '') as cat,IFNULL(b.esyn, '') as syn,IFNULL(b.eant, '') as ant from fav a ,eng2th b where a.language = %d and a.id = b.id",lang];
//        
//        [db queryWithString:strQuery];
//        while([db.ObjResult next]) {
//            Vocab *temp = [[Vocab alloc] initWithLanguage:lang IDvocab:[db.ObjResult intForColumn:@"id"] Search:[db.ObjResult stringForColumn:@"search"] Entry:[db.ObjResult stringForColumn:@"entry"] Cat:[db.ObjResult stringForColumn:@"cat"] Synonym:[db.ObjResult stringForColumn:@"syn"] Antonym:@"ant"];
//            [ret addObject:temp];
//        }
//        [db closeDB];
//        
//        
//        
//    }
//    else if(lang == LanguageTHA){
//        strQuery = [NSString stringWithFormat:@"select IFNULL(b.id, '') as id, IFNULL(b.tsearch, '') as search,IFNULL(b.eentry, '') as entry,IFNULL(b.tcat, '') as cat,IFNULL(b.tsyn, '') as syn,IFNULL(b.tant, '') as ant from fav a ,th2eng b where a.language = %d and a.id = b.id",lang];
//        [db queryWithString:strQuery];
//        while([db.ObjResult next]) {
//            Vocab *temp = [[Vocab alloc] initWithLanguage:lang IDvocab:[db.ObjResult intForColumn:@"id"] Search:[db.ObjResult stringForColumn:@"search"] Entry:[db.ObjResult stringForColumn:@"entry"] Cat:[db.ObjResult stringForColumn:@"cat"] Synonym:[db.ObjResult stringForColumn:@"syn"] Antonym:@"ant"];
//            [ret addObject:temp];
//        }
//        [db closeDB];
//    }
//    return ret;
    
    NSMutableArray *retrievalEng = [[NSMutableArray alloc] init];
    NSMutableArray *retrievalThai = [[NSMutableArray alloc] init];
    DB *db = [[DB alloc ]init];
    
    NSString *strQuery = [NSString stringWithFormat:@"SELECT search FROM fav"];
    
    [db queryWithString:strQuery];
    while([db.ObjResult next]) {
        NSString *temp = [db.ObjResult stringForColumn:@"search"];
        if([Language checkLanguage:temp] == LanguageTHA)
            [retrievalThai addObject:temp];
        else
            [retrievalEng addObject:temp];
    }
    [db closeDB];
    NSMutableArray *retrieval = [[NSMutableArray alloc] init];
    [retrieval addObject:retrievalEng];
    [retrieval addObject:retrievalThai];
    return retrieval;
    
}
+(BOOL)checkExistanceOfFavWord:(NSString *) favword
{
    DB *db = [[DB alloc ]init];
    NSString *strQuery = [NSString stringWithFormat:@"SELECT count(*) as num FROM fav WHERE search = '%@'", favword];
    NSLog(@"%@",strQuery);
    
    [db queryWithString:strQuery];
    
    while ([db.ObjResult next]) {
        int num = [db.ObjResult intForColumn:@"num"];
        NSLog(@"%d",num);
        if (num ==0) {
            [db closeDB];
            return NO;
        }
        else
        {
            [db closeDB];
            return YES;
        }
    }
    
    
    return NO;
}
-(int)getIDLastRecord{
//    select id_fav from fav ORDER by id_fav desc LIMIT 1
    int idrec = 0;
    DB *db = [[DB alloc] init];
    [db queryWithString:@"select id_fav from fav ORDER by id_fav desc LIMIT 1"];
    while([db.ObjResult next]) {
        idrec =  [db.ObjResult intForColumn:@"id_fav"];
    }
    [db closeDB];
    return idrec;

    
}

@end
