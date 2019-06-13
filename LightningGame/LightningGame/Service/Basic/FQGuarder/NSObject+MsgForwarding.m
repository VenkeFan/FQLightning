//
//  NSObject+MsgForwarding.m
//  FQWidgets
//
//  Created by fanqi on 17/4/19.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "NSObject+MsgForwarding.h"
#import <objc/runtime.h>

@implementation NSObject (MsgForwarding)

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wobjc-protocol-method-implementation"
- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSString *methodName = NSStringFromSelector(aSelector);
    if ([NSStringFromClass([self class]) hasPrefix:@"_"]
        || [self isKindOfClass:NSClassFromString(@"UITextInputController")]
        || [NSStringFromClass([self class]) hasPrefix:@"UIKeyboard"]
        || [methodName isEqualToString:@"dealloc"]) {
#if DEBUG
        NSLog(@"MsgForwarding: %@ - %@", NSStringFromSelector(aSelector), [NSThread callStackSymbols]);
#endif
        return nil;
    }
    
    if (![self respondsToSelector:aSelector]) {
        Class WLGuard = objc_allocateClassPair([NSObject class], "WLGuard", 0);
        
        NSString *msg = [NSString stringWithFormat:@"[%@ %p %@]: unrecognized selector sent to instance", NSStringFromClass([self class]), self, NSStringFromSelector(aSelector)];
        class_addMethod(WLGuard, aSelector, imp_implementationWithBlock(^(id self) {
#if DEBUG
            NSLog(@"%@", msg);
            NSLog(@"%@", [NSThread callStackSymbols]);
#endif
        }), "v@*");
        
        return [WLGuard new];
    }
    return nil;
}
#pragma clang diagnostic pop

@end
