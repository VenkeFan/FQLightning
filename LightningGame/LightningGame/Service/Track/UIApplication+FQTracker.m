

//
//  UIApplication+FQTracker.m
//  LightningGame
//
//  Created by fanqi_company on 2019/6/26.
//  Copyright © 2019 fanqi_company. All rights reserved.
//

/*
 <_NSCallStackArray 0x6000016a1a70>(
 0   ???                                 0x0000000129fbe177 0x0 + 4999340407,
 1   LightningGame                       0x0000000105255540 main + 0,
 2   UIKitCore                           0x000000010c59714d -[UIGestureRecognizerTarget _sendActionWithGestureRecognizer:] + 57,
 3   UIKitCore                           0x000000010c59fc69 _UIGestureRecognizerSendTargetActions + 109,
 4   UIKitCore                           0x000000010c59d5ba _UIGestureRecognizerSendActions + 311,
 5   UIKitCore                           0x000000010c59c897 -[UIGestureRecognizer _updateGestureWithEvent:buttonEvent:] + 966,
 6   UIKitCore                           0x000000010c58ec4e _UIGestureEnvironmentUpdate + 2820,
 7   UIKitCore                           0x000000010c58e108 -[UIGestureEnvironment _deliverEvent:toGestureRecognizers:usingBlock:] + 478,
 8   UIKitCore                           0x000000010c58de96 -[UIGestureEnvironment _updateForEvent:window:] + 200,
 9   UIKitCore                           0x000000010c9e95bc -[UIWindow sendEvent:] + 4057,
 10  UIKitCore                           0x000000010c9c7d16 -[UIApplication sendEvent:] + 356,
 11  UIKitCore                           0x000000010ca98293 __dispatchPreprocessedEventFromEventQueue + 3232,
 12  UIKitCore                           0x000000010ca9abb9 __handleEventQueueInternal + 5911,
 13  CoreFoundation                      0x0000000108b29be1 __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ + 17,
 14  CoreFoundation                      0x0000000108b29463 __CFRunLoopDoSources0 + 243,
 15  CoreFoundation                      0x0000000108b23b1f __CFRunLoopRun + 1231,
 16  CoreFoundation                      0x0000000108b23302 CFRunLoopRunSpecific + 626,
 17  GraphicsServices                    0x000000010f9322fe GSEventRunModal + 65,
 18  UIKitCore                           0x000000010c9adba2 UIApplicationMain + 140,
 19  LightningGame                       0x00000001052555b0 main + 112,
 20  libdyld.dylib                       0x0000000109a6c541 start + 1
 )
 
 
 <_NSCallStackArray 0x6000016d12f0>(
 0   ???                                 0x0000000129fbe177 0x0 + 4999340407,
 1   LightningGame                       0x0000000105255540 main + 0,
 2   UIKitCore                           0x000000010c9af204 -[UIApplication sendAction:to:from:forEvent:] + 83,
 3   MLeaksFinder                        0x0000000106eb8b55 -[UIApplication(MemoryLeak) swizzled_sendAction:to:from:forEvent:] + 245,
 4   UIKitCore                           0x000000010c404c19 -[UIControl sendAction:to:forEvent:] + 67,
 5   LightningGame                       0x00000001052639fa -[UIControl(FQTracker) trace_sendAction:to:forEvent:] + 122,
 6   UIKitCore                           0x000000010c404f36 -[UIControl _sendActionsForEvents:withEvent:] + 450,
 7   UIKitCore                           0x000000010c403eec -[UIControl touchesEnded:withEvent:] + 583,
 8   UIKitCore                           0x000000010c5909c9 _UIGestureEnvironmentUpdate + 10367,
 9   UIKitCore                           0x000000010c58e108 -[UIGestureEnvironment _deliverEvent:toGestureRecognizers:usingBlock:] + 478,
 10  UIKitCore                           0x000000010c58de96 -[UIGestureEnvironment _updateForEvent:window:] + 200,
 11  UIKitCore                           0x000000010c9e95bc -[UIWindow sendEvent:] + 4057,
 12  UIKitCore                           0x000000010c9c7d16 -[UIApplication sendEvent:] + 356,
 13  UIKitCore                           0x000000010ca98293 __dispatchPreprocessedEventFromEventQueue + 3232,
 14  UIKitCore                           0x000000010ca9abb9 __handleEventQueueInternal + 5911,
 15  CoreFoundation                      0x0000000108b29be1 __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ + 17,
 16  CoreFoundation                      0x0000000108b29463 __CFRunLoopDoSources0 + 243,
 17  CoreFoundation                      0x0000000108b23b1f __CFRunLoopRun + 1231,
 18  CoreFoundation                      0x0000000108b23302 CFRunLoopRunSpecific + 626,
 19  GraphicsServices                    0x000000010f9322fe GSEventRunModal + 65,
 20  UIKitCore                           0x000000010c9adba2 UIApplicationMain + 140,
 21  LightningGame                       0x00000001052555b0 main + 112,
 22  libdyld.dylib                       0x0000000109a6c541 start + 1
 )
 
 */

#import "UIApplication+FQTracker.h"
#import "FQRunTimeUtility.h"

@implementation UIApplication (FQTracker)

+ (void)load {
    swizzleInstanceMethod(self, @selector(sendEvent:), @selector(trace_sendEvent:));
//    swizzleInstanceMethod(self, @selector(sendAction:to:from:forEvent:), @selector(trace_sendAction:to:from:forEvent:));
}

- (void)trace_sendEvent:(UIEvent *)event {
    // 为什么一次事件会调用两次该方法？？？？？
    [self trace_sendEvent:event];
}

/**
 hook这个方法，和hook UIControl 中的 sendAction:to:forEvent:方法一样。
 */
//- (BOOL)trace_sendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent *)event {
//    return [self trace_sendAction:action to:target from:sender forEvent:event];
//}

@end
