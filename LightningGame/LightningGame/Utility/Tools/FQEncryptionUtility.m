//
//  FQEncryptionUtility.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/28.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "FQEncryptionUtility.h"

NSString * const kCommonCryptoErrorDomain = @"CommonCryptoErrorDomain";

static void FixKeyLengths(CCAlgorithm algorithm, NSMutableData *keyData, NSMutableData *ivData)
{
    NSUInteger keyLength = [keyData length];
    switch (algorithm)
    {
        case kCCAlgorithmAES128:
        {
            if (keyLength < 16)
            {
                [keyData setLength:16];
            }
            else if (keyLength < 24)
            {
                [keyData setLength:24];
            }
            else
            {
                [keyData setLength:32];
            }
            break;
        }
        case kCCAlgorithmDES:
        {
            [keyData setLength:8];
            break;
        }
        case kCCAlgorithm3DES:
        {
            [keyData setLength:24];
            break;
        }
        case kCCAlgorithmCAST:
        {
            if (keyLength < 5)
            {
                [keyData setLength:5];
            }
            else if (keyLength > 16)
            {
                [keyData setLength:16];
            }
            break;
        }
        case kCCAlgorithmRC4:
        {
            if (keyLength > 512)
            {
                [keyData setLength:512];
            }
            break;
        }
        default:
            break;
    }
    
    [ivData setLength:[keyData length]];
}

@implementation NSError (CommonCryptoErrorDomain)

+ (NSError *)errorWithCCCryptorStatus:(CCCryptorStatus)status {
    NSError *result = [NSError errorWithDomain:kCommonCryptoErrorDomain code:status userInfo:nil];
    return result;
}

@end

@implementation FQEncryptionUtility

+ (NSString *)md5Encode:(NSString *)source
{
    if ([source length] > 0)
    {
        NSString *sourceCopy = [source copy];
        const char *cStr = [sourceCopy UTF8String];
        unsigned char result[16];
        CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
        return [NSString stringWithFormat:
                @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                result[0], result[1], result[2], result[3],
                result[4], result[5], result[6], result[7],
                result[8], result[9], result[10], result[11],
                result[12], result[13], result[14], result[15]
                ];
    }
    
    return @"";
}

+ (NSData *)SHA1Hash:(NSData *)source
{
    if ([source length] <= 0) return nil;
    
    unsigned char hash[CC_SHA1_DIGEST_LENGTH];
    (void)CC_SHA1([source bytes], (CC_LONG)[source length], hash);
    return ([NSData dataWithBytes:hash length:CC_SHA1_DIGEST_LENGTH]);
}

+ (NSData *)SHA224Hash:(NSData *)source
{
    if ([source length] <= 0) return nil;
    
    unsigned char hash[CC_SHA224_DIGEST_LENGTH];
    (void)CC_SHA224([source bytes], (CC_LONG)[source length], hash);
    return ([NSData dataWithBytes:hash length:CC_SHA224_DIGEST_LENGTH]);
}

+ (NSData *)SHA256Hash:(NSData *)source
{
    if ([source length] <= 0) return nil;
    
    unsigned char hash[CC_SHA256_DIGEST_LENGTH];
    (void)CC_SHA256([source bytes], (CC_LONG)[source length], hash);
    return ([NSData dataWithBytes:hash length:CC_SHA256_DIGEST_LENGTH]);
}

+ (NSData *)SHA384Hash:(NSData *)source
{
    if ([source length] <= 0) return nil;
    
    unsigned char hash[CC_SHA384_DIGEST_LENGTH];
    (void)CC_SHA384([source bytes], (CC_LONG)[source length], hash);
    return ([NSData dataWithBytes:hash length:CC_SHA384_DIGEST_LENGTH]);
}

+ (NSData *)SHA512Hash:(NSData *)source
{
    if ([source length] <= 0) return nil;
    
    unsigned char hash[CC_SHA512_DIGEST_LENGTH];
    (void)CC_SHA512([source bytes], (CC_LONG)[source length], hash);
    return ([NSData dataWithBytes:hash length:CC_SHA512_DIGEST_LENGTH]);
}

+ (NSData *)AES256EncryptedData:(NSData *)source usingKey:(id)key error:(NSError **)error
{
    if ([source length] <= 0) return nil;
    
    CCCryptorStatus status = kCCSuccess;
    NSData *result = [self dataEncrypted:source
                          usingAlgorithm:kCCAlgorithmAES128
                                     key:key
                                 options:kCCOptionPKCS7Padding
                                   error:&status];
    
    if (result != nil) return result;
    if (error != NULL)
    {
        *error = [NSError errorWithCCCryptorStatus:status];
    }
    
    return nil;
}

+ (NSData *)decryptedAES256Data:(NSData *)source usingKey:(id)key error:(NSError **)error
{
    if ([source length] <= 0) return nil;
    
    CCCryptorStatus status = kCCSuccess;
    NSData *result = [self decryptedData:source
                          usingAlgorithm:kCCAlgorithmAES128
                                     key:key
                                 options:kCCOptionPKCS7Padding
                                   error:&status];
    
    if (result != nil) return result;
    if (error != NULL)
    {
        *error = [NSError errorWithCCCryptorStatus: status];
    }
    
    return nil;
}

+ (NSData *)DESEncryptedData:(NSData *)source usingKey:(id)key error:(NSError **)error
{
    if ([source length] <= 0) return nil;
    
    CCCryptorStatus status = kCCSuccess;
    NSData *result = [self dataEncrypted:source
                          usingAlgorithm:kCCAlgorithmDES
                                     key:key
                                 options:kCCOptionPKCS7Padding
                                   error:&status];
    
    if (result != nil) return result;
    if (error != NULL)
    {
        *error = [NSError errorWithCCCryptorStatus: status];
    }
    
    return ( nil );
}

+ (NSData *)decryptedDESData:(NSData *)source usingKey:(id)key error:(NSError **)error
{
    if ([source length] <= 0) return nil;
    
    CCCryptorStatus status = kCCSuccess;
    NSData *result = [self decryptedData:source
                          usingAlgorithm:kCCAlgorithmDES
                                     key:key
                                 options:kCCOptionPKCS7Padding
                                   error:&status];
    
    if (result != nil) return result;
    if (error != NULL)
    {
        *error = [NSError errorWithCCCryptorStatus: status];
    }
    
    return nil;
}

+ (NSData *)CASTEncryptedData:(NSData *)source usingKey:(id)key error:(NSError **)error
{
    if ([source length] <= 0) return nil;
    
    CCCryptorStatus status = kCCSuccess;
    NSData *result = [self dataEncrypted:source
                          usingAlgorithm:kCCAlgorithmCAST
                                     key:key
                                 options:kCCOptionPKCS7Padding
                                   error:&status];
    
    if (result != nil) return result;
    if (error != NULL)
    {
        *error = [NSError errorWithCCCryptorStatus: status];
    }
    
    return nil;
}

+ (NSData *)decryptedCASTData:(NSData *)source usingKey:(id)key error:(NSError **)error
{
    if ([source length] <= 0) return nil;
    
    CCCryptorStatus status = kCCSuccess;
    NSData *result = [self decryptedData:source
                          usingAlgorithm:kCCAlgorithmCAST
                                     key:key
                                 options:kCCOptionPKCS7Padding
                                   error:&status];
    
    if (result != nil) return result;
    if (error != NULL)
    {
        *error = [NSError errorWithCCCryptorStatus: status];
    }
    
    return nil;
}

+ (NSData *)runCryptor:(CCCryptorRef)cryptor data:(NSData *)data result:(CCCryptorStatus *)status
{
    if ([data length] <= 0) return nil;
    
    size_t bufsize = CCCryptorGetOutputLength(cryptor, (size_t)[data length], true);
    void * buf = malloc(bufsize);
    size_t bufused = 0;
    size_t bytesTotal = 0;
    *status = CCCryptorUpdate(cryptor, [data bytes], (size_t)[data length], buf, bufsize, &bufused);
    if (*status != kCCSuccess)
    {
        free(buf);
        return nil;
    }
    
    bytesTotal += bufused;
    
    *status = CCCryptorFinal(cryptor, buf + bufused, bufsize - bufused, &bufused);
    if (*status != kCCSuccess)
    {
        free(buf);
        return nil;
    }
    
    bytesTotal += bufused;
    
    return ([NSData dataWithBytesNoCopy:buf length:bytesTotal]);
}

+ (NSData *)dataEncrypted:(NSData *)source
           usingAlgorithm:(CCAlgorithm)algorithm
                      key:(id)key
                    error:(CCCryptorStatus *)error
{
    return ([self dataEncrypted:source
                 usingAlgorithm:algorithm
                            key:key
           initializationVector:nil
                        options:0
                          error:error]);
}

+ (NSData *)dataEncrypted:(NSData *)source
           usingAlgorithm:(CCAlgorithm)algorithm
                      key:(id)key
                  options:(CCOptions)options
                    error:(CCCryptorStatus *)error
{
    return ([self dataEncrypted:source
                 usingAlgorithm:algorithm
                            key:key
           initializationVector:nil
                        options:options
                          error:error]);
}

+ (NSData *)dataEncrypted:(NSData *)source
           usingAlgorithm:(CCAlgorithm)algorithm
                      key:(id)key
     initializationVector:(id)iv
                  options:(CCOptions)options
                    error:(CCCryptorStatus *)error
{
    if ([source length] <= 0) return nil;
    
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = kCCSuccess;
    
    NSParameterAssert([key isKindOfClass:[NSData class]] || [key isKindOfClass:[NSString class]]);
    NSParameterAssert(iv == nil || [iv isKindOfClass:[NSData class]] || [iv isKindOfClass:[NSString class]]);
    
    NSMutableData *keyData = nil;
    NSMutableData *ivData = nil;
    
    if ([key isKindOfClass:[NSData class]])
    {
        keyData = (NSMutableData *)[key mutableCopy];
    }
    else
    {
        keyData = [[key dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    }
    
    if ([iv isKindOfClass:[NSString class]])
    {
        ivData = [[iv dataUsingEncoding: NSUTF8StringEncoding] mutableCopy];
    }
    else
    {
        ivData = (NSMutableData *)[iv mutableCopy];
    }
    
    FixKeyLengths(algorithm, keyData, ivData);
    
    status = CCCryptorCreate(kCCEncrypt, algorithm, options,
                             [keyData bytes], [keyData length], [ivData bytes],
                             &cryptor);
    if (status != kCCSuccess)
    {
        if (error != NULL)
        {
            *error = status;
        }
        return nil;
    }
    
    NSData * result = [FQEncryptionUtility runCryptor:cryptor data:source result:&status];
    if ((result == nil) && (error != NULL))
    {
        *error = status;
    }
    
    CCCryptorRelease(cryptor);
    return result;
}

+ (NSData *)decryptedData:(NSData *)source
           usingAlgorithm:(CCAlgorithm)algorithm
                      key:(id)key
                    error:(CCCryptorStatus *)error
{
    return ([self decryptedData:source
                 usingAlgorithm:algorithm
                            key:key
           initializationVector:nil
                        options:0
                          error:error]);
}

+ (NSData *)decryptedData:(NSData *)source
           usingAlgorithm:(CCAlgorithm)algorithm
                      key:(id)key
                  options:(CCOptions)options
                    error:(CCCryptorStatus *)error
{
    return ([self decryptedData:source
                 usingAlgorithm:algorithm
                            key:key
           initializationVector:nil
                        options:options
                          error:error]);
}

+ (NSData *)decryptedData:(NSData *)source
           usingAlgorithm:(CCAlgorithm)algorithm
                      key:(id)key
     initializationVector:(id)iv
                  options:(CCOptions)options
                    error:(CCCryptorStatus *)error
{
    if ([source length] <= 0) return nil;
    
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = kCCSuccess;
    
    NSParameterAssert([key isKindOfClass:[NSData class]] || [key isKindOfClass:[NSString class]]);
    NSParameterAssert(iv == nil || [iv isKindOfClass:[NSData class]] || [iv isKindOfClass:[NSString class]]);
    
    NSMutableData *keyData = nil;
    NSMutableData *ivData = nil;
    
    if ([key isKindOfClass:[NSData class]])
    {
        keyData = (NSMutableData *)[key mutableCopy];
    }
    else
    {
        keyData = [[key dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    }
    
    if ([iv isKindOfClass:[NSString class]])
    {
        ivData = [[iv dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    }
    else
    {
        ivData = (NSMutableData *)[iv mutableCopy];
    }
    
    FixKeyLengths(algorithm, keyData, ivData);
    
    status = CCCryptorCreate(kCCDecrypt, algorithm, options,
                             [keyData bytes], [keyData length], [ivData bytes],
                             &cryptor);
    if (status != kCCSuccess)
    {
        if (error != NULL)
        {
            *error = status;
        }
        return nil;
    }
    
    NSData *result = [FQEncryptionUtility runCryptor:cryptor data:source result:&status];
    if ((result == nil) && (error != NULL))
    {
        *error = status;
    }
    
    CCCryptorRelease(cryptor);
    return result;
}

+ (NSData *)HMAC:(NSData *)source withAlgorithm:(CCHmacAlgorithm)algorithm
{
    if ([source length] <= 0) return nil;
    
    return ([FQEncryptionUtility HMAC:source withAlgorithm:algorithm key:nil]);
}

+ (NSData *)HMAC:(NSData *)source withAlgorithm:(CCHmacAlgorithm)algorithm key:(id)key
{
    if ([source length] <= 0) return nil;
    
    NSParameterAssert(key == nil || [key isKindOfClass:[NSData class]] || [key isKindOfClass:[NSString class]]);
    
    NSData * keyData = nil;
    if ([key isKindOfClass:[NSString class]])
    {
        keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    }
    else
    {
        keyData = (NSData *)key;
    }
    
    unsigned char buf[CC_SHA1_DIGEST_LENGTH];
    CCHmac(algorithm, [keyData bytes], [keyData length], [source bytes], [source length], buf);
    
    return ([NSData dataWithBytes:buf length:(algorithm == kCCHmacAlgMD5 ? CC_MD5_DIGEST_LENGTH : CC_SHA1_DIGEST_LENGTH)]);
}

@end
