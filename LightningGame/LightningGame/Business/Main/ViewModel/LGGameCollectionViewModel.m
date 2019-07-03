//
//  LGGameCollectionViewModel.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/3.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGGameCollectionViewModel.h"
#import "LGGameListKeys.h"
#import "LGGameListRequest.h"
#import "NSDictionary+FQExtension.h"

NSString * const kGameKeyID                 = @"id";
NSString * const kGameKeyLogo               = @"logo";
NSString * const kGameKeyName               = @"name";
NSString * const kGameKeyShortName          = @"short_name";
NSString * const kGameKeyTodayNumber        = @"today";
NSString * const kGameKeyPrepareNumber      = @"early";
NSString * const kGameKeyRollingNumber      = @"live";
NSString * const kGameKeyIsSelected         = @"is_selected";

@implementation LGGameCollectionViewModel

- (void)fetchGameList {
    LGGameListRequest *request = [LGGameListRequest new];
    [request requestWithSuccess:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray *arrayI = (NSArray *)responseObject;
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:arrayI.count];
        [arrayI enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *dic = [obj fq_mutableDictionary];
            [arrayM addObject:dic];
        }];
        
        if ([self.delegate respondsToSelector:@selector(gameListDidFetch:data:error:)]) {
            [self.delegate gameListDidFetch:self data:arrayM error:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(gameListDidFetch:data:error:)]) {
            [self.delegate gameListDidFetch:self data:nil error:error];
        }
    }];
}

@end
