//
//  Favorite.h
//  TrueDict
//
//  Created by Rnut on 12/1/2557 BE.
//  Copyright (c) 2557 Rnut. All rights reserved.
//

#import "Vocab.h"

@interface Favorite : Vocab

@property(nonatomic,assign)int Fav_ID;
@property(nonatomic,strong)Vocab *Fav_vocab;

-(id)initWithVocab:(Vocab*)favWord;
-(BOOL)keepFavorite:(Vocab*)fav_vocab;
+(NSMutableArray *)listFavorite;
+(BOOL)checkExistanceOfFavWord:(NSString *) favword;
@end
