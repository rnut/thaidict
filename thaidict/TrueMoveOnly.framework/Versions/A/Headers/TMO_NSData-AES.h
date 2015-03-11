//
//  NSData-AES.h
//  Encryption
//
//  Created by Jeff LaMarche on 2/12/09.
//  Copyright 2009 Jeff LaMarche Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
// Supported keybit values are 128, 192, 256
#define KEYBITS		128					//256
#define AESEncryptionErrorDescriptionKey	@"description"

//    NSString * _iv;   

@interface NSData(TMO_AES)
 
- (void)_setInitialValue:(NSString*) val;
- (NSData *)AES128EncryptWithKey:(NSString *)key;
- (NSData *)AES128DecryptWithKey:(NSString *)key;
- (NSData *)AESEncryptWithPassphrase:(NSString *)pass;
- (NSData *)AESDecryptWithPassphrase:(NSString *)pass;
@end
