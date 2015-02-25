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



+(BOOL)deleteFavorite:(Favorite *)favVocab{
    DB *db = [[DB alloc ]init];
    //int favID = fav;
//    NSLog(@"%@",[favVocab Search]);
    NSString *strQuery;
    if ([Language checkLanguage:[[favVocab Fav_vocab] Search]] == LanguageENG) {
        strQuery = [NSString stringWithFormat:@"DELETE FROM fav_en WHERE search = '%@'", [[favVocab Fav_vocab] Search]];
        
    }
    else{
        strQuery = [NSString stringWithFormat:@"DELETE FROM fav_th WHERE search = '%@'", [[favVocab Fav_vocab] Search]];
    }
    
    if ([db executeUpdateWithString:strQuery]) {
        [db closeDB];
        return YES;
    };
    [db closeDB];
    return NO;
}

-(id)initWithVocab:(Vocab*)favWord FAVID:(int)id_fav{
    self = [self init];
    if(self){
        [self setFav_ID:id_fav];
        [self setFav_vocab:favWord];
    }
    return self;
}


-(BOOL)keepFavorite:(Vocab*)fav_vocab{
    [self setFav_vocab:fav_vocab];
    
    int idrec = 0;
    NSString *strQuery;
    
    DB *db = [[DB alloc] init];
    if ([self checkExistanceOfFavWord]) {
        if ([fav_vocab Language] == LanguageENG) {
            idrec = [self getFavIDLastRecordOfLang:[fav_vocab Language]];
            strQuery = [NSString stringWithFormat:@"INSERT INTO fav_en(id_fav_en, search) VALUES( %d, '%@')", idrec,[self.Fav_vocab Search]];
        }
        else{
            idrec = [self getFavIDLastRecordOfLang:[fav_vocab Language]];
            strQuery = [NSString stringWithFormat:@"INSERT INTO fav_th(id_fav_th, search) VALUES( %d, '%@')", idrec,[self.Fav_vocab Search]];
        }
        [self setFav_ID:idrec];
        [db insertWithString:strQuery];
        [db closeDB];
    }
    else{
        return NO;
    }
    
    
    
    

    if (![[self.Fav_vocab Search] isEqualToString:@""]) {
        return YES;
    }
    return NO;
}
+(NSMutableArray *)listFavorite{
    
    NSMutableArray *retrievalEng = [[NSMutableArray alloc] init];
    NSMutableArray *retrievalThai = [[NSMutableArray alloc] init];
    DB *db = [[DB alloc ]init];

    NSString *strQueryEn = [NSString stringWithFormat:@"SELECT IFNULL(id_fav_en,'') as id_fav,IFNULL(search,'')as search FROM fav_en"];
    NSString *strQueryTh = [NSString stringWithFormat:@"SELECT IFNULL(id_fav_th,'') as id_fav,IFNULL(search,'')as search  FROM fav_th "];
    
    [db queryWithString:strQueryEn];
    while([db.ObjResult next]) {
        int id_fav = [db.ObjResult intForColumn:@"id_fav"];
        NSString *word = [db.ObjResult stringForColumn:@"search"];
        Favorite *t = [[Favorite alloc] init];
        Vocab *vt = [[Vocab alloc] init];
            [vt setSearch:word];
            [vt setLanguage:LanguageENG];
            [t setFav_ID:id_fav];
            [t setFav_vocab:vt];
            [retrievalEng addObject:t];
    }
    [db queryWithString:strQueryTh];
    while([db.ObjResult next]) {
        int id_fav = [db.ObjResult intForColumn:@"id_fav"];
        NSString *word = [db.ObjResult stringForColumn:@"search"];

        Favorite *t = [[Favorite alloc] init];
        Vocab *vt = [[Vocab alloc] init];
            [vt setSearch:word];
            [vt setLanguage:LanguageTHA];
            [t setFav_ID:id_fav];
            [t setFav_vocab:vt];

            [retrievalThai addObject:t];
    }
    [db closeDB];
    NSMutableArray *retrieval = [[NSMutableArray alloc] init];
    [retrieval addObject:retrievalThai];
    [retrieval addObject:retrievalEng];

    return retrieval;
    
}


-(BOOL)checkExistanceOfFavWord
{
    DB *db = [[DB alloc ]init];
    NSString *strQuery;
    if ([Language checkLanguage:[self.Fav_vocab Search]]==LanguageENG) {
        strQuery = [NSString stringWithFormat:@"SELECT count(*) as num FROM fav_en WHERE search = '%@'", [self.Fav_vocab Search]];
    }
    else{
        strQuery = [NSString stringWithFormat:@"SELECT count(*) as num FROM fav_th WHERE search = '%@'", [self.Fav_vocab Search]];
    }
    
    [db queryWithString:strQuery];
    
    while ([db.ObjResult next]) {
        int num = [db.ObjResult intForColumn:@"num"];
        NSLog(@"%d",num);
        if (num ==0) {
            [db closeDB];
            return YES;
        }
        else
        {
            [db closeDB];
            return NO;
        }
    }
    return NO;
}


-(int)getFavIDLastRecordOfLang : (DictLanguage)lang{
//    select id_fav from fav ORDER by id_fav desc LIMIT 1
    int idrec = 0;
    int count = 0;
    DB *db = [[DB alloc] init];
    
    if (lang == LanguageENG) {
        [db queryWithString:@"select count(*)as count, id_fav_en as id_fav from fav_en ORDER by id_fav_en desc LIMIT 1"];
    }
    else{
        [db queryWithString:@"select count(*)as count,id_fav_th as id_fav from fav_th ORDER by id_fav_th desc LIMIT 1"];
    }

    while([db.ObjResult next]) {
        count = [db.ObjResult intForColumn:@"count"];
        idrec =  [db.ObjResult intForColumn:@"id_fav"];
    }
    if (count != 0) idrec++;

    [db closeDB];
    return idrec;
}


#pragma mark ReOrder
+(BOOL)reOrderFav:(NSMutableArray *)arrayFav{
    DB *db = [[DB alloc] init];
    NSString *strLang;
    if ([[[arrayFav objectAtIndex:0] Fav_vocab] Language] == LanguageENG) {
        strLang = @"en";
    }
    else strLang = @"th";
    
    [db executeUpdateWithString:[NSString stringWithFormat:@"Delete from fav_%@",strLang]];
    for (int i = 0 ; i<[arrayFav count]; i++) {
        [Favorite favoriteVocabForReorder:[[arrayFav objectAtIndex:i] Fav_vocab]];
    }
    [db closeDB];
    
    return NO;
    
}
+(BOOL)favoriteVocabForReorder:(Vocab*)vocab{
    Favorite *fav = [[Favorite alloc] init];
    if ([fav keepFavorite:vocab]) {
        return YES;
    }
    return NO;
}
@end
