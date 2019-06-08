//
//  CTMediator+LGSignActions.m
//  LightningGame_Modularization
//
//  Created by fanqi_company on 2019/6/7.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "CTMediator+LGSignActions.h"

NSString * const kLGMediatorTargetSignIn = @"SignIn";

NSString * const kLGMediatorActionNativeGenerateSignInController = @"nativeGenerateSignInController";

@implementation CTMediator (LGSignActions)

- (UIViewController *)mediator_generateSignInController {
    UIViewController *viewController = [self performTarget:kLGMediatorTargetSignIn
                                                    action:kLGMediatorActionNativeGenerateSignInController
                                                    params:@{@"testKey": @"testValue"}
                                         shouldCacheTarget:NO];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        return viewController;
    }
    
    return nil;
}

@end
