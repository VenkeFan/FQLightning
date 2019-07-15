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
@property (nonatomic, assign, readonly) BOOL isLogin;

- (void)fetchAccountInfoWithIntro:(NSDictionary *)intro;
- (void)signOut;

- (void)updateBirthday:(NSString *)birthday;

@end

NS_ASSUME_NONNULL_END
