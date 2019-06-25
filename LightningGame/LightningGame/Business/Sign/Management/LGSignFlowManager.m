//
//  LGSignFlowManager.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/6.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGSignFlowManager.h"
#import "LGAccountManager.h"
#import "LGVerifyCodeRequest.h"
#import "LGSignUpRequest.h"
#import "LGSignInRequest.h"
#import "LGOAuthRequest.h"
#import "LGForgetPwdRequest.h"

@interface LGSignFlowManager ()

@property (nonatomic, assign, readwrite) LGSignFlowStep flowStep;
@property (nonatomic, strong) NSPointerArray *listenerArray;

@property (nonatomic, copy) NSString *accountName;
@property (nonatomic, copy) NSString *password;

@end

@implementation LGSignFlowManager

+ (instancetype)instance {
    static LGSignFlowManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [LGSignFlowManager instance];
}

- (instancetype)init {
    if (self = [super init]) {
        _flowStep = LGSignFlowStep_Splash;
    }
    return self;
}

#pragma mark - Public

- (void)addListener:(id<LGSignFlowManagerDelegate>)listener {
    [self.listenerArray addPointer:(void *)listener];
}

- (void)removeListener:(id<LGSignFlowManagerDelegate>)listener {
    for (NSInteger i = self.listenerArray.count - 1; i >= 0; i--) {
        if ([listener isEqual:[self.listenerArray pointerAtIndex:i]]) {
            [self.listenerArray removePointerAtIndex:i];
            return;
        }
    }
}

- (void)removeAllListeners {
    for (NSInteger i = self.listenerArray.count - 1; i >= 0; i--) {
        [self.listenerArray removePointerAtIndex:i];
    }
}

- (void)fetchVerifyCode:(NSString *)mobile {
    if (![LGSignFlowManager proofreadMobile:mobile]) {
        return;
    }
    
    LGVerifyCodeRequest *request = [LGVerifyCodeRequest new];
    [request requestWithMobile:mobile
                       success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                           
                       }
                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           [self broadcastFailure:error];
                       }];
}

- (void)signUpWithAccountName:(NSString *)accountName
                          pwd:(NSString *)pwd
                         name:(NSString *)name
                       mobile:(NSString *)mobile
                   verifyCode:(NSString *)verifyCode {
    self.accountName = accountName;
    self.password = pwd;
    
    [LGLoadingView display];
    LGSignUpRequest *request = [LGSignUpRequest new];
    [request requestWithAccountName:accountName
                                pwd:pwd
                               name:name
                             mobile:mobile
                         verifyCode:verifyCode
                            success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                                [self setFlowStep:LGSignFlowStep_SignUp];
                            }
                            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                [self broadcastFailure:error];
                            }];
}

- (void)signInWithAccountName:(NSString *)accountName
                          pwd:(NSString *)pwd {
    [LGLoadingView display];
    LGSignInRequest *request = [LGSignInRequest new];
    [request requestWithAccountName:accountName
                                pwd:pwd
                            success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                                [[LGAccountManager instance] fetchAccountInfoWithIntro:responseObject];
                                [self setFlowStep:LGSignFlowStep_SignIn_Manual];
                            }
                            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                [self broadcastFailure:error];
                            }];
}

- (void)oAuthorize {
    if ([LGAccountManager instance].account[kAccountKeyAccountAccessToken] == nil) {
        [self broadcastFailure:nil];
        return;
    }
    
    LGOAuthRequest *request = [LGOAuthRequest new];
    [request requestWithAccessToken:[LGAccountManager instance].account[kAccountKeyAccountAccessToken]
                            success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                                [[LGAccountManager instance] fetchAccountInfoWithIntro:responseObject];
                                [self setFlowStep:LGSignFlowStep_OAuth];
                            }
                            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                [self broadcastFailure:error];
                            }];
}

- (void)modifyPassword:(NSString *)newPwd mobile:(NSString *)mobile verifyCode:(NSString *)verifyCode {
    LGForgetPwdRequest *request = [LGForgetPwdRequest new];
    [request requestWithMobile:mobile
                        newPwd:newPwd
                    verifyCode:verifyCode
                       success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                           [self setFlowStep:LGSignFlowStep_ModifyPassword];
                       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           [self broadcastFailure:error];
                       }];
}

- (void)signOut {
    [[LGAccountManager instance] signOut];
}

- (void)visit {
    [self setFlowStep:LGSignFlowStep_Visitor];
}

+ (BOOL)proofreadAccountName:(NSString *)accountName {
    if (accountName.length < 6 || accountName.length > 16) {
        [LGToastView showWithMessage:@"账号格式错误"];
        return NO;
    }
    return YES;
}

+ (BOOL)proofreadPassword:(NSString *)password {
    if (password.length < 6 || password.length > 16) {
        [LGToastView showWithMessage:@"密码格式错误"];
        return NO;
    }
    return YES;
}
+ (BOOL)proofreadPassword:(NSString *)password confirmPwd:(NSString *)confirmPwd {
    if (![LGSignFlowManager proofreadPassword:password] || ![LGSignFlowManager proofreadPassword:confirmPwd]) {
        return NO;
    }
    if (![password isEqualToString:confirmPwd]) {
        [LGToastView showWithMessage:@"二次密码不一致"];
        return NO;
    }
    return YES;
}

+ (BOOL)proofreadName:(NSString *)name {
    if (name.length == 0) {
        [LGToastView showWithMessage:@"姓名格式错误"];
        return NO;
    }
    return YES;
}

+ (BOOL)proofreadMobile:(NSString *)mobile {
    if (mobile.length == 0) {
        [LGToastView showWithMessage:@"手机号格式错误"];
        return NO;
    }
    return YES;
}

+ (BOOL)proofreadVerifyCode:(NSString *)verifyCode {
    if (verifyCode.length == 0) {
        [LGToastView showWithMessage:@"验证码格式错误"];
        return NO;
    }
    return YES;
}

#pragma mark - Private

- (void)setFlowStep:(LGSignFlowStep)flowStep {
    _flowStep = flowStep;
    
    switch (flowStep) {
        case LGSignFlowStep_Splash:
            
            break;
        case LGSignFlowStep_SignUp:
            [self nextStep:LGSignFlowStep_SignIn_Auto];
            break;
        case LGSignFlowStep_SignIn_Auto:
            [self nextStep:LGSignFlowStep_Home];
            break;
        case LGSignFlowStep_SignIn_Manual:
            [self nextStep:LGSignFlowStep_Home];
            break;
        case LGSignFlowStep_OAuth:
            [self nextStep:LGSignFlowStep_Home];
            break;
        case LGSignFlowStep_ModifyPassword:
            [self nextStep:LGSignFlowStep_SignIn_Manual];
            break;
        case LGSignFlowStep_Visitor:
            [self nextStep:LGSignFlowStep_Home];
            break;
        case LGSignFlowStep_Home:
            
            break;
    }
}

- (void)nextStep:(LGSignFlowStep)step {
    switch (step) {
        case LGSignFlowStep_SignIn_Auto: {
            [self signInWithAccountName:self.accountName pwd:self.password];
        }
            break;
        case LGSignFlowStep_SignIn_Manual: {
            [self broadcast:step];
        }
            break;
        case LGSignFlowStep_Home: {
            [LGLoadingView dismiss];
            [self broadcast:step];
        }
            break;
        default:
            break;
    }
}

- (void)broadcast:(LGSignFlowStep)step {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSInteger i = self.listenerArray.count - 1; i >= 0; i--) {
            id delegate = [self.listenerArray pointerAtIndex:i];
            if ([delegate respondsToSelector:@selector(signFlowManagerStepping:)]) {
                [delegate signFlowManagerStepping:step];
            }
        }
    });
}

- (void)broadcastFailure:(NSError *)error {
    [LGLoadingView dismiss];
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSInteger i = self.listenerArray.count - 1; i >= 0; i--) {
            id delegate = [self.listenerArray pointerAtIndex:i];
            if ([delegate respondsToSelector:@selector(signFlowManagerFailed:)]) {
                [delegate signFlowManagerFailed:error];
            }
        }
    });
}

#pragma mark - Getter

- (NSPointerArray *)listenerArray {
    if (!_listenerArray) {
        _listenerArray = [NSPointerArray weakObjectsPointerArray];
    }
    return _listenerArray;
}

@end
