//
//  NSString+NSafe.m
//  niuguwang
//
//  Created by BrightLi on 2017/5/15.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "NSString+NSafe.h"
#import "Util.h"

@implementation NSString (NSafe)

+ (void)fixed {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"__NSCFConstantString");
        [NSafe swizzleMethod:cls
                    original:@selector(characterAtIndex:)
                    swizzled:@selector(n_characterAtIndex:)];
        [NSafe swizzleMethod:cls
                    original:@selector(substringFromIndex:)
                    swizzled:@selector(n_substringFromIndex:)];
        [NSafe swizzleMethod:cls
                    original:@selector(substringToIndex:)
                    swizzled:@selector(n_substringToIndex:)];
        [NSafe swizzleMethod:cls
                    original:@selector(substringWithRange:)
                    swizzled:@selector(n_substringWithRange:)];
        [NSafe swizzleMethod:cls
                    original:@selector(stringByReplacingOccurrencesOfString:withString:options:range:)
                    swizzled:@selector(n_stringByReplacingOccurrencesOfString:withString:options:range:)];
        [NSafe swizzleMethod:cls
                    original:@selector(stringByReplacingOccurrencesOfString:withString:)
                    swizzled:@selector(n_stringByReplacingOccurrencesOfString:withString:)];
    });
}

- (unichar)n_characterAtIndex:(NSUInteger)index {
    unichar characteristic;
    @try {
        characteristic = [self n_characterAtIndex:index];
    }
    @catch (NSException *exception) {
        [GLog stackLog:exception];
    }
    @finally {
        return characteristic;
    }
}

- (NSString *)n_substringFromIndex:(NSUInteger)from {
    NSString *subString = @"";
    @try {
        subString = [self n_substringFromIndex:from];
    }
    @catch (NSException *exception) {
        [GLog stackLog:exception];
    }
    @finally {
        return subString;
    }
}

- (NSString *)n_substringToIndex:(NSUInteger)from {
    NSString *subString = @"";
    @try {
        subString = [self n_substringToIndex:from];
    }
    @catch (NSException *exception) {
        [GLog stackLog:exception];
    }
    @finally {
        return subString;
    }
}

- (NSString *)n_substringWithRange:(NSRange)range {
    NSString *subString = @"";
    @try {
        subString = [self n_substringWithRange:range];
    }
    @catch (NSException *exception) {
        [GLog stackLog:exception];
    }
    @finally {
        return subString;
    }
}

- (NSString *)n_stringByReplacingOccurrencesOfString:(NSString *)target
                                          withString:(NSString *)replacement
                                             options:(NSStringCompareOptions)options
                                               range:(NSRange)searchRange {
    NSString *newStr = @"";
    @try {
        newStr = [self n_stringByReplacingOccurrencesOfString:target withString:replacement options:options range:searchRange];
    }
    @catch (NSException *exception) {
        [GLog stackLog:exception];
    }
    @finally {
        return newStr;
    }
}

- (NSString *)n_stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement {
    NSString *newStr = nil;
    @try {
        newStr = [self n_stringByReplacingOccurrencesOfString:target withString:replacement];
    }
    @catch (NSException *exception) {
        [GLog stackLog:exception];
    }
    @finally {
        return newStr;
    }
}

@end

@implementation NSMutableString (NSafe)

+ (void)fixed {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"__NSCFString");
        [NSafe swizzleMethod:cls
                    original:@selector(replaceCharactersInRange:withString:)
                    swizzled:@selector(n_replaceCharactersInRange:withString:)];
        [NSafe swizzleMethod:cls
                    original:@selector(replaceOccurrencesOfString:withString:options:range:)
                    swizzled:@selector(n_replaceOccurrencesOfString:withString:options:range:)];
        [NSafe swizzleMethod:cls
                    original:@selector(insertString:atIndex:)
                    swizzled:@selector(n_insertString:atIndex:)];
        [NSafe swizzleMethod:cls
                    original:@selector(deleteCharactersInRange:)
                    swizzled:@selector(n_deleteCharactersInRange:)];
        [NSafe swizzleMethod:cls
                    original:@selector(appendString:)
                    swizzled:@selector(n_appendString:)];
    });
}

- (void)n_replaceCharactersInRange:(NSRange)range
                        withString:(NSString *)aString {
    @try {
        [self n_replaceCharactersInRange:range withString:aString];
    }
    @catch (NSException *exception) {
        [GLog stackLog:exception];
    }
    @finally {
    }
}

- (NSUInteger)n_replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange {
    NSUInteger index = 0;
    @try {
        index = [self n_replaceOccurrencesOfString:target withString:replacement options:options range:searchRange];
    }
    @catch (NSException *exception) {
        [GLog stackLog:exception];
    }
    @finally {
        return index;
    }
}


- (void)n_insertString:(NSString *)aString
               atIndex:(NSUInteger)loc {
    @try {
        [self n_insertString:aString atIndex:loc];
    }
    @catch (NSException *exception) {
        [GLog stackLog:exception];
    }
    @finally {
    }
}

- (void)n_deleteCharactersInRange:(NSRange)range {
    @try {
        [self n_deleteCharactersInRange:range];
    }
    @catch (NSException *exception) {
        [GLog stackLog:exception];
    }
    @finally {
    }
}

- (void)n_appendString:(NSString *)string {
    @try {
        [self n_appendString:string];
    }
    @catch (NSException *exception) {
        [GLog stackLog:exception];
    }
    @finally {
    }
}

@end

@implementation NSAttributedString (NSafe)

+ (void)fixed {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"NSConcreteAttributedString");
        [NSafe swizzleMethod:cls
                    original:@selector(initWithString:)
                    swizzled:@selector(n_initWithString:)];
        [NSafe swizzleMethod:cls
                    original:@selector(initWithAttributedString:)
                    swizzled:@selector(n_initWithAttributedString:)];
        [NSafe swizzleMethod:cls
                    original:@selector(initWithString:attributes:)
                    swizzled:@selector(n_initWithString:attributes:)];
        [NSafe swizzleMethod:cls
                    original:@selector(attributedSubstringFromRange:)
                    swizzled:@selector(n_attributedSubstringFromRange:)];
    });
}

- (instancetype)n_initWithString:(NSString *)str {
    id object = nil;
    @try {
        object = [self n_initWithString:str];
    }
    @catch (NSException *exception) {
        [GLog stackLog:exception];
    }
    @finally {
        return object;
    }
}

- (instancetype)n_initWithAttributedString:(NSAttributedString *)attrStr {
    id object = nil;
    @try {
        object = [self n_initWithAttributedString:attrStr];
    }
    @catch (NSException *exception) {
        [GLog stackLog:exception];
    }
    @finally {
        return object;
    }
}

- (instancetype)n_initWithString:(NSString *)str
                      attributes:(NSDictionary<NSString *, id> *)attrs {
    id object = nil;
    @try {
        object = [self n_initWithString:str attributes:attrs];
    }
    @catch (NSException *exception) {
        [GLog stackLog:exception];
    }
    @finally {
        return object;
    }
}

- (NSAttributedString *)n_attributedSubstringFromRange:(NSRange)range {
    if (range.location + range.length <= self.length) {
        return [self n_attributedSubstringFromRange:range];
    } else if (range.location < self.length) {
        return [self n_attributedSubstringFromRange:NSMakeRange(range.location, self.length - range.location)];
    }
    return nil;
}

@end

@implementation NSMutableAttributedString (NSafe)

+ (void)fixed {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"NSConcreteMutableAttributedString");
        [NSafe swizzleMethod:cls
                    original:@selector(initWithString:)
                    swizzled:@selector(n_initWithString:)];
        [NSafe swizzleMethod:cls
                    original:@selector(initWithString:attributes:)
                    swizzled:@selector(n_initWithString:attributes:)];
        [NSafe swizzleMethod:cls
                    original:@selector(attributedSubstringFromRange:)
                    swizzled:@selector(n_attributedSubstringFromRange:)];
    });
}

- (instancetype)n_initWithString:(NSString *)str {
    id object = nil;
    @try {
        object = [self n_initWithString:str];
    }
    @catch (NSException *exception) {
        [GLog stackLog:exception];
    }
    @finally {
        return object;
    }
}

- (instancetype)n_initWithString:(NSString *)str
                      attributes:(NSDictionary<NSString *, id> *)attrs {
    id object = nil;
    @try {
        object = [self n_initWithString:str attributes:attrs];
    }
    @catch (NSException *exception) {
        [GLog stackLog:exception];
    }
    @finally {
        return object;
    }
}

- (NSAttributedString *)n_attributedSubstringFromRange:(NSRange)range {
    if (range.location + range.length <= self.length) {
        return [self n_attributedSubstringFromRange:range];
    } else if (range.location < self.length) {
        return [self n_attributedSubstringFromRange:NSMakeRange(range.location, self.length - range.location)];
    }
    return nil;
}

@end
