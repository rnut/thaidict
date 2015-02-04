//
//  APSpeech.h
//
//  Created by alberto pasca on 10/04/13.
//  Copyright (c) 2013 albertopasca.it All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>
typedef enum {
  APSpeechStatusOk = 0,
  APSpeechStatusKo
} APSpeechStatus;

typedef enum {
  APSpeechLanguageTHA = 0,
  APSpeechLanguageENG,
  APSpeechLanguageFRE,
  APSpeechLanguageDEU,
  APSpeechLanguageESP,
  APSpeechLanguageITA,
} APSpeechLanguage;


@interface APSpeech : NSObject <AVAudioPlayerDelegate>

@property (nonatomic, assign) float Volume;
@property (nonatomic, assign) int   Loop;
@property(nonatomic,strong)  AVAudioPlayer *Player;
+ (NSString*) getSpeechThis:(NSString*)text inLanguage:(APSpeechLanguage)lang;
+(BOOL)deleteSpeech:(NSString*)speechName;
@end
