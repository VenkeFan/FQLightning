//
//  LGSplashViewController.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/6.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGSplashViewController.h"
#import "LGSignFlowManager.h"
#import "CTMediator+LGMainActions.h"
#import "CTMediator+LGSignActions.h"

@interface LGSplashViewController () <LGSignFlowManagerDelegate>

@end

@implementation LGSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[LGSignFlowManager instance] addListener:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self launch];
    });
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[LGSignFlowManager instance] removeListener:self];
}

- (void)launch {
    if ([LGAccountManager instance].isLogin) {
        [[LGSignFlowManager instance] oAuthorize];
    } else {
        UIViewController *root = [[CTMediator sharedInstance] mediator_generateSignInController];
        [FQWindowUtility changeKeyWindowRootViewController:root];
//        [self.navigationController setViewControllers:@[root] animated:NO];
    }
}

#pragma mark - LGSignFlowManagerDelegate

- (void)signFlowManagerStepping:(LGSignFlowStep)step {
    switch (step) {
        case LGSignFlowStep_Home: {
            UIViewController *root = [[CTMediator sharedInstance] mediator_generateMainController];
            [FQWindowUtility changeKeyWindowRootViewController:root];
        }
            break;
        default:
            break;
    }
}

- (void)signFlowManagerFailed:(NSError *)error {
    [[LGAccountManager instance] signOut];
}

@end
