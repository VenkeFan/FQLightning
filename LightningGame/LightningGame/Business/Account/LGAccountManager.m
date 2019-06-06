//
//  LGAccountManager.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/5.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGAccountManager.h"
#import "LGAccountKeys.h"

#pragma mark - AccountKeys

NSString * const kAccountKeyAccountID                   = @"openid";
NSString * const kAccountKeyAccountAccessToken          = @"access_token";
NSString * const kAccountKeyAccountExpireInterval       = @"expires_in";

#pragma mark - LGAccountManager

@interface LGAccountManager ()

@property (nonatomic, copy) NSString *filePath;

@end

@implementation LGAccountManager

+ (instancetype)instance {
    static LGAccountManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [LGAccountManager instance];
}

- (instancetype)init {
    if (self = [super init]) {
        _account = [NSDictionary dictionaryWithContentsOfFile:self.filePath];
    }
    return self;
}

- (void)updateAccount:(NSDictionary *)newAccount {
    _account = [newAccount copy];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:self.filePath error:nil];
    }
    
    [newAccount writeToFile:self.filePath atomically:NO];
}

- (void)signOut {
    _account = nil;
    
    [[NSFileManager defaultManager] removeItemAtPath:self.filePath error:nil];
}

#pragma mark - Getter

- (NSString *)filePath {
    if (!_filePath) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        _filePath = [path stringByAppendingPathComponent:@"account_info.plist"];
    }
    return _filePath;
}

@end
