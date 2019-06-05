//
//  LGToastView.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/4.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "LGToastView.h"
#import "MBProgressHUD.h"

@implementation LGToastView

+ (void)showWithText:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kCurrentWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = text;
        [hud hideAnimated:YES afterDelay:1.5];
    });
}

@end
