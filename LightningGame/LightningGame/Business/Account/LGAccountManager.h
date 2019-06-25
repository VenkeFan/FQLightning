//
//  LGAccountManager.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/5.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGAccountKeys.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGAccountManager : NSObject

+ (instancetype)instance;

@property (nonatomic, copy, readonly) NSDictionary *account;

- (void)fetchAccountInfoWithIntro:(NSDictionary *)intro;
- (void)updateLocalAccount:(NSDictionary *)newAccount;
- (void)signOut;

@end

NS_ASSUME_NONNULL_END
