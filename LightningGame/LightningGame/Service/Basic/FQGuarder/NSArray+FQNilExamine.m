//
//  NSArray+FQNilExamine.m
//  FQWidgets
//
//  Created by fan qi on 2018/11/9.
//  Copyright © 2018 redefine. All rights reserved.
//

#import "NSArray+FQNilExamine.h"
#import "FQRunTimeUtility.h"

@implementation NSArray (FQNilExamine)

+ (void)load {
    NSMutableArray *arrayM = [NSMutableArray array];
    swizzleInstanceMethod([arrayM class], @selector(addObject:), @selector(safe_addObject:));
    swizzleInstanceMethod([arrayM class], @selector(insertObject:atIndex:), @selector(safe_insertObject:atIndex:));
    swizzleInstanceMethod([arrayM class], @selector(objectAtIndex:), @selector(safeM_objectAtIndex:));
    
    NSArray *arrayI = [[NSArray alloc] initWithObjects:@"", nil];
    swizzleInstanceMethod([arrayI class], @selector(objectAtIndex:), @selector(safe_objectAtIndex:));
    
    id placeholderArray = [NSArray alloc];
    swizzleInstanceMethod([placeholderArray class], @selector(initWithObjects:count:), @selector(safe_initWithObjects:count:));
}

- (void)safe_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (nil == anObject) {
#if DEBUG
        NSLog(@"%@", [NSThread callStackSymbols]);
#endif
        return;
    }
    
    if (index < 0 || index > self.count) {
#if DEBUG
        NSLog(@"%@", [NSThread callStackSymbols]);
#endif
        return;
    }
    
    [self safe_insertObject:anObject atIndex:index];
}

- (void)safe_addObject:(id)anObject {
    if (nil == anObject) {
#if DEBUG
        NSLog(@"%@", [NSThread callStackSymbols]);
#endif
        return;
    }
    
    [self safe_addObject:anObject];
}

- (id)safe_objectAtIndex:(NSUInteger)index {
    if (index < 0 || index >= self.count) {
#if DEBUG
        NSLog(@"%@", [NSThread callStackSymbols]);
#endif
        return nil;
    }
    return [self safe_objectAtIndex:index];
}

- (id)safeM_objectAtIndex:(NSUInteger)index {
    if (index < 0 || index >= self.count) {
#if DEBUG
        NSLog(@"%@", [NSThread callStackSymbols]);
#endif
        return nil;
    }
    return [self safeM_objectAtIndex:index];
}

- (instancetype)safe_initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt {
    NSUInteger valueCnt = 0;
    const id __unsafe_unretained *objPtr = objects;
    
    for (   ; valueCnt < cnt; valueCnt++, objPtr++) {
        if (*objPtr == 0) {
            break;
        }
    }
    
    return [self safe_initWithObjects:objects count:valueCnt];
}

@end
