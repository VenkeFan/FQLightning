//
//  FQFileManagerUtility.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/28.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "FQFileManagerUtility.h"

@implementation FQFileManagerUtility

+ (void)createDirectory:(NSString *)path {
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

+ (void)removeFilesInPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *filesArray = [fileManager contentsOfDirectoryAtPath:path error:nil];
    if (filesArray) {
        for (NSString* fileName in filesArray) {
            NSString *filePath = [path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:filePath error:nil];
        }
    }
}

+ (void)removeFile:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
    }
}

+ (size_t)archiver:(id<NSCoding>)obj withKey:(NSString *)key toPath:(NSString *)path {
    NSString *directory = [path stringByDeletingLastPathComponent];
    [FQFileManagerUtility removeFile:path];
    [FQFileManagerUtility createDirectory:directory];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    @try {
        [archiver encodeObject:obj forKey:key];
        [archiver finishEncoding];
    }
    @catch (NSException *exception) {
        return 0;
    }
    
    if (![data writeToFile:path atomically:YES]) {
        return 0;
    }
    
    return [data length];
}

+ (id)unarchiverWithKey:(NSString *)key fromPath:(NSString *)path {
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) return nil;
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    id obj = nil;
    
    @try {
        obj = [unarchiver decodeObjectForKey:key];
        [unarchiver finishDecoding];
    }
    @catch (NSException *exception) {
        return nil;
    }
    
    return obj;
}

@end
