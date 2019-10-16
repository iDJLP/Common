//
//  OrderKeyBoardView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/3/22.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OrderKeyBoardType) {
    OrderKeyBoardTypePryBr,
    OrderKeyBoardTypeSl,
    OrderKeyBoardTypeTP,
} ;

@interface OrderKeyBoardView : BaseView

@property (nonatomic,copy) void(^didSelelectedRow)(NSDictionary *dic,OrderKeyBoardType type);

@property (nonatomic,copy) NSDictionary *(^calSLTPData)(NSString *precent,BOOL isSl);
@property (nonatomic,copy) NSString *bstype;
@property (nonatomic,assign) NSInteger dotnum;
@property (nonatomic,strong,readonly) NSDictionary *config;

+ (CGFloat)heightOfView:(OrderKeyBoardType)type;
- (void)configView:(OrderKeyBoardType)type list:(NSArray *)dataList selData:(NSString *)data price:(NSString *)price;
- (void)changedPrice:(NSString *)price;
- (void)changedProfit:(NSDictionary *)dic;
- (void)setConfig:(NSDictionary *)dict isEntrust:(BOOL)flag;
@end

NS_ASSUME_NONNULL_END
