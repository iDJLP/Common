//
//  SetCountView.h
//  niuguwang
//
//  Created by ngw on 2016/11/25.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCountView : UIView

@property (nonatomic , copy) void(^setCountBlock)(NSDictionary *);
@property (nonatomic,strong)NSMutableArray *dataList;
- (void)setSelectedIndex:(NSInteger)index;
-(void)updateData:(NSArray *)array;

@end
