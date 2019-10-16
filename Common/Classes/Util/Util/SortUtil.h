//
//  SortUtil.h
//  NWinBoom
//
//  Created by ngw15 on 2018/10/6.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SortUtil : NSObject

///isAscending，yes:从小到大
+ (void)quickSort:(NSMutableArray *)list isAscending:(BOOL)isAs keyHander:(CGFloat(^)(NSDictionary *))keyHander;

@end
