//
//  NSDictionary+FQExtension.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/12.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "NSDictionary+FQExtension.h"

@implementation NSDictionary (FQExtension)

- (NSMutableDictionary *)fq_mutableDictionary {
    NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithDictionary:self];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSMutableArray *tmpArrayM = [obj mutableCopy];
            [dicM setObject:tmpArrayM forKey:key];
            
            [self p_handleArray:(NSArray *)obj arrayM:tmpArrayM];
            
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *tmpDicM = [obj mutableCopy];
            [dicM setObject:tmpDicM forKey:key];
            
            [self p_handleDictionary:(NSDictionary *)obj dicM:tmpDicM];
        }
    }];
    
    return dicM;
}

- (void)p_handleArray:(NSArray *)arrayI arrayM:(NSMutableArray *)arrayM {
    [arrayI enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSMutableArray *tmpArrayM = [obj mutableCopy];
            [arrayM replaceObjectAtIndex:idx withObject:tmpArrayM];
            
            [self p_handleArray:(NSArray *)obj arrayM:tmpArrayM];
            
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *tmpDicM = [obj mutableCopy];
            [arrayM replaceObjectAtIndex:idx withObject:tmpDicM];
            
            [self p_handleDictionary:(NSDictionary *)obj dicM:tmpDicM];
        }
    }];
}

- (void)p_handleDictionary:(NSDictionary *)dicI dicM:(NSMutableDictionary *)dicM {
    [dicI enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSMutableArray *tmpArrayM = [obj mutableCopy];
            [dicM setObject:tmpArrayM forKey:key];
            
            [self p_handleArray:(NSArray *)obj arrayM:tmpArrayM];
            
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *tmpDicM = [obj mutableCopy];
            [dicM setObject:tmpDicM forKey:key];
            
            [self p_handleDictionary:(NSDictionary *)obj dicM:tmpDicM];
        }
    }];
}

@end
