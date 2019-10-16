//
//  TradeView.m
//  Chart
//
//  Created by ngw15 on 2019/3/8.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "TradeView.h"
#import "TradeCell.h"


@interface TradeSectionView : UIView

@property (nonatomic,strong)UILabel *left1Label;
@property (nonatomic,strong)UILabel *left2Label;
@property (nonatomic,strong)UILabel *right1Label;
@property (nonatomic,strong)UILabel *right2Label;

@end

@implementation TradeSectionView

+ (CGFloat)heightOfView{
    return [GUIUtil fit:34];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [GColorUtil C6];
    [self addSubview:self.left1Label];
    [self addSubview:self.left2Label];
    [self addSubview:self.right1Label];
    [self addSubview:self.right2Label];
    
}

- (void)autoLayout{
    [self.left1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.centerY.mas_equalTo(0);
    }];
    [self.left2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:120]);
        make.centerY.mas_equalTo(0);
    }];
    [self.right1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:222]);
        make.centerY.mas_equalTo(0);
    }];
    [self.right2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.centerY.mas_equalTo(0);
    }];
}

- (UILabel *)left1Label{
    if (!_left1Label) {
        _left1Label = [[UILabel alloc] init];
        _left1Label.textColor = GColorUtil.C4;
        _left1Label.font = [GUIUtil fitFont:10];
        _left1Label.numberOfLines = 1;
        _left1Label.text = CFDLocalizedString(@"时间");
    }
    return _left1Label;
}

- (UILabel *)left2Label{
    if (!_left2Label) {
        _left2Label = [[UILabel alloc] init];
        _left2Label.textColor = GColorUtil.C4;
        _left2Label.font = [GUIUtil fitFont:10];
        _left2Label.numberOfLines = 1;
        _left2Label.text =  CFDLocalizedString(@"方向");
    }
    return _left2Label;
}

- (UILabel *)right1Label{
    if (!_right1Label) {
        _right1Label = [[UILabel alloc] init];
        _right1Label.textColor = GColorUtil.C4;
        _right1Label.font = [GUIUtil fitFont:10];
        _right1Label.numberOfLines = 1;
        _right1Label.text = CFDLocalizedString(@"价格");
    }
    return _right1Label;
}

- (UILabel *)right2Label{
    if (!_right2Label) {
        _right2Label = [[UILabel alloc] init];
        _right2Label.textColor = GColorUtil.C4;
        _right2Label.font = [GUIUtil fitFont:10];
        _right2Label.numberOfLines = 1;
        _right2Label.text =  CFDLocalizedString(@"数量(手)");
    }
    return _right2Label;
}



@end


@interface TradeView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,assign) BOOL isLoaded;
@property (nonatomic,copy)NSString *symobl;

@property (nonatomic,strong) TradeSectionView *sectionView;
@end

@implementation TradeView

- (instancetype)initWithSymbol:(NSString *)symbol{
    if (self = [super initWithFrame:CGRectZero style:UITableViewStylePlain]) {
        _symobl = symbol;
        self.backgroundColor = [GColorUtil C6];
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSelectionStyleNone;
        [self registerClass:[TradeCell class] forCellReuseIdentifier:@"TradeCell"];
        StateView *state = [StateUtil show:self type:StateTypeProgress];
        [state mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, [GUIUtil fit:250]));
        }];
        _dataList = [NSMutableArray array];
    }
    return self;
}

- (void)refreshData{
    [self loadData:NO];
}

- (void)willAppear{
    [self startTimer];
}
- (void)willDisAppear{
    
}

- (void)startTimer{
    WEAK_SELF;
    [NTimeUtil startTimer:@"ChartsVC_child" interval:3 repeats:YES action:^{
        [weakSelf loadData:YES];
    }];
}

- (void)loadData:(BOOL)isAuto{
    WEAK_SELF;
    [DCService tradeData:_symobl success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            weakSelf.dataList=data[@"data"];
            if (weakSelf.dataList.count<=0) {
                StateView *state = [StateUtil show:weakSelf type:StateTypeNodata];
                [state mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.mas_equalTo(0);
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, [GUIUtil fit:250]));
                }];
                [weakSelf reloadData];
                return ;
            }
            [weakSelf reloadData];
            weakSelf.isLoaded = YES;
            [StateUtil hide:weakSelf];
        }else{
            if (!isAuto) {
                [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
                if (weakSelf.isLoaded==NO) {
                    ReloadStateView *stateView = (ReloadStateView *)[StateUtil show:weakSelf type:StateTypeReload];
                    stateView.onReload = ^{
                        [weakSelf loadData:NO];
                    };
                    [stateView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.top.mas_equalTo(0);
                        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, [GUIUtil fit:250]));
                    }];
                }
            }
        }
    } failure:^(NSError *error) {
        if (!isAuto) {
            [HUDUtil showInfo:[FTConfig webTips]];
            if (weakSelf.isLoaded==NO) {
                ReloadStateView *stateView = (ReloadStateView *)[StateUtil show:weakSelf type:StateTypeReload];
                stateView.onReload = ^{
                    [weakSelf loadData:NO];
                };
                [stateView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.mas_equalTo(0);
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, [GUIUtil fit:250]));
                }];
            }
        }
    }];
}

- (void)changedSymbol:(NSString *)symbol{
    if (![_symobl isEqualToString:symbol]&&symbol.length>0) {
        _symobl = symbol;
        [_dataList removeAllObjects];
        [self reloadData];
        [self loadData:NO];
    }
}


//MARK: - TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TradeCell *cell=[tableView dequeueReusableCellWithIdentifier:@"TradeCell"];
    [cell configOfCell:[NDataUtil dataWithArray:_dataList index:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [TradeCell heightOfCell];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [TradeSectionView heightOfView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_scrollDelegate scrollViewDidScroll:scrollView];
}

- (TradeSectionView *)sectionView{
    if (!_sectionView) {
        _sectionView = [[TradeSectionView alloc] init];
    }
    return _sectionView;
}

@end
