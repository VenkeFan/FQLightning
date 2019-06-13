//
//  NSDictionary+FQExtension.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/12.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (FQExtension)

+ (NSDictionary *)dictionaryWithJSON:(id)json;
- (NSMutableDictionary *)fq_mutableDictionary;

@end

NS_ASSUME_NONNULL_END
