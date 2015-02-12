//
//  Favorite.h
//  TrueDict
//
//  Created by Rnut on 12/1/2557 BE.
//  Copyright (c) 2557 Rnut. All rights reserved.
//

#import "Vocab.h"
#import "Language.h"
@interface Favorite : Vocab

@property(nonatomic,assign)int Fav_ID;
@property(nonatomic,strong)Vocab *Fav_vocab;


+(NSMutableArray *)listFavorite;

+(BOOL)deleteFavorite:(Favorite *)favVocab;
-(int)getFavIDLastRecordOfLang : (DictLanguage)lang;

-(id)initWithVocab:(Vocab*)favWord FAVID:(int)id_fav;
-(BOOL)keepFavorite:(Vocab*)fav_vocab;
-(BOOL)checkExistanceOfFavWord;


+(BOOL)favoriteVocabForReorder:(Vocab*)vocab;
+(BOOL)reOrderFav:(NSMutableArray *)arrayFav;
@end
