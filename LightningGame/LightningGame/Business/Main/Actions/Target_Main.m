//
//  Target_Main.m
//  LightningGame_Modularization
//
//  Created by fanqi_company on 2019/6/7.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "Target_Main.h"
#import "LGMainViewController.h"

@implementation Target_Main

- (UIViewController *)action_nativeGenerateMainController:(NSDictionary *)params {
    LGMainViewController *mainCtr = [LGMainViewController new];
    return mainCtr;
}

@end
