//
//  ChoiceView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/8/6.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BaseView.h"
#import "BaseBtn.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChoiceBtn :BaseBtn
@property (nonatomic,strong)id config;
- (void)configBtn:(id)dic;

@end

@interface ChoiceRow :BaseView

@property(nonatomic,strong)NSMutableArray <ChoiceBtn *>*btnList;
@property(nonatomic,strong)NSMutableArray *dataList;
@property(nonatomic,strong)NSMutableSet *selectedList;
@property(nonatomic,assign)BOOL numberOfChoices;
@property(nonatomic,strong)dispatch_block_t selectedChangedHander;
- (void)configView:(NSArray *)dataList;
- (void)selectedChanged;
@end

@interface ChoiceView : BaseView

@property (nonatomic,strong)void(^loadDataHander)(NSString *params);

- (void)willAppear:(NSString *)parmas;

@end

NS_ASSUME_NONNULL_END
