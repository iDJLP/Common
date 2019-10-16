//
//  CFDLocalizedManager.m
//  NWinBoom
//
//  Created by ngw15 on 2018/9/28.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "CFDLocalizedManager.h"


@interface CFDLocalizedManager()

@property (nonatomic,strong) NSBundle *bundle;

@end

@implementation CFDLocalizedManager

+ (instancetype)sharedInstance {
    static CFDLocalizedManager *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[CFDLocalizedManager alloc] init];
    });
    return helper;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        if (!_bundle) {
            /*zh-Hans, zh-Han, en */
            NSString *userLanguage = @"zh-Hans";
            if ([[FTConfig sharedInstance].lang isEqualToString:@"en"]) {
                userLanguage = @"en";
            }
            NSString *path = [[NSBundle mainBundle] pathForResource:userLanguage ofType:@"lproj"];
            _bundle = [NSBundle bundleWithPath:path];
        }
        
    }
    return self;
}

- (NSBundle *)bundle {
    return _bundle;
}

- (void)setUserLanguage:(NSString *)language {
    
    /*zh-Hans, zh-Han, en */
    NSString *userLanguage = @"zh-Hans";
    if ([language isEqualToString:@"en"]) {
        userLanguage = @"en";
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:userLanguage ofType:@"lproj"];
    
    _bundle = [NSBundle bundleWithPath:path];
}

- (NSString *)stringWithKey:(NSString *)key {
    
    if (_bundle) {
        NSString *text = [_bundle localizedStringForKey:key value:@"" table:@""];
        return text;
    }else {
        return key;
    }
}

- (NSString *(^)(void))stringBlockWithKey:(NSString *)key{
    WEAK_SELF;
    NSString *(^block)(void)  =  ^NSString *(void){
        if (weakSelf.bundle) {
            NSString *text = [weakSelf.bundle localizedStringForKey:key value:@"" table:@""];
            return text;
        }else {
            return key;
        }
    };
    return block;
}

@end
