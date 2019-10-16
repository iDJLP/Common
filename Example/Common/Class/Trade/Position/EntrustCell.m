//
//  EntrustCell.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/24.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "EntrustCell.h"
#import "View.h"
#import "BaseBtn.h"

@interface EntrustCell ()

@property (nonatomic,strong)BaseView *bgview;

@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *orderLabel;
@property (nonatomic,strong)UIImageView *arrowImg;

@property (nonatomic,strong)SingleInfoView *amountView;
@property (nonatomic,strong)SingleInfoView *marignView;
@property (nonatomic,strong)SingleInfoView *entrustPriceView;
@property (nonatomic,strong)SingleInfoView *entrustPryView;
@property (nonatomic,strong)SingleInfoView *tpPriceView;
@property (nonatomic,strong)SingleInfoView *slPriceView;
@property (nonatomic,strong)SingleInfoView *tpPointView;
@property (nonatomic,strong)SingleInfoView *slPointView;
@property (nonatomic,strong)SingleInfoView *tpPrecentView;
@property (nonatomic,strong)SingleInfoView *slPrecentView;
@property (nonatomic,strong)SingleInfoView *feeView;
@property (nonatomic,strong)SingleInfoView *noView;
@property (nonatomic,strong)SingleInfoView *dateView;

@property (nonatomic,strong)BaseView *line;
@property (nonatomic,strong)BaseBtn *slBtn;
@property (nonatomic,strong)BaseBtn *tpBtn;
@property (nonatomic,strong)BaseBtn *closeBtn;
@property (nonatomic,strong)BaseView *line1;
@property (nonatomic,strong)BaseView *line2;

@property (nonatomic,strong)MASConstraint *masLineTop;
@property (nonatomic,strong)NSMutableDictionary *config;

@end

@implementation EntrustCell

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
    [self.contentView addSubview:self.amountView];
    [self.contentView addSubview:self.marignView];
    [self.contentView addSubview:self.entrustPriceView];
    [self.contentView addSubview:self.entrustPryView];
    [self.contentView addSubview:self.tpPriceView];
    [self.contentView addSubview:self.slPriceView];
    [self.contentView addSubview:self.tpPointView];
    [self.contentView addSubview:self.slPointView];
    [self.contentView addSubview:self.tpPrecentView];
    [self.contentView addSubview:self.slPrecentView];
    [self.contentView addSubview:self.feeView];
    [self.contentView addSubview:self.dateView];
    [self.contentView addSubview:self.noView];
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
    [self.entrustPryView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    [self.noView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:195]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.tpPrecentView.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:25]);
        make.width.mas_equalTo([GUIUtil fit:155]);
        make.top.equalTo(self.feeView.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.height.mas_equalTo([GUIUtil fitLine]*2);
        self.masLineTop = make.top.equalTo(self.dateView.mas_bottom).mas_offset([GUIUtil fit:10]);
        make.top.equalTo(self.entrustPriceView.mas_bottom).mas_offset([GUIUtil fit:10]).priority(750);
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
    _setterSLTPHaner(OrderKeyBoardTypeSl,_config);
}
- (void)tpAction{
    _setterSLTPHaner(OrderKeyBoardTypeTP,_config);
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
    NSString *quantity = [NSString stringWithFormat:@"%@%@",qu,q];
    [_amountView configOfInfo:@{@"key":CFDLocalizedString(@"委托数量"),@"value":quantity}];
    NSString *marign = [NSString stringWithFormat:@"%@USDT",[NDataUtil stringWith:dict[@"margin"]]];
    [_marignView configOfInfo:@{@"key":CFDLocalizedString(@"保证金"),@"value":marign}];
    [_entrustPriceView configOfInfo:@{@"key":CFDLocalizedString(@"委托价格"),@"value":[NDataUtil stringWith:dict[@"buyprice"]]}];
    NSString *pryBar = [NSString stringWithFormat:@"%@%@",[NDataUtil stringWith:dict[@"pryBar"]],CFDLocalizedString(@"倍")];
    [_entrustPryView configOfInfo:@{@"key":CFDLocalizedString(@"杠杆倍数"),@"value":pryBar}];
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
    [_noView configOfInfo:@{@"key":CFDLocalizedString(@"单号"),@"value":[NDataUtil stringWith:dict[@"orderno"]]}];
    
    
    if ([NDataUtil boolWithDic:dict key:@"isUnFold" isEqual:@"1"]) {
        [_masLineTop activate];
        _arrowImg.image = [GColorUtil imageNamed:@"trade_icon_under_up"];
        _tpPriceView.hidden =
        _slPriceView.hidden =
        _tpPointView.hidden =
        _slPointView.hidden =
        _tpPrecentView.hidden=
        _slPrecentView.hidden=
        _feeView.hidden=
        _noView.hidden=
        _dateView.hidden=NO;
        
    }else{
        [_masLineTop deactivate];
        _arrowImg.image = [GColorUtil imageNamed:@"trade_icon_under_down"];
        _tpPriceView.hidden =
        _slPriceView.hidden =
        _tpPointView.hidden =
        _slPointView.hidden =
        _tpPrecentView.hidden=
        _slPrecentView.hidden=
        _feeView.hidden=
        _noView.hidden=
        _dateView.hidden=YES;
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
        [_amountView configOfInfo:@{@"key":CFDLocalizedString(@"委托数量"),@"value":@"--"}];
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
        [_entrustPriceView configOfInfo:@{@"key":CFDLocalizedString(@"委托价格"),@"value":@"--"}];
    }
    return _entrustPriceView;
}
- (SingleInfoView *)entrustPryView{
    if(!_entrustPryView){
        _entrustPryView = [[SingleInfoView alloc] init];
        _entrustPryView.alignment = SingleInfoAlignmentSide;
        _entrustPryView.needChangedStyle= YES;
        [_entrustPryView configOfInfo:@{@"key":CFDLocalizedString(@"杠杆倍数"),@"value":@"--"}];
    }
    return _entrustPryView;
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

- (SingleInfoView *)dateView{
    if(!_dateView){
        _dateView = [[SingleInfoView alloc] init];
        _dateView.alignment = SingleInfoAlignmentSide;
        _dateView.needChangedStyle= YES;
        [_dateView configOfInfo:@{@"key":CFDLocalizedString(@"委托时间"),@"value":@"--"}];
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
        _slBtn.textBlock = CFDLocalizedStringBlock(@"止损修改");
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
        _tpBtn.textBlock = CFDLocalizedStringBlock(@"止盈修改");
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
        _closeBtn.textBlock = CFDLocalizedStringBlock(@"撤销");
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
