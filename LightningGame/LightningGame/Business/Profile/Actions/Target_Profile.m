//
//  Target_Profile.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/10.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "Target_Profile.h"
#import "LGProfileViewController.h"
#import "LGParlayHistoryViewController.h"

@implementation Target_Profile

- (UIViewController *)action_nativeGenerateProfileController:(NSDictionary *)params {
    LGProfileViewController *ctr = [LGProfileViewController new];
    return ctr;
}

- (UIViewController *)action_nativeGenerateParlayHistoryController:(NSDictionary *)params {
    return [LGParlayHistoryViewController new];
}

@end
