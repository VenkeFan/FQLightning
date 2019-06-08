//
//  CTMediator+LGMainActions.m
//  LightningGame_Modularization
//
//  Created by fanqi_company on 2019/6/7.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "CTMediator+LGMainActions.h"

NSString * const kLGMediatorTargetMain = @"Main";

NSString * const kLGMediatorActionNativeGenerateMainController      = @"nativeGenerateMainController";
NSString * const kLGMediatorActionNativePresentImage                = @"nativePresentImage";
NSString * const kLGMediatorActionNativeNoImage                     = @"nativeNoImage";
NSString * const kLGMediatorActionShowAlert                         = @"showAlert";

@implementation CTMediator (LGMainActions)

- (UIViewController *)mediator_generateMainController {
    UIViewController *viewController = [self performTarget:kLGMediatorTargetMain
                                                    action:kLGMediatorActionNativeGenerateMainController
                                                    params:@{@"testKey": @"testValue"}
                                         shouldCacheTarget:NO];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        return viewController;
    }
    
    return nil;
}

@end
