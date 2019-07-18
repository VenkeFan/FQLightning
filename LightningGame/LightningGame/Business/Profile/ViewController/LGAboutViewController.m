//
//  LGAboutViewController.m
//  LightningGame
//
//  Created by fanqi_company on 2019/7/18.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGAboutViewController.h"

@interface LGAboutViewController ()

@end

@implementation LGAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kLocalizedString(@"profile_about");
    
    self.urlStr = @"http://192.168.1.53:8080/about.html";
}

@end
