//
//  Vocab.h
//  DemoSqlite
//
//  Created by Rnut on 11/25/2557 BE.
//  Copyright (c) 2557 Rnut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DB.h"
#import "APSpeech.h"
#import "APSample.h"
#import "Language.h"
@interface Vocab : NSObject




//typedef enum {
//    LanguageTHA,
//    LanguageENG
//} DictLanguage;

@property(nonatomic,assign)DictLanguage Language;
@property int IDvocab;
@property(nonatomic,strong)NSString *Search;
@property(nonatomic,strong)NSString *Entry;
@property(nonatomic,strong)NSString *Cat;
@property(nonatomic,strong)NSString *Synonym; //คำเหมือน
@property(nonatomic,strong)NSString *Antonym; //คำตรงข้าม
@property(nonatomic,strong)NSString *SoundPath;
@property(nonatomic,strong)NSString *ImgPath;
@property(nonatomic,strong)NSString *Sample;



-(id)initWithLanguage:(DictLanguage)lang IDvocab:(int)idvocab Search :(NSString *)strsearch Entry:(NSString *)strentry Cat:(NSString*)strcat Synonym:(NSString*)strsyn Antonym:(NSString*)strant;
//
//-(id)initWithID:(NSInteger *)stridVocab Esearch :(NSString *)stresearch Eentry:(NSString *)streentry Tentry:(NSString *)strtentry Ecat:(NSString*)strecat Ethai:(NSString*)strethai Esyn:(NSString*)stresyn Eant:(NSString*)streant;


+(NSMutableArray *)listDictByVocab:(NSString *)vocab;

+(NSMutableArray *)translateVocab:(Vocab *)vocab;
+(NSMutableArray *)translateByExternal:(Vocab *)vocab;
//getData form api server
-(BOOL)loadSound;
-(BOOL)loadSampleENG;
//-(BOOL)loadImageWithAPIPath:(NSString *)path;

@end
