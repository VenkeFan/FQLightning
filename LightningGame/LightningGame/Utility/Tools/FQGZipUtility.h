//
//  FQGZipUtility.h
//  LightningGame
//
//  Created by fanqi_company on 2019/5/28.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FQGZipUtility : NSObject

+ (NSData *)gzipInflate:(NSData *)data;
+ (NSData *)gzipDeflate:(NSData *)data;
+ (NSData *)gzipInflate2:(NSData *)data;
+ (NSData *)gzipDeflate2:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
