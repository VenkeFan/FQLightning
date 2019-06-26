//
//  UIControl+FQTracker.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/26.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "UIControl+FQTracker.h"
#import "FQRunTimeUtility.h"

@implementation UIControl (FQTracker)

+ (void)load {
    swizzleInstanceMethod(self, @selector(sendAction:to:forEvent:), @selector(trace_sendAction:to:forEvent:));
}

- (void)trace_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    [self trace_sendAction:action to:target forEvent:event];
}

@end
