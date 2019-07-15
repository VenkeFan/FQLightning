//
//  LGUserManager.h
//  LightningGame
//
//  Created by fanqi_company on 2019/7/15.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGUserManager : NSObject

+ (instancetype)manager;

- (void)modifyBirthday:(NSDate *)birthday success:(void(^)(NSString *newBirthday))success failure:(void(^)(void))failure;

@end

NS_ASSUME_NONNULL_END
