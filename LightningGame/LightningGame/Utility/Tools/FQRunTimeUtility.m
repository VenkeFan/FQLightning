//
//  FQRunTimeUtility.m
//  LightningGame
//
//  Created by fanqi_company on 2019/5/27.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import "FQRunTimeUtility.h"

BOOL swizzleInstanceMethod(Class cls, SEL originalSel, SEL swizzledSel) {
    Method originalMethod = class_getInstanceMethod(cls, originalSel);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSel);
    if (!originalMethod || !swizzledMethod) {
        return NO;
    }
    
    BOOL didAdded = class_addMethod(cls,
                                    originalSel,
                                    method_getImplementation(swizzledMethod),
                                    method_getTypeEncoding(swizzledMethod));
    if (didAdded) {
        class_replaceMethod(cls,
                            swizzledSel,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
    return YES;
}

BOOL swizzleClassMethod(Class cls, SEL originalSel, SEL swizzledSel) {
    Method originalMethod = class_getClassMethod(cls, originalSel);
    Method swizzledMethod = class_getClassMethod(cls, swizzledSel);
    if (!originalMethod || !swizzledMethod) {
        return NO;
    }
    
    BOOL didAdded = class_addMethod(objc_getMetaClass([NSStringFromClass(cls) UTF8String]),
                                    originalSel,
                                    method_getImplementation(swizzledMethod),
                                    method_getTypeEncoding(swizzledMethod));
    if (didAdded) {
        class_replaceMethod(objc_getMetaClass([NSStringFromClass(cls) UTF8String]),
                            swizzledSel,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
    return YES;
}
