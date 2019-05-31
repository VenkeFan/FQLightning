//
//  FQRunTimeUtility.h
//  LightningGame
//
//  Created by fanqi_company on 2019/5/27.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

extern BOOL swizzleInstanceMethod(Class cls, SEL originalSel, SEL swizzledSel);
extern BOOL swizzleClassMethod(Class cls, SEL originalSel, SEL swizzledSel);

NS_ASSUME_NONNULL_END
