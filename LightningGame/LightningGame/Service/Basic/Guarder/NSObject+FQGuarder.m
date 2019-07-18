//
//  NSObject+FQGuarder.m
//  FQWidgets
//
//  Created by fanqi on 17/4/19.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "NSObject+FQGuarder.h"
#import <objc/runtime.h>

@implementation NSObject (FQGuarder)

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wobjc-protocol-method-implementation"
- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSString *methodName = NSStringFromSelector(aSelector);
    if (/* [NSStringFromClass([self class]) hasPrefix:@"_"] || */
        [NSStringFromClass([self class]) hasPrefix:@"UIKeyboard"] ||
        [NSStringFromClass([self class]) isEqualToString:@"UITextInputController"] ||
        [NSStringFromClass([self class]) isEqualToString:@"_UIAppearance"] ||
        [NSStringFromClass([self class]) isEqualToString:@"_UIBarItemAppearance"] ||
        [NSStringFromClass([self class]) isEqualToString:@"_UITraitBasedAppearance"] ||
        [NSStringFromClass([self class]) isEqualToString:@"_UIPropertyBasedAppearance"] ||
        [NSStringFromClass([self class]) isEqualToString:@"_NSXPCDistantObjectWithError"] ||
        [NSStringFromClass([self class]) isEqualToString:@"_NSXPCDistantObjectSynchronousWithError"] ||
        [methodName isEqualToString:@"dealloc"]) {
#if DEBUG
        NSLog(@"[%@ %p %@]", NSStringFromClass([self class]), self, NSStringFromSelector(aSelector));
#endif
        return nil;
    }
    
    if (![self respondsToSelector:aSelector]) {
        Class FQGuard = objc_allocateClassPair([NSObject class], "FQGuard", 0);
        
        NSString *msg = [NSString stringWithFormat:@"[%@ %p %@]: unrecognized selector sent to instance", NSStringFromClass([self class]), self, NSStringFromSelector(aSelector)];
        class_addMethod(FQGuard, aSelector, imp_implementationWithBlock(^(id self) {
#if DEBUG
            NSLog(@"%@", msg);
            NSLog(@"%@", [NSThread callStackSymbols]);
#endif
        }), "v@*");
        
        return [FQGuard new];
    }
    return nil;
}
#pragma clang diagnostic pop

@end
