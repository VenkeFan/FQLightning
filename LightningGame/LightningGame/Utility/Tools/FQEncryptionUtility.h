//
//  FQEncryptionUtility.h
//  LightningGame
//
//  Created by fanqi_company on 2019/5/28.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

@interface NSError (CommonCryptoErrorDomain)

+ (NSError *)errorWithCCCryptorStatus:(CCCryptorStatus)status;

@end

@interface FQEncryptionUtility : NSObject

+ (NSString *)md5Encode:(NSString *)source;
+ (NSData *)SHA1Hash:(NSData *)source;
+ (NSData *)SHA224Hash:(NSData *)source;
+ (NSData *)SHA256Hash:(NSData *)source;
+ (NSData *)SHA384Hash:(NSData *)source;
+ (NSData *)SHA512Hash:(NSData *)source;

+ (NSData *)AES256EncryptedData:(NSData *)source usingKey:(id)key error:(NSError **)error;
+ (NSData *)decryptedAES256Data:(NSData *)source usingKey:(id)key error:(NSError **)error;
+ (NSData *)DESEncryptedData:(NSData *)source usingKey:(id)key error:(NSError **)error;
+ (NSData *)decryptedDESData:(NSData *)source usingKey:(id)key error:(NSError **)error;
+ (NSData *)CASTEncryptedData:(NSData *)source usingKey:(id)key error:(NSError **)error;
+ (NSData *)decryptedCASTData:(NSData *)source usingKey:(id)key error:(NSError **)error;

+ (NSData *)dataEncrypted:(NSData *)source
           usingAlgorithm:(CCAlgorithm)algorithm
                      key:(id)key
                    error:(CCCryptorStatus *)error;
+ (NSData *)dataEncrypted:(NSData *)source
           usingAlgorithm:(CCAlgorithm)algorithm
                      key:(id)key
                  options:(CCOptions)options
                    error:(CCCryptorStatus *)error;
+ (NSData *)dataEncrypted:(NSData *)source
           usingAlgorithm:(CCAlgorithm)algorithm
                      key:(id)key
     initializationVector:(id)iv
                  options:(CCOptions)options
                    error:(CCCryptorStatus *)error;
+ (NSData *)decryptedData:(NSData *)source
           usingAlgorithm:(CCAlgorithm)algorithm
                      key:(id)key
                    error:(CCCryptorStatus *)error;
+ (NSData *)decryptedData:(NSData *)source
           usingAlgorithm:(CCAlgorithm)algorithm
                      key:(id)key
                  options:(CCOptions)options
                    error:(CCCryptorStatus *)error;
+ (NSData *)decryptedData:(NSData *)source
           usingAlgorithm:(CCAlgorithm)algorithm
                      key:(id)key
     initializationVector:(id)iv
                  options:(CCOptions)options
                    error:(CCCryptorStatus *)error;

+ (NSData *)HMAC:(NSData *)source withAlgorithm:(CCHmacAlgorithm)algorithm;
+ (NSData *)HMAC:(NSData *)source withAlgorithm:(CCHmacAlgorithm)algorithm key:(id)key;

@end
