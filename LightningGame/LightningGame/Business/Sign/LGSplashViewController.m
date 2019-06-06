//
//  LGSplashViewController.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/6.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGSplashViewController.h"
#import "LGSignFlowManager.h"
#import "LGMainViewController.h"
#import "LGSignInViewController.h"

@interface LGSplashViewController ()

@end

@implementation LGSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self launch];
    });
}

- (void)launch {
    if ([LGAccountManager instance].account) {
        [FQWindowUtility changeKeyWindowRootViewControllerWithNewClass:[LGMainViewController class]];
    } else {
        [FQWindowUtility changeKeyWindowRootViewControllerWithNewClass:[LGSignInViewController class]];
    }
}

@end
