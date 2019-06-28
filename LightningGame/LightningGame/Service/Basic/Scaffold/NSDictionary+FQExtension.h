//
//  NSDictionary+FQExtension.h
//  FQWidgets
//
//  Created by fan qi on 2019/6/12.
//  Copyright © 2019 fan qi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (FQExtension)

+ (NSDictionary *)dictionaryWithJSON:(id)json;
- (NSMutableDictionary *)fq_mutableDictionary;

@end

NS_ASSUME_NONNULL_END
