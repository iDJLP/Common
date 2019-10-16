//
//  CFDLocalizedManager.h
//  NWinBoom
//
//  Created by ngw15 on 2018/9/28.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CFDLocalizedString(key) [[CFDLocalizedManager sharedInstance] stringWithKey:key]
#define CFDLocalizedStringBlock(key) [[CFDLocalizedManager sharedInstance] stringBlockWithKey:key]

@interface CFDLocalizedManager : NSObject

+ (instancetype)sharedInstance;

- (NSBundle *)bundle;

- (void)setUserLanguage:(NSString *)language;

- (NSString *)stringWithKey:(NSString *)key;
- (NSString *(^)(void))stringBlockWithKey:(NSString *)key;

@end
