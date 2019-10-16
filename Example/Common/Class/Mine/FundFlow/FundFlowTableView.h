//
//  FundFlowTableView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/3/20.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, FlowOpType) {
    FlowOpTypeAll = 0,
    FlowOpTypeDeposit=1,
    FlowOpTypeDrawl=2,
    FlowOpTypeTrade=3,
    FlowOpTypeSettle=4,
    FlowOpTypeEntrust=5,
    FlowOpTypeCancel=6,
} ;

@interface FundFlowSectionView : UIScrollView

- (instancetype)initWithList:(NSArray *)list;
@property (nonatomic, copy)void(^didSelectedHander)(NSInteger);
- (void)updateMoveIndex:(NSInteger)index;
-(void)setSelected:(NSInteger)selectedIndex;

@end

@interface FundFlowTableView : UITableView

@property (nonatomic,assign) FlowOpType type;
- (void)viewWillAppear;

@end

NS_ASSUME_NONNULL_END
