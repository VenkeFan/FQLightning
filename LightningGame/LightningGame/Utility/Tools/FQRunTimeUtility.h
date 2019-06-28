//
//  FQRunTimeUtility.h
//  FQWidgets
//
//  Created by fan qi on 2019/5/27.
//  Copyright © 2019 fan qi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

extern BOOL swizzleInstanceMethod(Class cls, SEL originalSel, SEL swizzledSel);
extern BOOL swizzleClassMethod(Class cls, SEL originalSel, SEL swizzledSel);

NS_ASSUME_NONNULL_END
