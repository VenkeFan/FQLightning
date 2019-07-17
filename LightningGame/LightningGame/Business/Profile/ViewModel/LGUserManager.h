//
//  LGUserManager.h
//  LightningGame
//
//  Created by fanqi_company on 2019/7/15.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kCardKeyNumber;
extern NSString * const kCardKeyName;
extern NSString * const kCardKeyLogo;
extern NSString * const kCardKeyCreatedTimestamp;
extern NSString * const kCardKeyBindID;
extern NSString * const kCardKeyUserID;

@interface LGUserManager : NSObject

+ (instancetype)manager;

@property (nonatomic, copy, readonly) NSArray *cardArray;

- (void)addCardNum:(NSString *)cardNum bankName:(NSString *)bankName completed:(void(^)(BOOL result))completed;
- (void)fetchUserBankListWithCompleted:(void(^)(BOOL result))completed;
- (void)withDrawWithCardID:(NSNumber *)cardID money:(NSInteger)money completed:(void(^)(BOOL result))completed;
- (void)modifyBirthday:(NSDate *)birthday success:(void(^)(NSString *newBirthday))success failure:(void(^)(void))failure;

@end

NS_ASSUME_NONNULL_END
