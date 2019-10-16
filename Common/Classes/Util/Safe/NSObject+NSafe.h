//
//  NSObject+NSafe.h
//  niuguwang
//
//  Created by BrightLi on 2017/6/5.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

@interface NSObject(NSafe)
// 修正
+ (void) fixed;
// 交换两个方法
- (void) n_swizzleMethod:(SEL) original
                swizzled:(SEL) swizzled;
// 是否有这个方法
- (BOOL) hasSEL:(NSString *) sel;
// 运行方法
- (id) runSEL:(SEL)sel withObjects:(NSArray *)objects;

@end
