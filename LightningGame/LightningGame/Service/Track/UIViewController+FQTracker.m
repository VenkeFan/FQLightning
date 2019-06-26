//
//  UIViewController+FQTracker.m
//  FQWidgets
//
//  Created by fan qi on 2019/6/26.
//  Copyright © 2019 fan qi. All rights reserved.
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
