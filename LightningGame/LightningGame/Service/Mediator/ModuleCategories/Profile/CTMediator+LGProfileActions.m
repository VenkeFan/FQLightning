//
//  CTMediator+LGProfileActions.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/10.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "CTMediator+LGProfileActions.h"

NSString * const kLGMediatorTargetProfile = @"Profile";

NSString * const kLGMediatorActionNativeGenerateProfileController = @"nativeGenerateProfileController";
NSString * const kLGMediatorActionNativeGenerateParlayHistoryController = @"nativeGenerateParlayHistoryController";

@implementation CTMediator (LGProfileActions)

- (UIViewController *)mediator_generateProfileController {
    UIViewController *viewController = [self performTarget:kLGMediatorTargetProfile
                                                    action:kLGMediatorActionNativeGenerateProfileController
                                                    params:@{}
                                         shouldCacheTarget:NO];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        return viewController;
    }
    
    return nil;
}

- (UIViewController *)mediator_generateParlayHistoryController {
    UIViewController *viewController = [self performTarget:kLGMediatorTargetProfile
                                                    action:kLGMediatorActionNativeGenerateParlayHistoryController
                                                    params:@{}
                                         shouldCacheTarget:NO];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        return viewController;
    }
    
    return nil;
}

@end
