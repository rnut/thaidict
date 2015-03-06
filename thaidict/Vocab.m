//
//  Vocab.m
//  DemoSqlite
//
//  Created by Rnut on 11/25/2557 BE.
//  Copyright (c) 2557 Rnut. All rights reserved.
//

#import "Vocab.h"

@implementation Vocab

@synthesize Language,IDvocab,Search,Cat,Antonym,SoundPath,ImgPath,Sample;


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
    lang = [Language checkLanguage:[vocab stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if (lang == LanguageTHA) {
        NSString *tableName;
        //  ก-ฮ  :  3585 - 3630  , สระ 3632-3676
        int ascii = [[vocab stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] characterAtIndex:0];
        if (ascii > 3584 && ascii < 3631) {
            tableName = [NSString  stringWithFormat:@"th2eng_%@",[vocab substringWithRange:NSMakeRange(0, 1)]];
        }
        else if(ascii > 3647 && ascii <3653){
            if ([vocab length]>1) {
                int asciix = [vocab characterAtIndex:1];
                if (asciix > 3584 && asciix < 3631) {
                    tableName = [NSString  stringWithFormat:@"th2eng_%@",[vocab substringWithRange:NSMakeRange(1, 1)]];
                }
            }
        }
        
        if (tableName != nil) {
            [db queryWithString:[NSString stringWithFormat:@"select IFNULL(id, '') as id, IFNULL(tsearch, '') as esearch,IFNULL(eentry, '') as eentry,IFNULL(tcat, '') as ecat,IFNULL(tsyn, '') as esyn,IFNULL(tant, '') as eant from %@ where esearch LIKE '%@%%' group by tsearch order by tsearch",tableName,[vocab stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
            while([db.ObjResult next]) {
                Vocab *temp = [[Vocab alloc] initWithLanguage:lang IDvocab:[db.ObjResult intForColumn:@"id"] Search:[db.ObjResult stringForColumn:@"esearch"] Entry:[db.ObjResult stringForColumn:@"eentry"] Cat:[db.ObjResult stringForColumn:@"ecat"] Synonym:[db.ObjResult stringForColumn:@"esyn"] Antonym:[db.ObjResult stringForColumn:@"eant"]];
                [ret addObject:temp];
            }
        }

    }
    else if(lang == LanguageENG){
        char first = [[[vocab uppercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] characterAtIndex:0];
        NSString *tableName = [NSString  stringWithFormat:@"eng2th_%c",first];
        [db queryWithString:[NSString stringWithFormat:@"select IFNULL(id, '') as id, IFNULL(esearch, '') as esearch,IFNULL(eentry, '') as eentry,IFNULL(tentry, '') as tentry,IFNULL(ecat, '') as ecat,IFNULL(ethai, '') as ethai,IFNULL(esyn, '') as esyn,IFNULL(eant, '') as eant from %@ where esearch LIKE '%@%%' group by esearch order by id limit 50",tableName,vocab]];
        while([db.ObjResult next]) {
            Vocab *temp = [[Vocab alloc] initWithLanguage:lang IDvocab:[db.ObjResult intForColumn:@"id"] Search:[db.ObjResult stringForColumn:@"esearch"] Entry:[db.ObjResult stringForColumn:@"tentry"] Cat:[db.ObjResult stringForColumn:@"ecat"] Synonym:[db.ObjResult stringForColumn:@"esyn"] Antonym:[db.ObjResult stringForColumn:@"eant"]];
            [ret addObject:temp];
        }
    }
    [db closeDB];
    return ret;
}
+(NSMutableArray *)listDictByVocab:(NSString *)vocab ByIndex:(int)index{
    DB *db = [[DB alloc ]init];
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    DictLanguage lang;
    lang = [Language checkLanguage:vocab];
    if (lang == LanguageTHA) {
        NSString *tableName;
        //  ก-ฮ  :  3585 - 3630  , สระ 3632-3676
        int ascii = [vocab characterAtIndex:0];
        if (ascii > 3584 && ascii < 3631) {
            tableName = [NSString  stringWithFormat:@"th2eng_%@",[vocab substringWithRange:NSMakeRange(0, 1)]];
        }
        else if(ascii > 3647 && ascii <3653){
            if ([vocab length]>1) {
                int asciix = [vocab characterAtIndex:1];
                if (asciix > 3584 && asciix < 3631) {
                    tableName = [NSString  stringWithFormat:@"th2eng_%@",[vocab substringWithRange:NSMakeRange(1, 1)]];
                }
            }
        }
        
        if (tableName != nil) {
            [db queryWithString:[NSString stringWithFormat:@"select IFNULL(id, '') as id, IFNULL(tsearch, '') as esearch,IFNULL(eentry, '') as eentry,IFNULL(tcat, '') as ecat,IFNULL(tsyn, '') as esyn,IFNULL(tant, '') as eant from %@ where esearch LIKE '%@%%' group by tsearch order by tsearch limit %d,%d",tableName,[vocab stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],index,index+50]];
            while([db.ObjResult next]) {
                Vocab *temp = [[Vocab alloc] initWithLanguage:lang IDvocab:[db.ObjResult intForColumn:@"id"] Search:[db.ObjResult stringForColumn:@"esearch"] Entry:[db.ObjResult stringForColumn:@"eentry"] Cat:[db.ObjResult stringForColumn:@"ecat"] Synonym:[db.ObjResult stringForColumn:@"esyn"] Antonym:[db.ObjResult stringForColumn:@"eant"]];
                [ret addObject:temp];
            }
        }
        
    }
    else if(lang == LanguageENG){
        char first = [[vocab uppercaseString] characterAtIndex:0];
        NSString *tableName = [NSString  stringWithFormat:@"eng2th_%c",first];
        [db queryWithString:[NSString stringWithFormat:@"select IFNULL(id, '') as id, IFNULL(esearch, '') as esearch,IFNULL(eentry, '') as eentry,IFNULL(tentry, '') as tentry,IFNULL(ecat, '') as ecat,IFNULL(ethai, '') as ethai,IFNULL(esyn, '') as esyn,IFNULL(eant, '') as eant from %@ where esearch LIKE '%@%%' group by esearch order by id limit %d,%d",tableName,[vocab stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],index,index+50]];
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
    NSMutableArray *arraytype = [[NSMutableArray alloc] init];
    
    if (vocab.Language == LanguageTHA) {
        NSString *tableName;
        //  ก-ฮ  :  3585 - 3630  , สระ 3632-3676
        int ascii = [[vocab Search] characterAtIndex:0];
        if (ascii > 3584 && ascii < 3631) {
            tableName = [NSString  stringWithFormat:@"th2eng_%@",[[vocab Search] substringWithRange:NSMakeRange(0, 1)]];
        }
        else if(ascii > 3647 && ascii <3653){
            if ([[vocab Search] length]>1) {
                int asciix = [[vocab Search] characterAtIndex:1];
                if (asciix > 3584 && asciix < 3631) {
                    tableName = [NSString  stringWithFormat:@"th2eng_%@",[[vocab Search]substringWithRange:NSMakeRange(1, 1)]];
                }
            }
        }
        
        [db queryWithString:[NSString stringWithFormat:@"select IFNULL(id, '') as id, IFNULL(tsearch, '') as esearch,IFNULL(eentry, '') as eentry,IFNULL(tcat, '') as cat,IFNULL(tsyn, '') as esyn,IFNULL(tant, '') as eant,IFNULL(tsample, '') as sample from %@ where esearch like '%@' group by eentry order by tsearch",tableName,[vocab.Search stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
        int i =0;
        while([db.ObjResult next]) {
            NSString *cat = [db.ObjResult stringForColumn:@"cat"];
            Vocab *temp = [[Vocab alloc] initWithLanguage:LanguageTHA IDvocab:[db.ObjResult intForColumn:@"id"] Search:[db.ObjResult stringForColumn:@"esearch"] Entry:[db.ObjResult stringForColumn:@"eentry"] Cat:cat Synonym:[db.ObjResult stringForColumn:@"esyn"] Antonym:[db.ObjResult stringForColumn:@"eant"]];
            
            if (![[db.ObjResult stringForColumn:@"sample"] isEqualToString:@""] && [[db.ObjResult stringForColumn:@"sample"] length] != 0) {
                [temp setSample:[db.ObjResult stringForColumn:@"sample"]];
            }
            
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
        NSString *querySTR =[NSString stringWithFormat:@"select IFNULL(id, '') as id, IFNULL(esearch, '') as esearch,IFNULL(eentry, '') as eentry,IFNULL(tentry, '') as tentry,IFNULL(ecat, '') as cat,IFNULL(ethai, '') as ethai,IFNULL(esyn, '') as esyn,IFNULL(eant, '') as eant from %@ where esearch like '%@' group by tentry order by ecat",tableName,[vocab.Search stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [db queryWithString:querySTR];
        
        while([db.ObjResult next]) {
            NSString *cat = [db.ObjResult stringForColumn:@"cat"];
            Vocab *temp = [[Vocab alloc] initWithLanguage:LanguageENG IDvocab:[db.ObjResult intForColumn:@"id"] Search:[db.ObjResult stringForColumn:@"esearch"] Entry:[db.ObjResult stringForColumn:@"tentry"] Cat:cat Synonym:[db.ObjResult stringForColumn:@"esyn"] Antonym:[db.ObjResult stringForColumn:@"eant"]];
            [ret addObject:temp];
        }
        [db closeDB];
    }

    if ([ret count] == 1) {
        [ret2 addObject:ret];
    }
    //revise
    else{
        int i = 0;
        BOOL flag = YES;
        for (Vocab *v in ret) {
            if (i == 0) {
                flag = NO;
                i++;
            }else{
                for (NSString *type in arraytype) {
                    if (![v.Cat isEqualToString:type]) {
                        flag = NO;
                    }
                    else flag = YES;
                    continue;
                }

            }
            
            if (flag == NO) {
                [arraytype addObject:v.Cat];
                flag = YES;
            }
        }
        
        for (int i = 0 ; i<[arraytype count]; i++) {
            NSMutableArray *type = [[NSMutableArray alloc] init];
            for (int j = 0; j<[ret count] ; j++) {
                Vocab *v = [ret objectAtIndex:j];
                if ([v.Cat isEqualToString:[arraytype objectAtIndex:i]]) {
                    [type addObject:v];
                }
            }
            [ret2 addObject:type];
        }
        
    }
    return ret2;
}

+(NSMutableArray *)translateByExternal:(Vocab *)vocab{
    NSMutableArray *retrival = [[NSMutableArray alloc] init];

    NSError *error = nil;
    NSString *html = [Connect connectHtmlWithPath:[NSString stringWithFormat:@"http://dict.longdo.com/mobile.php?search=%@",[[vocab Search] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
    NSRange rang1 = [html rangeOfString:@"ศัพท์บัญญัติราชบัณฑิตยสถาน"];
    if (rang1.location != NSNotFound) {
        NSInteger start = rang1.location;
        NSInteger stop = html.length-start;
        NSRange finRang = NSMakeRange(start,stop);
        html = [html substringWithRange:finRang];
            
        HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
            
        if (error) {
            NSLog(@"Error: %@", error);
        }
            
        HTMLNode *bodyNode = [parser body];
            
        NSArray *tableNodes = [bodyNode findChildTags:@"table"];
        HTMLNode *SampleTable = [tableNodes objectAtIndex:0];
        NSArray *trNodes = [SampleTable findChildTags:@"td"];
        BOOL flag = NO;
        NSString *search;
        NSString *entry;
        NSMutableArray *retrive = [[NSMutableArray alloc] init];
            for (HTMLNode *n in trNodes) {
                if ([[n getAttributeNamed:@"width"] isEqualToString:@"40%"]) {
                    NSString *tmpSearch =[n.rawContents stripHtml];
                    search = tmpSearch;
                }
                else{
                    NSString *tmpEntry = [NSString stringWithFormat:@"%@ %@",search,[n.rawContents stripHtml]];
                    entry = tmpEntry;
                    flag = YES;
                }
                
                if (flag) {
                    Vocab *tmp = [[Vocab alloc] init];
                    [tmp setSearch:search];
                    [tmp setEntry:entry];
                    [tmp setLanguage:vocab.Language];
                    [tmp setCat:@"ศัพท์บัญญัติราชบัณฑิตยสถาน"];
                    [retrive addObject:tmp];
                    flag = NO;
                }
            }
        [retrival addObject:retrive];
    }
    if (retrival.count == 0) {
        NSRange rang1 = [html rangeOfString:@"Longdo Unapproved"];
        if (rang1.location != NSNotFound) {
            NSInteger start = rang1.location;
            NSInteger stop = html.length-start;
            NSRange finRang = NSMakeRange(start,stop);
            html = [html substringWithRange:finRang];
            
            HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
            
            if (error) {
                NSLog(@"Error: %@", error);
            }
            
            HTMLNode *bodyNode = [parser body];
            
            NSArray *tableNodes = [bodyNode findChildTags:@"table"];
            HTMLNode *SampleTable = [tableNodes objectAtIndex:0];
            NSArray *trNodes = [SampleTable findChildTags:@"td"];
            BOOL flag = NO;
            NSString *search;
            NSString *entry;
            NSMutableArray *retrive = [[NSMutableArray alloc] init];
            for (HTMLNode *n in trNodes) {
                if ([[n getAttributeNamed:@"width"] isEqualToString:@"40%"]) {
                    NSString *tmpSearch =[n.rawContents stripHtml];
                    search = tmpSearch;
                }
                else{
                    NSString *tmpEntry = [NSString stringWithFormat:@"%@ %@",search,[n.rawContents stripHtml]];
                    entry = tmpEntry;
                    flag = YES;
                }
                
                if (flag) {
                    Vocab *tmp = [[Vocab alloc] init];
                    [tmp setSearch:search];
                    [tmp setEntry:entry];
                    [tmp setLanguage:vocab.Language];
                    [tmp setCat:@"Longdo Unapproved"];
                    [retrive addObject:tmp];
                    flag = NO;
                }
            }
            [retrival addObject:retrive];
        }
    }
    if (retrival.count == 0) {
        NSRange rang1 = [html rangeOfString:@"พจนานุกรม ฉบับราชบัณฑิตยสถาน"];
        if (rang1.location != NSNotFound) {
            NSInteger start = rang1.location;
            NSInteger stop = html.length-start;
            NSRange finRang = NSMakeRange(start,stop);
            html = [html substringWithRange:finRang];
            
            HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
            
            if (error) {
                NSLog(@"Error: %@", error);
            }
            
            HTMLNode *bodyNode = [parser body];
            
            NSArray *tableNodes = [bodyNode findChildTags:@"table"];
            HTMLNode *SampleTable = [tableNodes objectAtIndex:0];
            NSArray *trNodes = [SampleTable findChildTags:@"td"];
            BOOL flag = NO;
            NSString *search;
            NSString *entry;
            NSMutableArray *retrive = [[NSMutableArray alloc] init];
            for (HTMLNode *n in trNodes) {
                if ([[n getAttributeNamed:@"width"] isEqualToString:@"40%"]) {
                    NSString *tmpSearch =[n.rawContents stripHtml];
                    search = tmpSearch;
                }
                else{
                    NSString *tmpEntry = [NSString stringWithFormat:@"%@ %@",search,[n.rawContents stripHtml]];
                    entry = tmpEntry;
                    flag = YES;
                }
                
                if (flag) {
                    Vocab *tmp = [[Vocab alloc] init];
                    [tmp setSearch:search];
                    [tmp setEntry:entry];
                    [tmp setLanguage:vocab.Language];
                    [tmp setCat:@"พจนานุกรม ฉบับราชบัณฑิตยสถาน พ.ศ. ๒๕๔๒"];
                    [retrive addObject:tmp];
                    flag = NO;
                }
            }
            [retrival addObject:retrive];
        }
    }
    
    
    
    return retrival;
}
#pragma mark load data from api server
-(BOOL)loadSound{
    NSString *path;
    if (self.Language == LanguageENG) {
        path = [APSpeech getSpeechThis:[self Search] inLanguage:APSpeechLanguageENG];
    }
    else{
        path = [APSpeech getSpeechThis:[self Search] inLanguage:APSpeechLanguageTHA];
    }
    
    if (![path isEqualToString:@"failed"]) {
        [self setSoundPath:path];
        return YES;
    }
    return NO;
}
-(BOOL)loadSampleENG{
    NSString *sample = [APSample SearchSample:[self Search]];
    if (![sample isEqualToString:@""] && sample.length != 0) {
        [self setSample:sample];
        return YES;
    }
    
    return NO;
}

@end
