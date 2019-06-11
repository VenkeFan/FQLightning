//
//  Target_SignIn.m
//  LightningGame_Modularization
//
//  Created by fanqi_company on 2019/6/7.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "Target_SignIn.h"
#import "LGSignInViewController.h"

@implementation Target_SignIn

- (UIViewController *)action_nativeGenerateSignInController:(NSDictionary *)params {
    LGSignInViewController *ctr = [LGSignInViewController new];
    return ctr;
}

@end
