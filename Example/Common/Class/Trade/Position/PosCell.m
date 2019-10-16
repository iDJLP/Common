//
//  PosCell.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/23.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "PosCell.h"
#import "View.h"
#import "BaseView.h"
#import "BaseLabel.h"
#import "BaseBtn.h"

@interface PosCell ()

@property (nonatomic,strong)BaseView *bgview;

@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *orderLabel;
@property (nonatomic,strong)UIImageView *arrowImg;

@property (nonatomic,strong)SingleInfoView *left1View;
@property (nonatomic,strong)SingleInfoView *right1View;
@property (nonatomic,strong)SingleInfoView *left2View;
@property (nonatomic,strong)SingleInfoView *right2View;
@property (nonatomic,strong)SingleInfoView *left3View;
@property (nonatomic,strong)SingleInfoView *right3View;
@property (nonatomic,strong)SingleInfoView *left4View;
@property (nonatomic,strong)SingleInfoView *right4View;
@property (nonatomic,strong)SingleInfoView *left5View;
@property (nonatomic,strong)SingleInfoView *right5View;
@property (nonatomic,strong)SingleInfoView *left6View;
@property (nonatomic,strong)SingleInfoView *right6View;
@property (nonatomic,strong)SingleInfoView *left7View;
@property (nonatomic,strong)SingleInfoView *right7View;

@property (nonatomic,strong)BaseView *line;
@property (nonatomic,strong)BaseBtn *slBtn;
@property (nonatomic,strong)BaseBtn *tpBtn;
@property (nonatomic,strong)BaseBtn *closeBtn;
@property (nonatomic,strong)BaseView *line1;
@property (nonatomic,strong)BaseView *line2;

@property (nonatomic,strong)MASConstraint *masLineTop;
@property (nonatomic,strong)NSMutableDictionary *config;
@property (nonatomic,weak)OrderKeyBoardView *keyboardView;

@end

@implementation PosCell

+ (CGFloat)heightOfCell:(NSMutableDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return 0;
    }
    CGFloat singleH = 0;
    if ([[FTConfig sharedInstance].lang isEqualToString:@"en"]){
        singleH = [GUIUtil fitFont:12].lineHeight*2+[GUIUtil fit:8];
    }else{
        singleH = [GUIUtil fitFont:12].lineHeight+[GUIUtil fit:5];
    }
    
    CGFloat height = [GUIUtil fit:45]+[GUIUtil fit:10]+singleH*2+[GUIUtil fit:40];
    if ([NDataUtil boolWithDic:dict key:@"isUnFold" isEqual:@"1"]) {
        height += singleH*5;
    }
    return ceil(height);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.bgColorType = C23_ColorType;
        [self setupUI];
        [self autoLayout];
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.bgview];
    [self.bgview addSubview:self.topView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.orderLabel];
    [self.contentView addSubview:self.arrowImg];
    [self.contentView addSubview:self.left1View];
    [self.contentView addSubview:self.right1View];
    [self.contentView addSubview:self.left2View];
    [self.contentView addSubview:self.right2View];
    [self.contentView addSubview:self.left3View];
    [self.contentView addSubview:self.right3View];
    [self.contentView addSubview:self.left4View];
    [self.contentView addSubview:self.right4View];
    [self.contentView addSubview:self.left5View];
    [self.contentView addSubview:self.right5View];
    [self.contentView addSubview:self.left6View];
    [self.contentView addSubview:self.right6View];
    [self.contentView addSubview:self.left7View];
    [self.contentView addSubview:self.right7View];
    [self.contentView addSubview:self.slBtn];
    [self.contentView addSubview:self.tpBtn];
    [self.contentView addSubview:self.closeBtn];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.line1];
    [self.contentView addSubview:self.line2];
}

- (void)autoLayout{
    [_bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.top.mas_equalTo([GUIUtil fit:15]);
        make.bottom.equalTo(self.slBtn);
    }];
    [self.topView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:0]);
        make.right.mas_equalTo([GUIUtil fit:0]);
        make.top.mas_equalTo([GUIUtil fit:0]);
        make.height.mas_equalTo([GUIUtil fit:30]);
    }];
    [self.nameLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:25]);
        make.height.mas_equalTo([GUIUtil fit:30]);
        make.top.mas_equalTo([GUIUtil fit:15]);
    }];
    [self.orderLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:120]);
        make.height.mas_equalTo([GUIUtil fit:30]);
        make.top.mas_equalTo([GUIUtil fit:15]);
    }];
    [self.arrowImg  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-25]);
        make.centerY.equalTo(self.topView);
    }];
    [self.left1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:25]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.topView.mas_bottom).mas_offset([GUIUtil fit:10]);
    }];
    [self.right1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:195]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.topView.mas_bottom).mas_offset([GUIUtil fit:10]);
    }];
    [self.left2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:25]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.left1View.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.right2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:195]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.left1View.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.left3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:25]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.left2View.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.right3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:195]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.left2View.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.left4View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:25]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.right3View.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.right4View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:195]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.right3View.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.left5View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:25]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.left4View.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.right5View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:195]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.left4View.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.left6View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:25]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.left5View.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.right6View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:195]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.left5View.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.left7View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:25]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.left6View.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.right7View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:195]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.left6View.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.height.mas_equalTo([GUIUtil fitLine]*2);
        self.masLineTop = make.top.equalTo(self.left7View.mas_bottom).mas_offset([GUIUtil fit:10]);
        make.top.equalTo(self.left2View.mas_bottom).mas_offset([GUIUtil fit:10]).priority(750);
    }];
    [_tpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.width.mas_equalTo((SCREEN_WIDTH-[GUIUtil fit:30])/3);
        make.height.mas_equalTo([GUIUtil fit:35]);
        make.top.equalTo(self.line);
    }];
    [_slBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo((SCREEN_WIDTH-[GUIUtil fit:30])/3);
        make.height.mas_equalTo([GUIUtil fit:35]);
        make.top.equalTo(self.line);
    }];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.width.mas_equalTo((SCREEN_WIDTH-[GUIUtil fit:30])/3);
        make.height.mas_equalTo([GUIUtil fit:35]);
        make.top.equalTo(self.line);
    }];
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tpBtn.mas_right);
        make.height.mas_equalTo([GUIUtil fit:35]);
        make.width.mas_equalTo([GUIUtil fitLine]);
        make.centerY.equalTo(self.tpBtn);
    }];
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.slBtn.mas_right);
        make.height.mas_equalTo([GUIUtil fit:35]);
        make.width.mas_equalTo([GUIUtil fitLine]);
        make.centerY.equalTo(self.tpBtn);
    }];
}

//MARK: - Action

- (void)tapAction{
    if ([NDataUtil boolWithDic:_config key:@"isUnFold" isEqual:@"1"]) {
        [_config setObject:@"0" forKey:@"isUnFold"];
    }else{
        [_config setObject:@"1" forKey:@"isUnFold"];
    }
    _reloadDataHander();
}

- (void)slAction{
    _keyboardView = _setterSLTPHaner(OrderKeyBoardTypeSl,_config);
}
- (void)tpAction{
   _keyboardView = _setterSLTPHaner(OrderKeyBoardTypeTP,_config);
}
- (void)closeAction{
    _closePosAction(_config);
}

- (void)configCell:(NSMutableDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _config = dict;
    BOOL isBuy = [NDataUtil boolWithDic:dict key:@"direction" isEqual:@"1"];
    _nameLabel.text = [NDataUtil stringWith:dict[@"contractname"]];
    NSString *orderType = isBuy?CFDLocalizedString(@"买入"):CFDLocalizedString(@"卖出");
    _topView.backgroundColor = isBuy?[GColorUtil C17]:[GColorUtil C18];
    NSString *qu = [NDataUtil stringWith:dict[@"quantity"]];
    NSString *q = [GUIUtil equalValue:qu with:@"1"]?CFDLocalizedString(@"手"):CFDLocalizedString(@"手_复数");
    _orderLabel.text = [NSString stringWithFormat:@"%@   %@%@",orderType,qu,q];
    NSString *profit = [NDataUtil stringWith:dict[@"profit"]];
    ColorType colortype = [GColorUtil colorTypeWithProfitString:profit];
    NSString *profitNum = [NDataUtil stringWith:dict[@"profitnum"]];
    NSString *p = [GUIUtil equalValue:profitNum with:@"1"]?CFDLocalizedString(@"点"):CFDLocalizedString(@"点_复数");
    profit = [NSString stringWithFormat:@"%@(%@%@)",profit,profitNum,p];
    [_left1View configOfInfo:@{@"key":CFDLocalizedString(@"盈亏"),@"value":profit,@"colortype":@(colortype)}];
    NSString *marign = [NSString stringWithFormat:@"%@USDT",[NDataUtil stringWith:dict[@"margin"]]];
    [_right1View configOfInfo:@{@"key":CFDLocalizedString(@"保证金"),@"value":marign}];
    [_left2View configOfInfo:@{@"key":CFDLocalizedString(@"开仓"),@"value":[NDataUtil stringWith:dict[@"buyprice"]]}];
    [_right2View configOfInfo:@{@"key":CFDLocalizedString(@"最新平仓"),@"value":[NDataUtil stringWith:dict[@"nowprice"]]}];
    [_left3View configOfInfo:@{@"key":CFDLocalizedString(@"止盈价位"),@"value":[NDataUtil stringWith:dict[@"stopprofitprice"]]}];
    [_right3View configOfInfo:@{@"key":CFDLocalizedString(@"止损价位"),@"value":[NDataUtil stringWith:dict[@"stoplossprice"]]}];
    NSString *stoplossnum = [NDataUtil stringWith:dict[@"stoplossnum"]];
    NSString *stoplossp = [GUIUtil equalValue:stoplossnum with:@"1"]?CFDLocalizedString(@"点"):CFDLocalizedString(@"点_复数");
    NSString *slPoint = [NSString stringWithFormat:@"%@%@",stoplossnum,stoplossp];
    if ([slPoint hasPrefix:@"-"]) {
        slPoint = [slPoint substringFromIndex:1];
    }
    NSString *stopprofitnum = [NDataUtil stringWith:dict[@"stopprofitnum"]];
    NSString *stopprofitp = [GUIUtil equalValue:stopprofitnum with:@"1"]?CFDLocalizedString(@"点"):CFDLocalizedString(@"点_复数");
    NSString *tpPoint = [NSString stringWithFormat:@"%@%@",stopprofitnum,stopprofitp];
    [_left4View configOfInfo:@{@"key":CFDLocalizedString(@"止盈点数"),@"value":tpPoint}];
    [_right4View configOfInfo:@{@"key":CFDLocalizedString(@"止损点数"),@"value":slPoint}];
    NSString *tpPrecent = [NSString stringWithFormat:@"%@%%",[GUIUtil decimalMultiply:[NDataUtil stringWith:dict[@"stopprofitprecent"]] num:@"100"]];
    NSString *slPrecent = [NSString stringWithFormat:@"%@%%",[GUIUtil decimalMultiply:[NDataUtil stringWith:dict[@"stoplossprecent"]] num:@"100"]];
    if ([slPrecent hasPrefix:@"-"]) {
        slPrecent = [slPrecent substringFromIndex:1];
    }
    [_left5View configOfInfo:@{@"key":CFDLocalizedString(@"止盈比例"),@"value":tpPrecent}];
    [_right5View configOfInfo:@{@"key":CFDLocalizedString(@"止损比例"),@"value":slPrecent}];
    
    NSString *tradefee = [NSString stringWithFormat:@"%@USDT",[NDataUtil stringWith:dict[@"tradefee"]]];
    [_left6View configOfInfo:@{@"key":CFDLocalizedString(@"手续费"),@"value":tradefee}];
    NSString *pryBar = [NSString stringWithFormat:@"%@%@",[NDataUtil stringWith:dict[@"pryBar"]],CFDLocalizedString(@"倍")];
    [_right6View configOfInfo:@{@"key":CFDLocalizedString(@"杠杆倍数"),@"value":pryBar}];
    [_left7View configOfInfo:@{@"key":CFDLocalizedString(@"开仓时间"),@"value":[NDataUtil stringWith:dict[@"opentime"]]}];
    [_right7View configOfInfo:@{@"key":CFDLocalizedString(@"单号"),@"value":[NDataUtil stringWith:dict[@"orderno"]]}];
    
    
    if ([NDataUtil boolWithDic:dict key:@"isUnFold" isEqual:@"1"]) {
        [_masLineTop activate];
        _arrowImg.image = [GColorUtil imageNamed:@"trade_icon_under_up"];
        _left3View.hidden = _right3View.hidden = _left4View.hidden = _right4View.hidden = _left5View.hidden = _right5View.hidden =    _left6View.hidden = _right6View.hidden =
            _left7View.hidden = _right7View.hidden = NO;
    }else{
        [_masLineTop deactivate];
        _arrowImg.image = [GColorUtil imageNamed:@"trade_icon_under_down"];
        _left3View.hidden = _right3View.hidden = _left4View.hidden = _right4View.hidden = _left5View.hidden = _right5View.hidden = _left6View.hidden = _right6View.hidden =
            _left7View.hidden = _right7View.hidden = YES;
    }
    if ([NDataUtil boolWithDic:_keyboardView.config key:@"orderno" isEqual:[NDataUtil stringWith:_config[@"orderno"]]]) {
        [_keyboardView changedProfit:_config];
    }
}

//MARK:Getter

- (BaseView *)bgview{
    if (!_bgview) {
        _bgview = [[BaseView alloc] init];
        _bgview.bgColor = C15_ColorType;
        _bgview.bgLayerColor = C19_ColorType;
        _bgview.layer.borderWidth = [GUIUtil fitLine];
        _bgview.layer.masksToBounds = YES;
        _bgview.layer.cornerRadius = 2;
    }
    return _bgview;
}

- (UIView *)topView{
    if (!_topView) {
        _topView= [[UILabel alloc] init];
        WEAK_SELF;
        [_topView g_clickBlock:^(UITapGestureRecognizer *tap) {
            [weakSelf tapAction];
        }];
    }
    return _topView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel= [[UILabel alloc] init];
        _nameLabel.textColor = [GColorUtil C5];
        _nameLabel.font = [GUIUtil fitFont:14];
    }
    return _nameLabel;
}
- (UILabel *)orderLabel{
    if (!_orderLabel) {
        _orderLabel= [[UILabel alloc] init];
        _orderLabel.textColor = [GColorUtil C5];
        _orderLabel.font = [GUIUtil fitFont:12];
    }
    return _orderLabel;
}
- (UIImageView *)arrowImg{
    if (!_arrowImg) {
        _arrowImg= [[UIImageView alloc] init];
        _arrowImg.image = [GColorUtil imageNamed:@"trade_icon_under_down"];
    }
    return _arrowImg;
}

- (SingleInfoView *)left1View{
    if(!_left1View){
        _left1View = [[SingleInfoView alloc] init];
        _left1View.alignment = SingleInfoAlignmentSide;
        _left1View.needChangedStyle = YES;
        [_left1View configOfInfo:@{@"key":CFDLocalizedString(@"盈亏"),@"value":@"--"}];
    }
    return _left1View;
}
- (SingleInfoView *)right1View{
    if(!_right1View){
        _right1View = [[SingleInfoView alloc] init];
        _right1View.alignment = SingleInfoAlignmentSide;
        _right1View.needChangedStyle = YES;
        [_right1View configOfInfo:@{@"key":CFDLocalizedString(@"保证金"),@"value":@"--"}];
    }
    return _right1View;
}
- (SingleInfoView *)left2View{
    if(!_left2View){
        _left2View = [[SingleInfoView alloc] init];
        _left2View.alignment = SingleInfoAlignmentSide;
        _left2View.needChangedStyle = YES;
        [_left2View configOfInfo:@{@"key":CFDLocalizedString(@"开仓"),@"value":@"--"}];
    }
    return _left2View;
}
- (SingleInfoView *)right2View{
    if(!_right2View){
        _right2View = [[SingleInfoView alloc] init];
        _right2View.alignment = SingleInfoAlignmentSide;
        _right2View.needChangedStyle = YES;
        [_right2View configOfInfo:@{@"key":CFDLocalizedString(@"最新平仓"),@"value":@"--"}];
    }
    return _right2View;
}
- (SingleInfoView *)left3View{
    if(!_left3View){
        _left3View = [[SingleInfoView alloc] init];
        _left3View.alignment = SingleInfoAlignmentSide;
        _left3View.needChangedStyle = YES;
        [_left3View configOfInfo:@{@"key":CFDLocalizedString(@"止盈价位"),@"value":@"--"}];
    }
    return _left3View;
}
- (SingleInfoView *)right3View{
    if(!_right3View){
        _right3View = [[SingleInfoView alloc] init];
        _right3View.alignment = SingleInfoAlignmentSide;
        _right3View.needChangedStyle = YES;
        [_right3View configOfInfo:@{@"key":CFDLocalizedString(@"止损价位"),@"value":@"--"}];
    }
    return _right3View;
}
- (SingleInfoView *)left4View{
    if(!_left4View){
        _left4View = [[SingleInfoView alloc] init];
        _left4View.alignment = SingleInfoAlignmentSide;
        _left4View.needChangedStyle = YES;
        [_left4View configOfInfo:@{@"key":CFDLocalizedString(@"止盈点数"),@"value":@"--"}];
    }
    return _left4View;
}
- (SingleInfoView *)right4View{
    if(!_right4View){
        _right4View = [[SingleInfoView alloc] init];
        _right4View.alignment = SingleInfoAlignmentSide;
        _right4View.needChangedStyle = YES;
        [_right4View configOfInfo:@{@"key":CFDLocalizedString(@"止损点数"),@"value":@"--"}];
    }
    return _right4View;
}
- (SingleInfoView *)left5View{
    if(!_left5View){
        _left5View = [[SingleInfoView alloc] init];
        _left5View.alignment = SingleInfoAlignmentSide;
        _left5View.needChangedStyle = YES;
        [_left5View configOfInfo:@{@"key":CFDLocalizedString(@"止盈比例"),@"value":@"--"}];
    }
    return _left5View;
}
- (SingleInfoView *)right5View{
    if(!_right5View){
        _right5View = [[SingleInfoView alloc] init];
        _right5View.alignment = SingleInfoAlignmentSide;
        _right5View.needChangedStyle = YES;
        [_right5View configOfInfo:@{@"key":CFDLocalizedString(@"止损比例"),@"value":@"--"}];
    }
    return _right5View;
}
- (SingleInfoView *)left6View{
    if(!_left6View){
        _left6View = [[SingleInfoView alloc] init];
        _left6View.alignment = SingleInfoAlignmentSide;
        _left6View.needChangedStyle = YES;
        [_left6View configOfInfo:@{@"key":CFDLocalizedString(@"手续费"),@"value":@"--"}];
    }
    return _left6View;
}
- (SingleInfoView *)right6View{
    if(!_right6View){
        _right6View = [[SingleInfoView alloc] init];
        _right6View.alignment = SingleInfoAlignmentSide;
        _right6View.needChangedStyle = YES;
        [_right6View configOfInfo:@{@"key":CFDLocalizedString(@"杠杆倍数"),@"value":@"--"}];
    }
    return _right6View;
}
- (SingleInfoView *)left7View{
    if(!_left7View){
        _left7View = [[SingleInfoView alloc] init];
        _left7View.alignment = SingleInfoAlignmentSide;
        _left7View.needChangedStyle = YES;
        [_left7View configOfInfo:@{@"key":CFDLocalizedString(@"开仓时间"),@"value":@"--"}];
    }
    return _left7View;
}
- (SingleInfoView *)right7View{
    if(!_right7View){
        _right7View = [[SingleInfoView alloc] init];
        _right7View.alignment = SingleInfoAlignmentSide;
        _right7View.needChangedStyle = YES;
        [_right7View configOfInfo:@{@"key":CFDLocalizedString(@"单号"),@"value":@"--"}];
    }
    return _right7View;
}

-(BaseView *)line{
    if(!_line){
        _line = [[BaseView alloc] init];
        _line.bgColor = C7_ColorType;
    }
    return _line;
}

-(BaseBtn *)slBtn{
    if(!_slBtn){
        _slBtn = [[BaseBtn alloc] init];
        _slBtn.backgroundColor = [UIColor clearColor];
        _slBtn.titleLabel.font = [GUIUtil fitFont:12];
        _slBtn.textBlock = CFDLocalizedStringBlock(@"止损设置");
        _slBtn.txColor = C13_ColorType;
        [_slBtn addTarget:self action:@selector(slAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _slBtn;
}
-(BaseBtn *)tpBtn{
    if(!_tpBtn){
        _tpBtn = [[BaseBtn alloc] init];
        _tpBtn.backgroundColor = [UIColor clearColor];
        _tpBtn.titleLabel.font = [GUIUtil fitFont:12];
        _tpBtn.textBlock = CFDLocalizedStringBlock(@"止盈设置");
        _tpBtn.txColor = C13_ColorType;
        [_tpBtn addTarget:self action:@selector(tpAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tpBtn;
}
-(BaseBtn *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [[BaseBtn alloc] init];
        _closeBtn.backgroundColor = [UIColor clearColor];
        _closeBtn.titleLabel.font = [GUIUtil fitFont:12];
        _closeBtn.textBlock = CFDLocalizedStringBlock(@"市价平仓");
        _closeBtn.txColor = C13_ColorType;
        [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

-(BaseView *)line1{
    if(!_line1){
        _line1 = [[BaseView alloc] init];
        _line1.bgColor = C7_ColorType;
    }
    return _line1;
}
-(BaseView *)line2{
    if(!_line2){
        _line2 = [[BaseView alloc] init];
        _line2.bgColor = C7_ColorType;
    }
    return _line2;
}
@end
