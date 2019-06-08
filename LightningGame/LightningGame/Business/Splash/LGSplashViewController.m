//
//  LGSplashViewController.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/6.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGSplashViewController.h"
#import "CTMediator+LGMainActions.h"
#import "CTMediator+LGSignActions.h"

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
    UIViewController *root = nil;
    if ([LGAccountManager instance].account) {
        root = [[CTMediator sharedInstance] mediator_generateMainController];
    } else {
        root = [[CTMediator sharedInstance] mediator_generateSignInController];
    }
    
    [FQWindowUtility changeKeyWindowRootViewController:root];
}

@end
