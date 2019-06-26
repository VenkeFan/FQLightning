//
//  UIViewController+FQTracker.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/26.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "UIViewController+FQTracker.h"
#import "FQRunTimeUtility.h"

@implementation UIViewController (FQTracker)

+ (void)load {
    swizzleInstanceMethod(self, @selector(viewDidLoad), @selector(trace_viewDidLoad));
}

- (void)trace_viewDidLoad {
    [self trace_viewDidLoad];
}

@end
