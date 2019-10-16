//
//  TradeAnalyseVC.m
//  Bitmixs
//
//  Created by ngw15 on 2019/10/11.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "TradeAnalyseVC.h"
#import "TradeSelectedChoiceView.h"

@interface TradeAnalyseVC ()

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) CAGradientLayer *typeLayer;
@property (nonatomic,strong) CAGradientLayer *dateLayer;

@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UILabel *typeTitle;
@property (nonatomic,strong) UILabel *typeText;
@property (nonatomic,strong) UILabel *dateTitle;
@property (nonatomic,strong) UILabel *dateText;
@property (nonatomic,strong) UILabel *title1Label;
@property (nonatomic,strong) UILabel *text1Label;
@property (nonatomic,strong) UILabel *title2Label;
@property (nonatomic,strong) UILabel *text2Label;
@property (nonatomic,strong) UILabel *title3Label;
@property (nonatomic,strong) UILabel *text3Label;

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UILabel *title4Label;
@property (nonatomic,strong) UILabel *text4Label;
@property (nonatomic,strong) UILabel *title5Label;
@property (nonatomic,strong) UILabel *text5Label;
@property (nonatomic,strong) UILabel *title6Label;
@property (nonatomic,strong) UILabel *text6Label;
@property (nonatomic,strong) UILabel *title7Label;
@property (nonatomic,strong) UILabel *text7Label;
@property (nonatomic,strong) UILabel *title8Label;
@property (nonatomic,strong) UILabel *text8Label;
@property (nonatomic,strong) TradeSelectedChoiceView *choiceView;

@property (nonatomic,strong) NSDictionary *params;
@property (nonatomic,strong) NSURLSessionDataTask *task;

@end

@implementation TradeAnalyseVC

+(void)jumpTo{
    TradeAnalyseVC *target = [[TradeAnalyseVC alloc] init];
    target.hidesBottomBarWhenPushed = YES;
    [GJumpUtil pushVC:target animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _params = @{@"timetype":@"0",@"symbol":@""};
    self.title = CFDLocalizedString(@"交易分析");
    self.view.backgroundColor = [GColorUtil C6];
    [self setupUI];
    [self autoLayout];
    [self loadData];
    WEAK_SELF;
    [GNavUtil rightTitle:self title:CFDLocalizedString(@"筛选") color:C22_ColorType onClick:^{
        NSDictionary *params = weakSelf.params;
        if (!weakSelf.choiceView.superview) {
            [weakSelf.view addSubview:weakSelf.choiceView];
        }
        [weakSelf.choiceView willAppear:params];
    }];
    [GUIUtil refreshWithHeader:_scrollView refresh:^{
        [weakSelf loadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startTimer];
}

- (void)setupUI{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.topView];
    [self.scrollView addSubview:self.bottomView];
    [self.topView.layer addSublayer:self.typeLayer];
    [self.topView.layer addSublayer:self.dateLayer];
    [self.topView addSubview:self.typeTitle];
    [self.topView addSubview:self.typeText];
    [self.topView addSubview:self.dateTitle];
    [self.topView addSubview:self.dateText];
    [self.topView addSubview:self.title1Label];
    [self.topView addSubview:self.text1Label];
    [self.topView addSubview:self.title2Label];
    [self.topView addSubview:self.text2Label];
    [self.topView addSubview:self.title3Label];
    [self.topView addSubview:self.text3Label];
    [self.bottomView addSubview:self.title4Label];
    [self.bottomView addSubview:self.text4Label];
    [self.bottomView addSubview:self.title5Label];
    [self.bottomView addSubview:self.text5Label];
    [self.bottomView addSubview:self.title6Label];
    [self.bottomView addSubview:self.text6Label];
    [self.bottomView addSubview:self.title7Label];
    [self.bottomView addSubview:self.text7Label];
    [self.bottomView addSubview:self.title8Label];
    [self.bottomView addSubview:self.text8Label];
    
}


- (void)autoLayout{
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:0]);
        make.top.right.bottom.mas_equalTo(0);
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:0]);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:0]);
        make.top.equalTo(self.topView.mas_bottom).mas_offset([GUIUtil fit:7]);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.mas_equalTo(0);
    }];
    [self.typeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_left).mas_equalTo([GUIUtil fit:99]);
        make.top.mas_equalTo([GUIUtil fit:41]);
    }];
    [self.typeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_left).mas_equalTo([GUIUtil fit:99]);
        make.top.equalTo(self.typeTitle.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.dateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_left).mas_equalTo([GUIUtil fit:277]);
        make.top.mas_equalTo([GUIUtil fit:41]);
    }];
    [self.dateText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_left).mas_equalTo([GUIUtil fit:277]);
        make.top.equalTo(self.typeTitle.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.title1Label mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.text1Label);
       make.top.equalTo(self.text1Label.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.text1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo([GUIUtil fit:15]);
              make.top.mas_equalTo([GUIUtil fit:140]);
    }];
    [self.title2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.text2Label);
        make.top.equalTo(self.text2Label.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.text2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.equalTo(self.title1Label.mas_bottom).mas_offset([GUIUtil fit:25]);
    }];
    [self.title3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.text3Label);
        make.top.equalTo(self.text3Label.mas_bottom).mas_offset([GUIUtil fit:5]);
        make.bottom.mas_equalTo([GUIUtil fit:-20]);
    }];
    [self.text3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:193]);
        make.top.equalTo(self.text2Label);
    }];
    [self.title4Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.text4Label);
        make.top.equalTo(self.text4Label.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.text4Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
       make.top.mas_equalTo([GUIUtil fit:15]);
    }];
    [self.title5Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.text5Label);
        make.top.equalTo(self.text5Label.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.text5Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.equalTo(self.title4Label.mas_bottom).mas_offset([GUIUtil fit:25]);
    }];
    [self.title6Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.text6Label);
        make.top.equalTo(self.text6Label.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.text6Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:193]);
        make.top.equalTo(self.text5Label);
    }];
    [self.title7Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.text7Label);
        make.top.equalTo(self.text7Label.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.text7Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.equalTo(self.title5Label.mas_bottom).mas_offset([GUIUtil fit:25]);
    }];
    [self.title8Label mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.text8Label);
        make.top.equalTo(self.text8Label.mas_bottom).mas_offset([GUIUtil fit:5]);
        make.bottom.mas_equalTo([GUIUtil fit:-20]);
    }];
    [self.text8Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:193]);
        make.top.equalTo(self.text7Label);
    }];
}

- (void)startTimer{
    WEAK_SELF;
    [NTimeUtil startTimer:@"TradeAnalyseVC" interval:5 repeats:YES action:^{
        [weakSelf loadData];
    }];
}

- (void)loadData{
    _task = [DCService transactionanalysis:[NDataUtil stringWith:_params[@"symbol"] valid:@""] timetype:[NDataUtil stringWith:_params[@"timetype"] valid:@"0"] success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            [self configVC:[NDataUtil dictWith:data[@"data"]]];
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
        }
        [self.scrollView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
        [self.scrollView.mj_header endRefreshing];
    }];
}

- (void)configVC:(NSDictionary *)dict{
    _typeTitle.text = CFDLocalizedString(@"交易合约");
    _dateTitle.text = CFDLocalizedString(@"交易时间");
    _title1Label.text = CFDLocalizedString(@"总盈亏 (USDT)");
    _title2Label.text = CFDLocalizedString(@"已平仓盈亏 (USDT)");
    _title3Label.text = CFDLocalizedString(@"浮动盈亏 (USDT)");
    _title4Label.text = CFDLocalizedString(@"总数(手)");
    _title5Label.text = CFDLocalizedString(@"开仓(手)");
    _title6Label.text = CFDLocalizedString(@"盈利平仓(手)");
    _title7Label.text = CFDLocalizedString(@"撤单(手)");
    _title8Label.text = CFDLocalizedString(@"亏损平仓(手)");
    
    
    NSString *symbol = [NDataUtil stringWith:_params[@"symbolText"] valid:@""];
    if (symbol.length<=0||[symbol isEqualToString:@"ALL"]) {
        _typeText.text = CFDLocalizedString(@"全部");
    }else{
        _typeText.text = symbol;
    }
    if (symbol.length<=0||[symbol isEqualToString:@"ALL"]) {
        _dateText.text = CFDLocalizedString(@"全部");
    }else{
        _dateText.text = [NDataUtil stringWith:_params[@"timetypeText"] valid:@""];
    }
    _text1Label.text = [NDataUtil stringWith:dict[@"totalProfit"] valid:@""];
    _text1Label.textColor = [GColorUtil colorWithProfitString:_text1Label.text];
    _text2Label.text = [NDataUtil stringWith:dict[@"totalClosedProfit"] valid:@""];
    _text2Label.textColor = [GColorUtil colorWithProfitString:_text2Label.text];
    _text3Label.text = [NDataUtil stringWith:dict[@"totalPositionProfit"] valid:@""];
    _text3Label.textColor = [GColorUtil colorWithProfitString:_text3Label.text];
    _text4Label.text = [NDataUtil stringWith:dict[@"totalQuantity"] valid:@""];
    _text5Label.text = [NDataUtil stringWith:dict[@"totalOpenQuantity"] valid:@""];
    _text6Label.text = [NDataUtil stringWith:dict[@"totalCanceledQuantity"] valid:@""];
    _text7Label.text = [NDataUtil stringWith:dict[@"totalProfitClosedQuantity"] valid:@""];
    _text8Label.text = [NDataUtil stringWith:dict[@"totalLossClosedQuantity"] valid:@""];
}

//MARK: - Getter

- (TradeSelectedChoiceView *)choiceView{
    if (!_choiceView) {
        _choiceView = [[TradeSelectedChoiceView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - TOP_BAR_HEIGHT)];
        _choiceView.backgroundColor = [GColorUtil colorWithHex:0x000000 alpha:0.4];
        WEAK_SELF;
        _choiceView.loadDataHander = ^(NSDictionary * _Nonnull params) {
            weakSelf.params = params;
            [FOWebService cancelTask:weakSelf.task];
            [weakSelf loadData];
        };
    }
    return _choiceView;
}


- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [GColorUtil C8];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = YES;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.alwaysBounceHorizontal = NO;
        _scrollView.userInteractionEnabled = YES;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _scrollView;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [GColorUtil C6];
    }
    return _topView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [GColorUtil C6];
    }
    return _bottomView;
}

- (CAGradientLayer *)typeLayer{
    if (!_typeLayer) {
        _typeLayer =  [[CAGradientLayer alloc] init];
        _typeLayer.frame = CGRectMake([GUIUtil fit:15], [GUIUtil fit:18], [GUIUtil fit:167], [GUIUtil fit:90]);
        _typeLayer.colors = @[(__bridge id)[GColorUtil colorWithHex:0x6251E9].CGColor,(__bridge id)[GColorUtil colorWithHex:0x5C9AF1].CGColor];
        _typeLayer.locations = @[@(0),@(1)];
        _typeLayer.startPoint = CGPointMake(0, 0);
        _typeLayer.endPoint = CGPointMake(1, 0);
        _typeLayer.cornerRadius = [GUIUtil fit:10];
        _typeLayer.masksToBounds = YES;
    }
    return _typeLayer;
}

- (CAGradientLayer *)dateLayer{
    if (!_dateLayer) {
        _dateLayer =  [[CAGradientLayer alloc] init];
        _dateLayer.frame = CGRectMake([GUIUtil fit:193], [GUIUtil fit:18], [GUIUtil fit:167], [GUIUtil fit:90]);
        _dateLayer.colors = @[(__bridge id)[GColorUtil colorWithHex:0xFEC922].CGColor,(__bridge id)[GColorUtil colorWithHex:0xFF6A1D].CGColor];
        _dateLayer.locations = @[@(0),@(1)];
        _dateLayer.startPoint = CGPointMake(0, 0);
        _dateLayer.endPoint = CGPointMake(1, 0);
        _dateLayer.cornerRadius = [GUIUtil fit:10];
        _dateLayer.masksToBounds = YES;
    }
    return _dateLayer;
}

- (UILabel *)typeTitle{
    if(!_typeTitle){
        _typeTitle = [[UILabel alloc] init];
        _typeTitle.textColor = [GColorUtil C5];
        _typeTitle.font = [GUIUtil fitFont:12];
    }
    return _typeTitle;
}
- (UILabel *)typeText{
    if(!_typeText){
        _typeText = [[UILabel alloc] init];
        _typeText.textColor = [GColorUtil C5];
        _typeText.font = [GUIUtil fitBoldFont:16];
    }
    return _typeText;
}
- (UILabel *)dateTitle{
    if(!_dateTitle){
        _dateTitle = [[UILabel alloc] init];
        _dateTitle.textColor = [GColorUtil C5];
        _dateTitle.font = [GUIUtil fitFont:12];
    }
    return _dateTitle;
}
- (UILabel *)dateText{
    if(!_dateText){
        _dateText = [[UILabel alloc] init];
        _dateText.textColor = [GColorUtil C5];
        _dateText.font = [GUIUtil fitFont:16];
    }
    return _dateText;
}
- (UILabel *)title1Label{
    if(!_title1Label){
        _title1Label = [[UILabel alloc] init];
        _title1Label.textColor = [GColorUtil C3];
        _title1Label.font = [GUIUtil fitFont:10];
    }
    return _title1Label;
}
- (UILabel *)text1Label{
    if(!_text1Label){
        _text1Label = [[UILabel alloc] init];
        _text1Label.textColor = [GColorUtil C2];
        _text1Label.font = [GUIUtil fitBoldFont:20];
    }
    return _text1Label;
}
- (UILabel *)title2Label{
    if(!_title2Label){
        _title2Label = [[UILabel alloc] init];
        _title2Label.textColor = [GColorUtil C3];
        _title2Label.font = [GUIUtil fitFont:10];
    }
    return _title2Label;
}
- (UILabel *)text2Label{
    if(!_text2Label){
        _text2Label = [[UILabel alloc] init];
        _text2Label.textColor = [GColorUtil C2];
        _text2Label.font = [GUIUtil fitBoldFont:20];
    }
    return _text2Label;
}
- (UILabel *)title3Label{
    if(!_title3Label){
        _title3Label = [[UILabel alloc] init];
        _title3Label.textColor = [GColorUtil C3];
        _title3Label.font = [GUIUtil fitFont:10];
    }
    return _title3Label;
}
- (UILabel *)text3Label{
    if(!_text3Label){
        _text3Label = [[UILabel alloc] init];
        _text3Label.textColor = [GColorUtil C2];
        _text3Label.font = [GUIUtil fitBoldFont:20];
    }
    return _text3Label;
}
- (UILabel *)title4Label{
    if(!_title4Label){
        _title4Label = [[UILabel alloc] init];
        _title4Label.textColor = [GColorUtil C3];
        _title4Label.font = [GUIUtil fitFont:12];
    }
    return _title4Label;
}
- (UILabel *)text4Label{
    if(!_text4Label){
        _text4Label = [[UILabel alloc] init];
        _text4Label.textColor = [GColorUtil C2];
        _text4Label.font = [GUIUtil fitBoldFont:14];
    }
    return _text4Label;
}
- (UILabel *)title5Label{
    if(!_title5Label){
        _title5Label = [[UILabel alloc] init];
        _title5Label.textColor = [GColorUtil C3];
        _title5Label.font = [GUIUtil fitFont:12];
    }
    return _title5Label;
}
- (UILabel *)text5Label{
    if(!_text5Label){
        _text5Label = [[UILabel alloc] init];
        _text5Label.textColor = [GColorUtil C2];
        _text5Label.font = [GUIUtil fitBoldFont:14];
    }
    return _text5Label;
}
- (UILabel *)title6Label{
    if(!_title6Label){
        _title6Label = [[UILabel alloc] init];
        _title6Label.textColor = [GColorUtil C3];
        _title6Label.font = [GUIUtil fitFont:12];
    }
    return _title6Label;
}
- (UILabel *)text6Label{
    if(!_text6Label){
        _text6Label = [[UILabel alloc] init];
        _text6Label.textColor = [GColorUtil C2];
        _text6Label.font = [GUIUtil fitBoldFont:14];
    }
    return _text6Label;
}
- (UILabel *)title7Label{
    if(!_title7Label){
        _title7Label = [[UILabel alloc] init];
        _title7Label.textColor = [GColorUtil C3];
        _title7Label.font = [GUIUtil fitFont:12];
    }
    return _title7Label;
}
- (UILabel *)text7Label{
    if(!_text7Label){
        _text7Label = [[UILabel alloc] init];
        _text7Label.textColor = [GColorUtil C2];
        _text7Label.font = [GUIUtil fitBoldFont:14];
    }
    return _text7Label;
}
- (UILabel *)title8Label{
    if(!_title8Label){
        _title8Label = [[UILabel alloc] init];
        _title8Label.textColor = [GColorUtil C3];
        _title8Label.font = [GUIUtil fitFont:12];
    }
    return _title8Label;
}
- (UILabel *)text8Label{
    if(!_text8Label){
        _text8Label = [[UILabel alloc] init];
        _text8Label.textColor = [GColorUtil C2];
        _text8Label.font = [GUIUtil fitBoldFont:14];
    }
    return _text8Label;
}





@end
