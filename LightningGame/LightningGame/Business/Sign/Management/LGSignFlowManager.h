//
//  LGSignFlowManager.h
//  LightningGame
//
//  Created by fanqi_company on 2019/6/6.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LGSignFlowStep) {
    LGSignFlowStep_Splash,
    LGSignFlowStep_SignIn_Auto,
    LGSignFlowStep_SignIn_Manual,
    LGSignFlowStep_SignUp,
    LGSignFlowStep_ModifyPassword,
    LGSignFlowStep_Visitor,
    LGSignFlowStep_Home
};

NS_ASSUME_NONNULL_BEGIN

@protocol LGSignFlowManagerDelegate <NSObject>

- (void)signFlowManagerStepping:(LGSignFlowStep)step;

@end

@interface LGSignFlowManager : NSObject

+ (instancetype)instance;

@property (nonatomic, assign, readonly) LGSignFlowStep flowStep;

- (void)addListener:(id<LGSignFlowManagerDelegate>)listener;
- (void)removeListener:(id<LGSignFlowManagerDelegate>)listener;
- (void)removeAllListeners;

- (void)fetchVerifyCode:(NSString *)mobile;
- (void)signUpWithAccountName:(NSString *)accountName
                          pwd:(NSString *)pwd
                         name:(NSString *)name
                       mobile:(NSString *)mobile
                   verifyCode:(NSString *)verifyCode;
- (void)signInWithAccountName:(NSString *)accountName
                          pwd:(NSString *)pwd;
- (void)modifyPassword:(NSString *)newPwd
                mobile:(NSString *)mobile
            verifyCode:(NSString *)verifyCode;
- (void)signOut;

+ (BOOL)proofreadAccountName:(NSString *)accountName;
+ (BOOL)proofreadPassword:(NSString *)password;
+ (BOOL)proofreadPassword:(NSString *)password confirmPwd:(NSString *)confirmPwd;
+ (BOOL)proofreadName:(NSString *)name;
+ (BOOL)proofreadMobile:(NSString *)mobile;
+ (BOOL)proofreadVerifyCode:(NSString *)verifyCode;

@end

NS_ASSUME_NONNULL_END
