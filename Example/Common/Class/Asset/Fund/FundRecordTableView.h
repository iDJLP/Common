//
//  FundRecordTableView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/4/26.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FundRecordType) {
    
    FundRecordTypeOtcDeposit=1,
    FundRecordTypeChainDeposit=2,
    FundRecordTypeOtcDrawl=3,
    FundRecordTypeChainDrawl=4,
    FundRecordTypeTransfer=5,
} ;

@interface FundRecordSectionView : UIScrollView

- (instancetype)initWithList:(NSArray *)list;
@property (nonatomic, copy)void(^didSelectedHander)(NSInteger);
- (void)updateMoveIndex:(NSInteger)index;
-(void)setSelected:(NSInteger)selectedIndex;

@end

@interface FundRecordTableView : UITableView
@property (nonatomic,assign) FundRecordType type;
@property (nonatomic,copy) NSString *params;
- (void)viewWillAppear;
- (void)refreshView;
@end

NS_ASSUME_NONNULL_END
