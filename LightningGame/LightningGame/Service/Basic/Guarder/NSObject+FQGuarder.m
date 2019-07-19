//
//  NSObject+FQGuarder.m
//  FQWidgets
//
//  Created by fanqi on 17/4/19.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "NSObject+FQGuarder.h"
#import <objc/runtime.h>

static NSDictionary *ignoreObjectNameDic;

@implementation NSObject (FQGuarder)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ignoreObjectNameDic = @{
                                @"UITextInputController": @"T",
                                @"_UIAppearance": @"T",
                                @"_UIBarItemAppearance": @"T",
                                @"_UITraitBasedAppearance": @"T",
                                @"_UIPropertyBasedAppearance": @"T",
                                @"_NSXPCDistantObjectWithError": @"T",
                                @"_NSXPCDistantObjectSynchronousWithError": @"T",
                                @"_NSXPCDistantObject": @"T",
                                };
    });
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wobjc-protocol-method-implementation"
- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSString *methodName = NSStringFromSelector(aSelector);
    NSString *clsName = NSStringFromClass([self class]);
    if ([clsName hasPrefix:@"UIKeyboard"] ||
        [ignoreObjectNameDic objectForKey:clsName] ||
        [methodName isEqualToString:@"dealloc"]) {
#if DEBUG
        NSLog(@"[%@ %p %@]", clsName, self, NSStringFromSelector(aSelector));
#endif
        return nil;
    }

    if (![self respondsToSelector:aSelector]) {
        Class FQGuard = objc_allocateClassPair([NSObject class], "FQGuard", 0);

        NSString *msg = [NSString stringWithFormat:@"[%@ %p %@]: unrecognized selector sent to instance", clsName, self, NSStringFromSelector(aSelector)];
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
