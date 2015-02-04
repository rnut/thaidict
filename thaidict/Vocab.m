//
//  Vocab.m
//  DemoSqlite
//
//  Created by Rnut on 11/25/2557 BE.
//  Copyright (c) 2557 Rnut. All rights reserved.
//

#import "Vocab.h"

@implementation Vocab

@synthesize Language,IDvocab,Search,Cat,Antonym,SoundPath,ImgPath;


-(id)initWithLanguage:(DictLanguage)lang IDvocab:(int)idvocab Search :(NSString *)strsearch Entry:(NSString *)strentry Cat:(NSString*)strcat Synonym:(NSString*)strsyn Antonym:(NSString*)strant{
    [self setLanguage:lang];
    [self setIDvocab:idvocab];
    [self setSearch:strsearch];
    [self setEntry:strentry];
    [self setCat:strcat];
    [self setSynonym:strsyn];
    [self setAntonym:strant];
    return self;
    
}
+(NSMutableArray *)listDictByVocab:(NSString *)vocab{
    DB *db = [[DB alloc ]init];
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    DictLanguage lang;
    lang = [Language checkLanguage:vocab];
    if (lang == LanguageTHA) {
        NSString *tableName;
        //  ก-ฮ  :  3585 - 3630  , สระ 3632-3676
        int ascii = [vocab characterAtIndex:0];
        if (ascii > 3584 && ascii < 3631) {
//            NSString *first = [vocab characterAtIndex:0];
            tableName = [NSString  stringWithFormat:@"th2eng_%@",[vocab substringFromIndex:0]];
        }
        else if(ascii > 3647 && ascii <3653){
            if ([vocab length]>1) {
                int asciix = [vocab characterAtIndex:1];
                if (asciix > 3584 && asciix < 3631) {
                    tableName = [NSString  stringWithFormat:@"th2eng_%@",[vocab substringFromIndex:1]];
                }
            }
        }
        
        if (tableName != nil) {
            [db queryWithString:[NSString stringWithFormat:@"select IFNULL(id, '') as id, IFNULL(tsearch, '') as esearch,IFNULL(eentry, '') as eentry,IFNULL(tcat, '') as ecat,IFNULL(tsyn, '') as esyn,IFNULL(tant, '') as eant from %@ where esearch LIKE '%@%%' order by tsearch",tableName,vocab]];
            while([db.ObjResult next]) {
                Vocab *temp = [[Vocab alloc] initWithLanguage:lang IDvocab:[db.ObjResult intForColumn:@"id"] Search:[db.ObjResult stringForColumn:@"esearch"] Entry:[db.ObjResult stringForColumn:@"eentry"] Cat:[db.ObjResult stringForColumn:@"ecat"] Synonym:[db.ObjResult stringForColumn:@"esyn"] Antonym:[db.ObjResult stringForColumn:@"eant"]];
                [ret addObject:temp];
            }
        }

    }
    else if(lang == LanguageENG){
        char first = [[vocab uppercaseString] characterAtIndex:0];
        NSString *tableName = [NSString  stringWithFormat:@"eng2th_%c",first];
        [db queryWithString:[NSString stringWithFormat:@"select IFNULL(id, '') as id, IFNULL(esearch, '') as esearch,IFNULL(eentry, '') as eentry,IFNULL(tentry, '') as tentry,IFNULL(ecat, '') as ecat,IFNULL(ethai, '') as ethai,IFNULL(esyn, '') as esyn,IFNULL(eant, '') as eant from %@ where esearch LIKE '%@%%' group by esearch order by esearch limit 50",tableName,vocab]];
        while([db.ObjResult next]) {
            Vocab *temp = [[Vocab alloc] initWithLanguage:lang IDvocab:[db.ObjResult intForColumn:@"id"] Search:[db.ObjResult stringForColumn:@"esearch"] Entry:[db.ObjResult stringForColumn:@"tentry"] Cat:[db.ObjResult stringForColumn:@"ecat"] Synonym:[db.ObjResult stringForColumn:@"esyn"] Antonym:[db.ObjResult stringForColumn:@"eant"]];
            [ret addObject:temp];
        }
    }
    [db closeDB];
    return ret;
}

+(NSMutableArray *)translateVocab:(Vocab *)vocab{
    DB *db = [[DB alloc ]init];
    NSMutableArray *ret2 = [[NSMutableArray alloc] init];
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    int numberOfType = 0;
    NSString *t; //temp
    if (vocab.Language == LanguageTHA) {
        NSString *tableName;
        //    ก-ฮ  :  161 - 206  , สระ 207-251
        int ascii = [vocab.Search characterAtIndex:0];
        if (ascii > 160 && ascii <207) {
            char first = [vocab.Search characterAtIndex:0];
            tableName = [NSString  stringWithFormat:@"th2eng_%c",first];
        }
        else{
            char first = [vocab.Search characterAtIndex:1];
            tableName = [NSString  stringWithFormat:@"th2eng_%c",first];
        }
        [db queryWithString:[NSString stringWithFormat:@"select IFNULL(id, '') as id, IFNULL(tsearch, '') as esearch,IFNULL(eentry, '') as eentry,IFNULL(tcat, '') as cat,IFNULL(tsyn, '') as esyn,IFNULL(tant, '') as eant from %@ where esearch = '%@' order by tsearch",tableName,vocab.Search]];
        int i =0;
        while([db.ObjResult next]) {
            NSString *cat = [db.ObjResult stringForColumn:@"cat"];
            Vocab *temp = [[Vocab alloc] initWithLanguage:LanguageTHA IDvocab:[db.ObjResult intForColumn:@"id"] Search:[db.ObjResult stringForColumn:@"esearch"] Entry:[db.ObjResult stringForColumn:@"eentry"] Cat:cat Synonym:[db.ObjResult stringForColumn:@"esyn"] Antonym:[db.ObjResult stringForColumn:@"eant"]];
            [ret addObject:temp];
            if (i== 0) {
                numberOfType++;
                t = cat;
                i++;
                continue;
            }
            if (![cat isEqualToString:t]) {
                numberOfType++;
            }


            i++;
        }
        [db closeDB];
    }
    else if(vocab.Language == LanguageENG){
        char first = [[vocab.Search uppercaseString] characterAtIndex:0];
        NSString *tableName = [NSString  stringWithFormat:@"eng2th_%c",first];
        NSString *querySTR =[NSString stringWithFormat:@"select IFNULL(id, '') as id, IFNULL(esearch, '') as esearch,IFNULL(eentry, '') as eentry,IFNULL(tentry, '') as tentry,IFNULL(ecat, '') as cat,IFNULL(ethai, '') as ethai,IFNULL(esyn, '') as esyn,IFNULL(eant, '') as eant from %@ where esearch = '%@' order by ecat",tableName,vocab.Search];
        [db queryWithString:querySTR];
        
        int i = 0;
        while([db.ObjResult next]) {
            NSString *cat = [db.ObjResult stringForColumn:@"cat"];
            Vocab *temp = [[Vocab alloc] initWithLanguage:LanguageENG IDvocab:[db.ObjResult intForColumn:@"id"] Search:[db.ObjResult stringForColumn:@"esearch"] Entry:[db.ObjResult stringForColumn:@"tentry"] Cat:cat Synonym:[db.ObjResult stringForColumn:@"esyn"] Antonym:[db.ObjResult stringForColumn:@"eant"]];
            [ret addObject:temp];
            
            if (i== 0) {
                numberOfType++;
                t = cat;
                i++;
                continue;
            }
            if (![cat isEqualToString:t]) {
                numberOfType++;
            }

            i++;
        }
        [db closeDB];
        }
    
    if ([ret count] == 1) {
        [ret2 addObject:ret];
    }
    else{
        NSString *tt;
        int index = 0;
        for (int i = 0; i<numberOfType; i++) {
            NSMutableArray *type = [[NSMutableArray alloc] init];
            BOOL flag = NO;
            
            for (int j = index; j<[ret count]; j++) {
                if (i== 0 && j== 0) {
                    tt = [[ret objectAtIndex:j] Cat];
                    [type addObject:[ret objectAtIndex:i]];
                    index++;
                    continue;
                }
                
                if ([tt isEqualToString:[[ret objectAtIndex:j] Cat]]) {
                    flag = NO;
                    
                }
                else{
                    flag = YES;
                    if ([type count] == 0) {
                        [type addObject:[ret objectAtIndex:j]];
                        index++;
                    }
                }
                
                if (flag) {
                    [ret2 addObject:type];
                    //index++;
                    break;
                }
                [type addObject:[ret objectAtIndex:j]];
                index++;
            }
            if (numberOfType == 1) {
                [ret2 addObject:type];
            }
        }
    }
    return ret2;
}
#pragma mark load data from api server
-(BOOL)loadSound{
//    todo  Asyn get data
    NSString *path = [APSpeech getSpeechThis:[self Search] inLanguage:APSpeechLanguageENG];
    if (![path isEqualToString:@"failed"]) {
        [self setSoundPath:path];
        return YES;
    }
    return NO;
}@end
