//
//  FQFileManagerUtility.h
//  FQWidgets
//
//  Created by fan qi on 2019/5/28.
//  Copyright © 2019 fan qi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FQFileManagerUtility : NSObject

// 文件系统方法(非线程安全)
+ (void)createDirectory:(NSString *)path;
+ (void)removeFilesInPath:(NSString *)path;
+ (void)removeFile:(NSString *)path;
+ (size_t)archiver:(id<NSCoding>)obj withKey:(NSString *)key toPath:(NSString *)path;
+ (id)unarchiverWithKey:(NSString *)key fromPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
