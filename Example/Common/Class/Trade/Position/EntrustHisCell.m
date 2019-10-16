//
//  EntrustHisCell.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/25.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "EntrustHisCell.h"
#import "View.h"

@interface EntrustHisCell ()

@property (nonatomic,strong)BaseView *bgview;

@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *orderLabel;
@property (nonatomic,strong)UILabel *typeLabel;
@property (nonatomic,strong)UIImageView *arrowImg;

@property (nonatomic,strong)SingleInfoView *amountView;
@property (nonatomic,strong)SingleInfoView *marignView;
@property (nonatomic,strong)SingleInfoView *entrustPriceView;
@property (nonatomic,strong)SingleInfoView *tradePriceView;
@property (nonatomic,strong)SingleInfoView *pryView;
@property (nonatomic,strong)SingleInfoView *tpPriceView;
@property (nonatomic,strong)SingleInfoView *slPriceView;
@property (nonatomic,strong)SingleInfoView *tpPointView;
@property (nonatomic,strong)SingleInfoView *slPointView;
@property (nonatomic,strong)SingleInfoView *tpPrecentView;
@property (nonatomic,strong)SingleInfoView *slPrecentView;
@property (nonatomic,strong)SingleInfoView *feeView;
@property (nonatomic,strong)SingleInfoView *ordernoView;
@property (nonatomic,strong)SingleInfoView *dateView;
@property (nonatomic,strong)SingleInfoView *noView;

@property (nonatomic,strong)MASConstraint *masTimeTop;
@property (nonatomic,strong)NSMutableDictionary *config;

@end

@implementation EntrustHisCell

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
    CGFloat height = [GUIUtil fit:45]+[GUIUtil fit:10]+singleH*3+[GUIUtil fit:5];
    if ([NDataUtil boolWithDic:dict key:@"isUnFold" isEqual:@"1"]) {
        if ([NDataUtil boolWithDic:dict key:@"orderstatus" isEqual:@"3"]){
            height += singleH*5;
        }else{
            height += singleH*4;
        }
    }
    return ceil(height);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.arrowImg];
    [self.contentView addSubview:self.amountView];
    [self.contentView addSubview:self.marignView];
    [self.contentView addSubview:self.entrustPriceView];
    [self.contentView addSubview:self.tradePriceView];
    [self.contentView addSubview:self.ordernoView];
    [self.contentView addSubview:self.tpPriceView];
    [self.contentView addSubview:self.slPriceView];
    [self.contentView addSubview:self.tpPointView];
    [self.contentView addSubview:self.slPointView];
    [self.contentView addSubview:self.tpPrecentView];
    [self.contentView addSubview:self.slPrecentView];
    [self.contentView addSubview:self.feeView];
    [self.contentView addSubview:self.pryView];
    [self.contentView addSubview:self.dateView];
    [self.contentView addSubview:self.noView];
}

- (void)autoLayout{
    [_bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.top.mas_equalTo([GUIUtil fit:15]);
        make.bottom.mas_equalTo(0);
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
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImg.mas_left).mas_offset([GUIUtil fit:-15]);
        make.height.mas_equalTo([GUIUtil fit:30]);
        make.top.mas_equalTo([GUIUtil fit:15]);
    }];
    [self.arrowImg  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-25]);
        make.centerY.equalTo(self.topView);
    }];
    [self.amountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:25]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.topView.mas_bottom).mas_offset([GUIUtil fit:10]);
    }];
    [self.marignView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:195]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.topView.mas_bottom).mas_offset([GUIUtil fit:10]);
    }];
    [self.entrustPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:25]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.amountView.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.tradePriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:195]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.amountView.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    
    [self.tpPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:25]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.entrustPriceView.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.slPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:195]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.entrustPriceView.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.tpPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:25]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.slPriceView.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.slPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:195]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.slPriceView.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.tpPrecentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:25]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.tpPointView.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.slPrecentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:195]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.tpPointView.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.feeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:25]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.tpPrecentView.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.pryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:195]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.tpPrecentView.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    
    [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:25]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.feeView.mas_bottom).mas_offset([GUIUtil fit:5]).priority(750);
        self.masTimeTop = make.top.equalTo(self.entrustPriceView.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.ordernoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:195]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.dateView);
    }];
    [self.noView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:25]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.dateView.mas_bottom).mas_offset([GUIUtil fit:5]);
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
    NSString *optype = [NDataUtil stringWith:dict[@"optype"]];
    _typeLabel.text = optype;
    NSString *quantity = [NSString stringWithFormat:@"%@%@",qu,q];
    [_amountView configOfInfo:@{@"key":CFDLocalizedString(@"委托数量"),@"value":quantity}];
    NSString *marign = [NSString stringWithFormat:@"%@USDT",[NDataUtil stringWith:dict[@"margin"]]];
    [_marignView configOfInfo:@{@"key":CFDLocalizedString(@"保证金"),@"value":marign}];
    [_entrustPriceView configOfInfo:@{@"key":CFDLocalizedString(@"委托价格"),@"value":[NDataUtil stringWith:dict[@"orderprice"]]}];
    NSString *pryBar = [NSString stringWithFormat:@"%@%@",[NDataUtil stringWith:dict[@"pryBar"]],CFDLocalizedString(@"倍")];
    [_pryView configOfInfo:@{@"key":CFDLocalizedString(@"杠杆倍数"),@"value":pryBar}];
    [_tpPriceView configOfInfo:@{@"key":CFDLocalizedString(@"止盈价位"),@"value":[NDataUtil stringWith:dict[@"stopprofitprice"]]}];
    [_slPriceView configOfInfo:@{@"key":CFDLocalizedString(@"止损价位"),@"value":[NDataUtil stringWith:dict[@"stoplossprice"]]}];
    NSString *stoplossnum = [NDataUtil stringWith:dict[@"stoplossnum"]];
    NSString *stoplossp = [GUIUtil equalValue:stoplossnum with:@"1"]?CFDLocalizedString(@"点"):CFDLocalizedString(@"点_复数");
    NSString *slPoint = [NSString stringWithFormat:@"%@%@",stoplossnum,stoplossp];
    if ([slPoint hasPrefix:@"-"]) {
        slPoint = [slPoint substringFromIndex:1];
    }
    NSString *stopprofitnum = [NDataUtil stringWith:dict[@"stopprofitnum"]];
    NSString *stopprofitp = [GUIUtil equalValue:stopprofitnum with:@"1"]?CFDLocalizedString(@"点"):CFDLocalizedString(@"点_复数");
    NSString *tpPoint = [NSString stringWithFormat:@"%@%@",stopprofitnum,stopprofitp];
    [_tpPointView configOfInfo:@{@"key":CFDLocalizedString(@"止盈点数"),@"value":tpPoint}];
    [_slPointView configOfInfo:@{@"key":CFDLocalizedString(@"止损点数"),@"value":slPoint}];
    NSString *tpPrecent = [NSString stringWithFormat:@"%@%%",[GUIUtil decimalMultiply:[NDataUtil stringWith:dict[@"stopprofitprecent"]] num:@"100"]];
    NSString *slPrecent = [NSString stringWithFormat:@"%@%%",[GUIUtil decimalMultiply:[NDataUtil stringWith:dict[@"stoplossprecent"]] num:@"100"]];
    if ([slPrecent hasPrefix:@"-"]) {
        slPrecent = [slPrecent substringFromIndex:1];
    }
    [_tpPrecentView configOfInfo:@{@"key":CFDLocalizedString(@"止盈比例"),@"value":tpPrecent}];
    [_slPrecentView configOfInfo:@{@"key":CFDLocalizedString(@"止损比例"),@"value":slPrecent}];
    NSString *tradefee = [NSString stringWithFormat:@"%@USDT",[NDataUtil stringWith:dict[@"tradefee"]]];
    [_feeView configOfInfo:@{@"key":CFDLocalizedString(@"手续费"),@"value":tradefee}];
    
    [_dateView configOfInfo:@{@"key":CFDLocalizedString(@"委托时间"),@"value":[NDataUtil stringWith:dict[@"ordertime"]]}];
    if ([NDataUtil boolWithDic:dict key:@"orderstatus" isEqual:@"3"]) {
        [_tradePriceView configOfInfo:@{@"key":CFDLocalizedString(@"成交价格"),@"value":[NDataUtil stringWith:dict[@"buyprice"]]}];
        if ([NDataUtil boolWithDic:dict key:@"isUnFold" isEqual:@"1"]) {
            [_masTimeTop deactivate];
            _arrowImg.image = [GColorUtil imageNamed:@"trade_icon_under_up"];
            _tpPriceView.hidden =
            _slPriceView.hidden =
            _tpPointView.hidden =
            _slPointView.hidden =
            _tpPrecentView.hidden =
            _slPrecentView.hidden =
            _pryView.hidden =
            _feeView.hidden =
            _noView.hidden =  NO;
            [_ordernoView configOfInfo:@{@"key":CFDLocalizedString(@"单号"),@"value":[NDataUtil stringWith:dict[@"orderno"]]}];
            [_noView configOfInfo:@{@"key":CFDLocalizedString(@"终止时间"),@"value":[NDataUtil stringWith:dict[@"lasttime"]]}];
        }else{
            [_masTimeTop activate];
            _arrowImg.image = [GColorUtil imageNamed:@"trade_icon_under_down"];
            _tpPriceView.hidden =
            _slPriceView.hidden =
            _tpPointView.hidden =
            _slPointView.hidden =
            _tpPrecentView.hidden =
            _slPrecentView.hidden =
            _pryView.hidden =
            _feeView.hidden =
            _noView.hidden =YES;
            [_ordernoView configOfInfo:@{@"key":CFDLocalizedString(@"终止时间"),@"value":[NDataUtil stringWith:dict[@"lasttime"]]}];
            [_noView configOfInfo:@{@"key":CFDLocalizedString(@"单号"),@"value":[NDataUtil stringWith:dict[@"orderno"]]}];
        }
    }else{
        [_tradePriceView configOfInfo:@{@"key":CFDLocalizedString(@"单号"),@"value":[NDataUtil stringWith:dict[@"orderno"]]}];
        [_ordernoView configOfInfo:@{@"key":CFDLocalizedString(@"终止时间"),@"value":[NDataUtil stringWith:dict[@"lasttime"]]}];
        if ([NDataUtil boolWithDic:dict key:@"isUnFold" isEqual:@"1"]) {
            [_masTimeTop deactivate];
            _arrowImg.image = [GColorUtil imageNamed:@"trade_icon_under_up"];
            _tpPriceView.hidden =
            _slPriceView.hidden =
            _tpPointView.hidden =
            _slPointView.hidden =
            _tpPrecentView.hidden =
            _pryView.hidden =
            _slPrecentView.hidden =
            _feeView.hidden =  NO;
            _noView.hidden =  YES;
            
        }else{
            [_masTimeTop activate];
            _arrowImg.image = [GColorUtil imageNamed:@"trade_icon_under_down"];
            _tpPriceView.hidden =
            _slPriceView.hidden =
            _tpPointView.hidden =
            _slPointView.hidden =
            _tpPrecentView.hidden =
            _pryView.hidden =
            _slPrecentView.hidden =
            _feeView.hidden =
            _noView.hidden =YES;
        }
    }
}

//MARK:Getter

- (BaseView *)bgview{
    if (!_bgview) {
        _bgview = [[BaseView alloc] init];
        _bgview.bgLayerColor = C19_ColorType;
        _bgview.layer.borderWidth = [GUIUtil fitLine];
        _bgview.bgColor = C15_ColorType;
        _bgview.layer.masksToBounds = YES;
        _bgview.layer.cornerRadius = 2;
    }
    return _bgview;
}

- (UIView *)topView{
    if (!_topView) {
        _topView= [[UILabel alloc] init];
        _topView.backgroundColor = [GColorUtil C11];
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
- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel= [[UILabel alloc] init];
        _typeLabel.textColor = [GColorUtil C5];
        _typeLabel.font = [GUIUtil fitFont:12];
    }
    return _typeLabel;
}
- (UIImageView *)arrowImg{
    if (!_arrowImg) {
        _arrowImg= [[UIImageView alloc] init];
        _arrowImg.image = [GColorUtil imageNamed:@"trade_icon_under_down"];
    }
    return _arrowImg;
}

- (SingleInfoView *)amountView{
    if(!_amountView){
        _amountView = [[SingleInfoView alloc] init];
        _amountView.alignment = SingleInfoAlignmentSide;
        _amountView.needChangedStyle= YES;
        [_amountView configOfInfo:@{@"key":CFDLocalizedString(@"盈亏"),@"value":@"--"}];
    }
    return _amountView;
}
- (SingleInfoView *)marignView{
    if(!_marignView){
        _marignView = [[SingleInfoView alloc] init];
        _marignView.alignment = SingleInfoAlignmentSide;
        _marignView.needChangedStyle= YES;
        [_marignView configOfInfo:@{@"key":CFDLocalizedString(@"保证金"),@"value":@"--"}];
    }
    return _marignView;
}
- (SingleInfoView *)entrustPriceView{
    if(!_entrustPriceView){
        _entrustPriceView = [[SingleInfoView alloc] init];
        _entrustPriceView.alignment = SingleInfoAlignmentSide;
        _entrustPriceView.needChangedStyle= YES;
        [_entrustPriceView configOfInfo:@{@"key":CFDLocalizedString(@"开仓"),@"value":@"--"}];
    }
    return _entrustPriceView;
}
- (SingleInfoView *)tradePriceView{
    if(!_tradePriceView){
        _tradePriceView = [[SingleInfoView alloc] init];
        _tradePriceView.alignment = SingleInfoAlignmentSide;
        _tradePriceView.needChangedStyle= YES;
        [_tradePriceView configOfInfo:@{@"key":CFDLocalizedString(@"成交价格"),@"value":@"--"}];
    }
    return _tradePriceView;
}
- (SingleInfoView *)ordernoView{
    if(!_ordernoView){
        _ordernoView = [[SingleInfoView alloc] init];
        _ordernoView.alignment = SingleInfoAlignmentSide;
        _ordernoView.needChangedStyle= YES;
        [_ordernoView configOfInfo:@{@"key":CFDLocalizedString(@"单号"),@"value":@"--"}];
    }
    return _ordernoView;
}
- (SingleInfoView *)tpPriceView{
    if(!_tpPriceView){
        _tpPriceView = [[SingleInfoView alloc] init];
        _tpPriceView.alignment = SingleInfoAlignmentSide;
        _tpPriceView.needChangedStyle= YES;
        [_tpPriceView configOfInfo:@{@"key":CFDLocalizedString(@"止盈价位"),@"value":@"--"}];
    }
    return _tpPriceView;
}
- (SingleInfoView *)slPriceView{
    if(!_slPriceView){
        _slPriceView = [[SingleInfoView alloc] init];
        _slPriceView.alignment = SingleInfoAlignmentSide;
        _slPriceView.needChangedStyle= YES;
        [_slPriceView configOfInfo:@{@"key":CFDLocalizedString(@"止损价位"),@"value":@"--"}];
    }
    return _slPriceView;
}
- (SingleInfoView *)tpPointView{
    if(!_tpPointView){
        _tpPointView = [[SingleInfoView alloc] init];
        _tpPointView.alignment = SingleInfoAlignmentSide;
        _tpPointView.needChangedStyle= YES;
        [_tpPointView configOfInfo:@{@"key":CFDLocalizedString(@"止盈点数"),@"value":@"--"}];
    }
    return _tpPointView;
}
- (SingleInfoView *)slPointView{
    if(!_slPointView){
        _slPointView = [[SingleInfoView alloc] init];
        _slPointView.alignment = SingleInfoAlignmentSide;
        _slPointView.needChangedStyle= YES;
        [_slPointView configOfInfo:@{@"key":CFDLocalizedString(@"止损点数"),@"value":@"--"}];
    }
    return _slPointView;
}
- (SingleInfoView *)tpPrecentView{
    if(!_tpPrecentView){
        _tpPrecentView = [[SingleInfoView alloc] init];
        _tpPrecentView.alignment = SingleInfoAlignmentSide;
        _tpPrecentView.needChangedStyle= YES;
        [_tpPrecentView configOfInfo:@{@"key":CFDLocalizedString(@"止盈比例"),@"value":@"--"}];
    }
    return _tpPrecentView;
}
- (SingleInfoView *)slPrecentView{
    if(!_slPrecentView){
        _slPrecentView = [[SingleInfoView alloc] init];
        _slPrecentView.alignment = SingleInfoAlignmentSide;
        _slPrecentView.needChangedStyle= YES;
        [_slPrecentView configOfInfo:@{@"key":CFDLocalizedString(@"止损比例"),@"value":@"--"}];
    }
    return _slPrecentView;
}
- (SingleInfoView *)feeView{
    if(!_feeView){
        _feeView = [[SingleInfoView alloc] init];
        _feeView.alignment = SingleInfoAlignmentSide;
        _feeView.needChangedStyle= YES;
        [_feeView configOfInfo:@{@"key":CFDLocalizedString(@"手续费"),@"value":@"--"}];
    }
    return _feeView;
}
- (SingleInfoView *)pryView{
    if(!_pryView){
        _pryView = [[SingleInfoView alloc] init];
        _pryView.alignment = SingleInfoAlignmentSide;
        _pryView.needChangedStyle= YES;
        [_pryView configOfInfo:@{@"key":CFDLocalizedString(@"杠杆倍数"),@"value":@"--"}];
    }
    return _pryView;
}
- (SingleInfoView *)dateView{
    if(!_dateView){
        _dateView = [[SingleInfoView alloc] init];
        _dateView.alignment = SingleInfoAlignmentSide;
        _dateView.needChangedStyle= YES;
        [_dateView configOfInfo:@{@"key":CFDLocalizedString(@"开仓时间"),@"value":@"--"}];
    }
    return _dateView;
}
- (SingleInfoView *)noView{
    if(!_noView){
        _noView = [[SingleInfoView alloc] init];
        _noView.alignment = SingleInfoAlignmentSide;
        _noView.needChangedStyle= YES;
        [_noView configOfInfo:@{@"key":CFDLocalizedString(@"单号"),@"value":@"--"}];
    }
    return _noView;
}


@end

