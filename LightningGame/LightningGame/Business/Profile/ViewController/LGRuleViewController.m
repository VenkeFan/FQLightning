//
//  LGRuleViewController.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/12.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGRuleViewController.h"

@interface LGRuleViewController ()

@end

@implementation LGRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kLocalizedString(@"profile_rule");
    
    self.urlStr = @"http://192.168.1.53:8080/rule.html";
}

@end
