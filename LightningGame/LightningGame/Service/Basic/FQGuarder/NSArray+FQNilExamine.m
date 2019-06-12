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
    swizzleInstanceMethod([arrayM class], @selector(addObject:), @selector(safeM_addObject:));
    swizzleInstanceMethod([arrayM class], @selector(insertObject:atIndex:), @selector(safeM_insertObject:atIndex:));
    swizzleInstanceMethod([arrayM class], @selector(objectAtIndex:), @selector(safeM_objectAtIndex:));
    swizzleInstanceMethod([arrayM class], @selector(objectAtIndexedSubscript:), @selector(safeM_objectAtIndexedSubscript:));
    
    NSArray *arrayEmptyI = [NSArray array];
    swizzleInstanceMethod([arrayEmptyI class], @selector(objectAtIndex:), @selector(safeEmptyI_objectAtIndex:));
    swizzleInstanceMethod([arrayEmptyI class], @selector(objectAtIndexedSubscript:), @selector(safeEmptyI_objectAtIndexedSubscript:));
    
    NSArray *arraySingleI = [[NSArray alloc] initWithObjects:@"", nil];
    swizzleInstanceMethod([arraySingleI class], @selector(objectAtIndex:), @selector(safeSingleI_objectAtIndex:));
    swizzleInstanceMethod([arraySingleI class], @selector(objectAtIndexedSubscript:), @selector(safeSingleI_objectAtIndexedSubscript:));
    
    NSArray *arrayI = [[NSArray alloc] initWithObjects:@"", @"", nil];
    swizzleInstanceMethod([arrayI class], @selector(objectAtIndex:), @selector(safeI_objectAtIndex:));
    swizzleInstanceMethod([arrayI class], @selector(objectAtIndexedSubscript:), @selector(safeI_objectAtIndexedSubscript:));
    
    id placeholderArray = [NSArray alloc];
    swizzleInstanceMethod([placeholderArray class], @selector(initWithObjects:count:), @selector(safe_initWithObjects:count:));
}

#pragma mark - Mutable Array

- (void)safeM_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (nil == anObject) {
#if DEBUG
        NSLog(@"%@ - %@", [self class], [NSThread callStackSymbols]);
#endif
        return;
    }
    
    if (index < 0 || index > self.count) {
#if DEBUG
        NSLog(@"%@ - %@", [self class], [NSThread callStackSymbols]);
#endif
        return;
    }
    
    [self safeM_insertObject:anObject atIndex:index];
}

- (void)safeM_addObject:(id)anObject {
    if (nil == anObject) {
#if DEBUG
        NSLog(@"%@ - %@", [self class], [NSThread callStackSymbols]);
#endif
        return;
    }
    
    [self safeM_addObject:anObject];
}

- (id)safeM_objectAtIndex:(NSUInteger)index {
    if (index < 0 || index >= self.count) {
#if DEBUG
        NSLog(@"%@ - %@", [self class], [NSThread callStackSymbols]);
#endif
        return nil;
    }
    return [self safeM_objectAtIndex:index];
}

- (id)safeM_objectAtIndexedSubscript:(NSUInteger)index {
    if (index < 0 || index >= self.count) {
#if DEBUG
        NSLog(@"%@ - %@", [self class], [NSThread callStackSymbols]);
#endif
        return nil;
    }
    return [self safeM_objectAtIndexedSubscript:index];
}

#pragma mark - InMutable Empty Array

- (id)safeEmptyI_objectAtIndex:(NSUInteger)index {
    if (index < 0 || index >= self.count) {
#if DEBUG
        NSLog(@"%@ - %@", [self class], [NSThread callStackSymbols]);
#endif
        return nil;
    }
    return [self safeEmptyI_objectAtIndex:index];
}

- (id)safeEmptyI_objectAtIndexedSubscript:(NSUInteger)index {
    if (index < 0 || index >= self.count) {
#if DEBUG
        NSLog(@"%@ - %@", [self class], [NSThread callStackSymbols]);
#endif
        return nil;
    }
    return [self safeEmptyI_objectAtIndexedSubscript:index];
}

#pragma mark - InMutable Single Array

- (id)safeSingleI_objectAtIndex:(NSUInteger)index {
    if (index < 0 || index >= self.count) {
#if DEBUG
        NSLog(@"%@ - %@", [self class], [NSThread callStackSymbols]);
#endif
        return nil;
    }
    return [self safeSingleI_objectAtIndex:index];
}

- (id)safeSingleI_objectAtIndexedSubscript:(NSUInteger)index {
    if (index < 0 || index >= self.count) {
#if DEBUG
        NSLog(@"%@ - %@", [self class], [NSThread callStackSymbols]);
#endif
        return nil;
    }
    return [self safeSingleI_objectAtIndexedSubscript:index];
}

#pragma mark - InMutable Array

- (id)safeI_objectAtIndex:(NSUInteger)index {
    if (index < 0 || index >= self.count) {
#if DEBUG
        NSLog(@"%@ - %@", [self class], [NSThread callStackSymbols]);
#endif
        return nil;
    }
    return [self safeI_objectAtIndex:index];
}

- (id)safeI_objectAtIndexedSubscript:(NSUInteger)index {
    if (index < 0 || index >= self.count) {
#if DEBUG
        NSLog(@"%@ - %@", [self class], [NSThread callStackSymbols]);
#endif
        return nil;
    }
    return [self safeI_objectAtIndexedSubscript:index];
}

#pragma mark - Placeholder Array

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
