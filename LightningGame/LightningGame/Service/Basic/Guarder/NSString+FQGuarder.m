//
//  NSString+FQGuarder.m
//  FQWidgets
//
//  Created by fan qi on 2018/11/9.
//  Copyright © 2018 fan qi. All rights reserved.
//

#import "NSString+FQGuarder.h"
#import "FQRunTimeUtility.h"

@implementation NSString (FQGuarder)

+ (void)load {
    id placeholderStr = [NSString alloc];
    swizzleInstanceMethod([placeholderStr class], @selector(initWithString:), @selector(safe_initWithString:));
    
    id placeholderStrM = [NSMutableString alloc];
    swizzleInstanceMethod([placeholderStrM class], @selector(initWithString:), @selector(safeM_initWithString:));
    
    NSString *cfConstStr = [NSString string];
//    IMP imp1 = method_getImplementation(class_getInstanceMethod([cfConstStr class], @selector(substringWithRange:)));
//    IMP imp2 = method_getImplementation(class_getInstanceMethod([cfConstStr class], @selector(safe_substringWithRange:)));
    swizzleInstanceMethod([cfConstStr class], @selector(substringWithRange:), @selector(safe_substringWithRange:));
    swizzleInstanceMethod([cfConstStr class], @selector(substringFromIndex:), @selector(safe_substringFromIndex:));
    swizzleInstanceMethod([cfConstStr class], @selector(substringToIndex:), @selector(safe_substringToIndex:));
//    imp1 = method_getImplementation(class_getInstanceMethod([cfConstStr class], @selector(substringWithRange:)));
//    imp2 = method_getImplementation(class_getInstanceMethod([cfConstStr class], @selector(safe_substringWithRange:)));
    
    NSMutableString *cfStr = [NSMutableString string];
    swizzleInstanceMethod([cfStr class], @selector(replaceCharactersInRange:withString:), @selector(safe_replaceCharactersInRange:withString:));
    swizzleInstanceMethod([cfStr class], @selector(insertString:atIndex:), @selector(safe_insertString:atIndex:));
    swizzleInstanceMethod([cfStr class], @selector(appendString:), @selector(safe_appendString:));
    swizzleInstanceMethod([cfStr class], @selector(deleteCharactersInRange:), @selector(safe_deleteCharactersInRange:));
    swizzleInstanceMethod([cfStr class], @selector(replaceOccurrencesOfString:withString:options:range:), @selector(safe_replaceOccurrencesOfString:withString:options:range:));
    
    /*
     [[NSString stringWithFormat:@""] class]                = __NSCFConstantString
     [[NSString stringWithFormat:@"123456789a"] class]      = __NSCFString
     [[NSString stringWithFormat:@"1"] class]               = NSTaggedPointerString
     [[NSString stringWithFormat:@"123456789"] class]       = NSTaggedPointerString
     */
    NSString *taggedStr = [NSString stringWithFormat:@"1"];
//    IMP imp3 = method_getImplementation(class_getInstanceMethod([taggedStr class], @selector(substringWithRange:)));
//    IMP imp4 = method_getImplementation(class_getInstanceMethod([taggedStr class], @selector(safe_substringWithRange:)));
    swizzleInstanceMethod([taggedStr class], @selector(substringWithRange:), @selector(safe_substringWithRange:));
    swizzleInstanceMethod([taggedStr class], @selector(substringFromIndex:), @selector(safe_substringFromIndex:));
    swizzleInstanceMethod([taggedStr class], @selector(substringToIndex:), @selector(safe_substringToIndex:));    
//    imp3 = method_getImplementation(class_getInstanceMethod([taggedStr class], @selector(substringWithRange:)));
//    imp4 = method_getImplementation(class_getInstanceMethod([taggedStr class], @selector(safe_substringWithRange:)));
}

#pragma mark - NSPlaceholderString

- (instancetype)safe_initWithString:(NSString *)aString {
    if (nil == aString || [aString isEqual:[NSNull null]]) {
#if DEBUG
        NSLog(@"%@", [NSThread callStackSymbols]);
#endif
        return nil;
    }
    return [self safe_initWithString:aString];
}

#pragma mark - NSPlaceholderMutableString

- (instancetype)safeM_initWithString:(NSString *)aString {
    if (nil == aString || [aString isEqual:[NSNull null]]) {
#if DEBUG
        NSLog(@"%@", [NSThread callStackSymbols]);
#endif
        return nil;
    }
    return [self safeM_initWithString:aString];
}

#pragma mark - __NSCFConstantString

- (NSString *)safe_substringWithRange:(NSRange)range {
    if (range.location < 0
        || range.location > self.length
        || range.location + range.length > self.length) {
#if DEBUG
        NSLog(@"%@ - %@ - %@", [self class], NSStringFromSelector(_cmd), [NSThread callStackSymbols]);
#endif
        return self;
    }
    
    return [self safe_substringWithRange:range];
}

- (NSString *)safe_substringFromIndex:(NSUInteger)from {
    if (from < 0 || from > self.length) {
#if DEBUG
        NSLog(@"%@ - %@ - %@", [self class], NSStringFromSelector(_cmd), [NSThread callStackSymbols]);
#endif
        return self;
    }
    
    return [self safe_substringFromIndex:from];
}

- (NSString *)safe_substringToIndex:(NSUInteger)to {
    if (to < 0 || to > self.length) {
#if DEBUG
        NSLog(@"%@ - %@ - %@", [self class], NSStringFromSelector(_cmd), [NSThread callStackSymbols]);
#endif
        return self;
    }
    
    return [self safe_substringToIndex:to];
}

#pragma mark - __NSCFString

- (void)safe_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    if (nil == aString || [aString isEqual:[NSNull null]]) {
#if DEBUG
        NSLog(@"%@", [NSThread callStackSymbols]);
#endif
        return;
    }
    
    if (range.location < 0
        || range.location > self.length
        || range.location + range.length > self.length) {
#if DEBUG
        NSLog(@"%@", [NSThread callStackSymbols]);
#endif
        return;
    }
    
    [self safe_replaceCharactersInRange:range withString:aString];
}

- (void)safe_insertString:(NSString *)aString atIndex:(NSUInteger)loc {
    if (nil == aString || [aString isEqual:[NSNull null]]) {
#if DEBUG
        NSLog(@"%@", [NSThread callStackSymbols]);
#endif
        return;
    }
    
    if (loc < 0 || loc > self.length) {
#if DEBUG
        NSLog(@"%@", [NSThread callStackSymbols]);
#endif
        return;
    }
    
    [self safe_insertString:aString atIndex:loc];
}

- (void)safe_appendString:(NSString *)aString {
    if (nil == aString || [aString isEqual:[NSNull null]]) {
#if DEBUG
        NSLog(@"%@", [NSThread callStackSymbols]);
#endif
        return;
    }
    
    if ([[self class] isKindOfClass:[NSString class]]) {
#if DEBUG
        NSLog(@"%@", [NSThread callStackSymbols]);
#endif
        return;
    }
    
    [self safe_appendString:aString];
}

- (void)safe_deleteCharactersInRange:(NSRange)range {
    if (range.location < 0
        || range.location > self.length
        || range.location + range.length > self.length) {
#if DEBUG
        NSLog(@"%@", [NSThread callStackSymbols]);
#endif
        return;
    }
    
    [self safe_deleteCharactersInRange:range];
}

- (NSUInteger)safe_replaceOccurrencesOfString:(NSString *)target
                                   withString:(NSString *)replacement
                                      options:(NSStringCompareOptions)options
                                        range:(NSRange)searchRange {
    if (nil == target || [target isEqual:[NSNull null]]) {
#if DEBUG
        NSLog(@"%@", [NSThread callStackSymbols]);
#endif
        return -1;
    }
    if (nil == replacement || [replacement isEqual:[NSNull null]]) {
#if DEBUG
        NSLog(@"%@", [NSThread callStackSymbols]);
#endif
        return -1;
    }
    
    if (searchRange.location < 0
        || searchRange.location > self.length
        || searchRange.location + searchRange.length > self.length) {
#if DEBUG
        NSLog(@"%@", [NSThread callStackSymbols]);
#endif
        return -1;
    }
    
    return [self safe_replaceOccurrencesOfString:target
                                      withString:replacement
                                         options:options
                                           range:searchRange];
}

@end
