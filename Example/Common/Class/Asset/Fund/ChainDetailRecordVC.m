//
//  FundDetailVC.m
//  Bitmixs
//
//  Created by ngw15 on 2019/4/25.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "ChainDetailRecordVC.h"

@interface ChainDetailRecordVC ()

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong) UILabel *varityText;
@property (nonatomic,strong) UILabel *varityTitle;
@property (nonatomic,strong) UILabel *feeText;
@property (nonatomic,strong) UILabel *feeTitle;
@property (nonatomic,strong) UILabel *statusText;
@property (nonatomic,strong) UILabel *statusTitle;
@property (nonatomic,strong) UILabel *dateText;
@property (nonatomic,strong) UILabel *dateTitle;
@property (nonatomic,strong) UILabel *amountText;
@property (nonatomic,strong) UILabel *amountTitle;
@property (nonatomic,strong)UIView *detailView;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UILabel *remarkLabel;
@property (nonatomic,strong)UILabel *addressTitle;
@property (nonatomic,strong)UILabel *addressText;
@property (nonatomic,strong)UILabel *hashTitle;
@property (nonatomic,strong)UILabel *hashText;

@property (nonatomic,strong) NSDictionary *config;
@property (nonatomic,strong) NSString *logId;
@property (nonatomic,strong) NSString *txtId;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *currenttype;
@property (nonatomic,assign) BOOL isDeposit;
@property (nonatomic,strong) MASConstraint *masDetailTop;
@end

@implementation ChainDetailRecordVC

+ (void)jumpTo:(NSString *)logid txtId:(NSString *)txtId date:(NSString *)date currenttype:(NSString *)currenttype isDeposit:(BOOL)isDeposit{
    ChainDetailRecordVC *target = [[ChainDetailRecordVC alloc] init];
    target.logId = logid;
    target.txtId = txtId;
    target.date = date;
    target.currenttype = currenttype;
    target.isDeposit = isDeposit;
    [GJumpUtil pushVC:target animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [GColorUtil colorWithHex:0xf4f5f6];
    self.title = CFDLocalizedString(@"详细信息");
    [self setupUI];
    [self autoLayout];
    [self loadData];
    WEAK_SELF;
    [GUIUtil refreshWithHeader:_scrollView refresh:^{
        [weakSelf loadData];
    }];
    // Do any additional setup after loading the view.
}

- (void)setupUI{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.varityText];
    [self.scrollView addSubview:self.varityTitle];
    [self.scrollView addSubview:self.feeText];
    [self.scrollView addSubview:self.feeTitle];
    [self.scrollView addSubview:self.dateText];
    [self.scrollView addSubview:self.dateTitle];
    [self.scrollView addSubview:self.amountText];
    [self.scrollView addSubview:self.amountTitle];
    [self.scrollView addSubview:self.statusText];
    [self.scrollView addSubview:self.statusTitle];
    [self.scrollView addSubview:self.detailView];
    [self.detailView addSubview:self.lineView];
    [self.detailView addSubview:self.remarkLabel];
    [self.detailView addSubview:self.addressTitle];
    [self.detailView addSubview:self.addressText];
    [self.detailView addSubview:self.hashTitle];
    [self.detailView addSubview:self.hashText];
    
}

- (void)autoLayout{
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [_varityText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:30]);
        make.left.mas_equalTo([GUIUtil fit:30]);
        make.height.mas_equalTo([GUIUtil fitFont:14].lineHeight);
    }];
    [_varityTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.varityText.mas_bottom).mas_offset([GUIUtil fit:2]);
        make.left.equalTo(self.varityText);
        make.height.mas_equalTo([GUIUtil fitFont:12].lineHeight);
    }];
    [self.statusText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:30]);
        make.left.mas_equalTo([GUIUtil fit:197]);
        make.height.mas_equalTo([GUIUtil fitFont:14].lineHeight);
    }];
    
    [self.statusTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusText.mas_bottom).mas_offset([GUIUtil fit:2]);
        make.left.equalTo(self.statusText);
        make.height.mas_equalTo([GUIUtil fitFont:12].lineHeight);
    }];
    [self.amountText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.varityTitle.mas_bottom).mas_offset([GUIUtil fit:12]);
        make.left.mas_equalTo([GUIUtil fit:30]);
        make.height.mas_equalTo([GUIUtil fitFont:14].lineHeight);
    }];
    [self.amountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountText.mas_bottom).mas_offset([GUIUtil fit:2]);
        make.left.equalTo(self.amountText);
        make.height.mas_equalTo([GUIUtil fitFont:12].lineHeight);
    }];
    [self.feeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.varityTitle.mas_bottom).mas_offset([GUIUtil fit:12]);
        make.left.mas_equalTo([GUIUtil fit:197]);
        make.height.mas_equalTo([GUIUtil fitFont:14].lineHeight);
    }];
    [self.feeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feeText.mas_bottom).mas_offset([GUIUtil fit:2]);
        make.left.equalTo(self.feeText);
        make.height.mas_equalTo([GUIUtil fitFont:12].lineHeight);
    }];
    
    [self.dateText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feeTitle.mas_bottom).mas_offset([GUIUtil fit:12]);
        make.left.mas_equalTo([GUIUtil fit:30]);
        make.height.mas_equalTo([GUIUtil fitFont:14].lineHeight);
    }];
    [self.dateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateText.mas_bottom).mas_offset([GUIUtil fit:2]);
        make.left.equalTo(self.dateText);
        make.height.mas_equalTo([GUIUtil fitFont:12].lineHeight);
    }];
    
    [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.right.equalTo(self.scrollView.mas_left).mas_offset(SCREEN_WIDTH+[GUIUtil fit:-15]);
        make.top.equalTo(self.dateTitle.mas_bottom).mas_offset([GUIUtil fit:15]).priority(750);
        self.masDetailTop = make.top.equalTo(self.amountTitle.mas_bottom).mas_offset([GUIUtil fit:15]);
        
        make.bottom.mas_equalTo([GUIUtil fit:-15]);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:0]);
        make.left.mas_equalTo([GUIUtil fit:0]);
        make.right.mas_equalTo([GUIUtil fit:0]);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).mas_offset([GUIUtil fit:15]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [_addressTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remarkLabel.mas_bottom).mas_offset([GUIUtil fit:20]);
        make.left.mas_equalTo([GUIUtil fit:15]);
        
    }];
    [_addressText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressTitle);
        make.left.equalTo(self.addressTitle.mas_right).mas_offset([GUIUtil fit:5]);
        make.right.mas_equalTo([GUIUtil fit:-15]);
    }];
    [_hashTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressText.mas_bottom).mas_offset([GUIUtil fit:20]);
        make.left.mas_equalTo([GUIUtil fit:15]);
        
    }];
    [_hashText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hashTitle);
        make.left.equalTo(self.hashTitle.mas_right).mas_offset([GUIUtil fit:5]);
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.bottom.mas_equalTo([GUIUtil fit:-15]);
    }];
}

- (void)loadData{
    WEAK_SELF;
    [DCService getChainOrderDetail:_logId txtId:_txtId currenttype:_currenttype isDeposit:_isDeposit success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            [weakSelf configView:data];
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"message"] valid:[FTConfig webTips]]];
        }
        [weakSelf.scrollView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
        [weakSelf.scrollView.mj_header endRefreshing];
    }];
}

- (void)configView:(NSDictionary *)data{
    self.config = [NDataUtil dictWith:data[@"data"]];
    NSDictionary *dic = self.config;
    NSInteger status = [NDataUtil integerWith:dic[@"status"]];
    NSString *statusText = @"";
    if (status==0) {
        statusText = CFDLocalizedString(@"确认中");
        _statusText.textColor = [GColorUtil C13];
    }else if (status==1){
        statusText = CFDLocalizedString(@"成功");
        _statusText.textColor = [GColorUtil C24];
    }else if (status==2){
        statusText = CFDLocalizedString(@"失败");
        _statusText.textColor = [GColorUtil C14];
    }
    _statusText.text = statusText;
    _statusTitle.text = CFDLocalizedString(@"状态");
    _varityText.text = [NDataUtil stringWith:dic[@"showCoinCode"]];
    _amountText.text = [NDataUtil stringWithDict:dic keys:@[@"ordermoney",@"amount"] valid:@""];
    _hashText.text = [NDataUtil stringWith:self.config[@"txtid"] valid:@"--"];
    _addressText.text = [NDataUtil stringWith:self.config[@"address"] valid:@"--"];
    if (_isDeposit) {
        [_masDetailTop activate];
        _dateText.hidden = _dateTitle.hidden = YES;
        _feeText.text = [NDataUtil stringWithDict:dic keys:@[@"tradetime",@"createTime"] valid:@""];
    }else{
        [_masDetailTop deactivate];
        _dateText.hidden = _dateTitle.hidden = NO;
        _feeText.text = [NDataUtil stringWith:dic[@"fee"]];
        _dateText.text = [NDataUtil stringWith:_date valid:@"--"];
    }
}

//MARK: - Getter

- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [GColorUtil C6];
    }
    return _scrollView;
}

- (UILabel *)varityText{
    if(!_varityText){
        _varityText = [[UILabel alloc] init];
        _varityText.textColor = [GColorUtil C2];
        _varityText.font = [GUIUtil fitFont:14];
        _varityText.text = @"--";
    }
    return _varityText;
}
- (UILabel *)varityTitle{
    if(!_varityTitle){
        _varityTitle = [[UILabel alloc] init];
        _varityTitle.textColor = [GColorUtil C3];
        _varityTitle.font = [GUIUtil fitFont:12];
        _varityTitle.text = CFDLocalizedString(@"币种");
    }
    return _varityTitle;
}

- (UILabel *)feeText{
    if(!_feeText){
        _feeText = [[UILabel alloc] init];
        _feeText.textColor = [GColorUtil C2];
        _feeText.font = [GUIUtil fitFont:14];
        _feeText.text = @"--";
    }
    return _feeText;
}
- (UILabel *)feeTitle{
    if(!_feeTitle){
        _feeTitle = [[UILabel alloc] init];
        _feeTitle.textColor = [GColorUtil C3];
        _feeTitle.font = [GUIUtil fitFont:12];
        _feeTitle.text = CFDLocalizedString(@"手续费");
    }
    return _feeTitle;
}
- (UILabel *)dateText{
    if(!_dateText){
        _dateText = [[UILabel alloc] init];
        _dateText.textColor = [GColorUtil C2];
        _dateText.font = [GUIUtil fitFont:14];
        _dateText.text = @"--";
    }
    return _dateText;
}
- (UILabel *)dateTitle{
    if(!_dateTitle){
        _dateTitle = [[UILabel alloc] init];
        _dateTitle.textColor = [GColorUtil C3];
        _dateTitle.font = [GUIUtil fitFont:12];
        _dateTitle.text = CFDLocalizedString(@"时间");
    }
    return _dateTitle;
}
- (UILabel *)amountText{
    if(!_amountText){
        _amountText = [[UILabel alloc] init];
        _amountText.textColor = [GColorUtil C2];
        _amountText.font = [GUIUtil fitFont:14];
        _amountText.text = @"--";
    }
    return _amountText;
}
- (UILabel *)amountTitle{
    if(!_amountTitle){
        _amountTitle = [[UILabel alloc] init];
        _amountTitle.textColor = [GColorUtil C3];
        _amountTitle.font = [GUIUtil fitFont:12];
        _amountTitle.text = CFDLocalizedString(@"数量");
    }
    return _amountTitle;
}
- (UILabel *)statusText{
    if(!_statusText){
        _statusText = [[UILabel alloc] init];
        _statusText.textColor = [GColorUtil C2];
        _statusText.font = [GUIUtil fitFont:14];
        _statusText.text = @"--";
    }
    return _statusText;
}
- (UILabel *)statusTitle{
    if(!_statusTitle){
        _statusTitle = [[UILabel alloc] init];
        _statusTitle.textColor = [GColorUtil C3];
        _statusTitle.font = [GUIUtil fitFont:12];
        _statusTitle.text = CFDLocalizedString(@"状态");
    }
    return _statusTitle;
}

- (UIView *)detailView{
    if (!_detailView) {
        _detailView = [[UIView alloc] init];
        _detailView.backgroundColor = [GColorUtil C15];
    }
    return _detailView;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [GColorUtil C7];
    }
    return _lineView;
}

- (UILabel *)remarkLabel{
    if(!_remarkLabel){
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.textColor = [GColorUtil C4];
        _remarkLabel.font = [GUIUtil fitFont:12];
        _remarkLabel.text = CFDLocalizedString(@"点击以下地址，查看链上信息");
    }
    return _remarkLabel;
}
- (UILabel *)addressTitle{
    if(!_addressTitle){
        _addressTitle = [[UILabel alloc] init];
        _addressTitle.textColor = [GColorUtil C2];
        _addressTitle.font = [GUIUtil fitFont:12];
        _addressTitle.text = CFDLocalizedString(@"地 址：");
    }
    return _addressTitle;
}
- (UILabel *)addressText{
    if(!_addressText){
        _addressText = [[UILabel alloc] init];
        _addressText.textColor = [GColorUtil C13];
        _addressText.font = [GUIUtil fitFont:12];
        _addressText.numberOfLines=0;
        _addressText.text = @"--";
        WEAK_SELF;
        [_addressText g_clickBlock:^(UITapGestureRecognizer *tap) {
            NSString *link = [NDataUtil stringWith:weakSelf.config[@"aurl"] valid:@""];
            link = [link stringByAppendingString:[NDataUtil stringWith:weakSelf.config[@"address"]]];
            if ([NDataUtil stringWith:weakSelf.config[@"address"]].length>0) {
                [CFDJumpUtil jumpToWeb:@"" link:link animated:YES];
            }
        }];
    }
    return _addressText;
}
- (UILabel *)hashTitle{
    if(!_hashTitle){
        _hashTitle = [[UILabel alloc] init];
        _hashTitle.textColor = [GColorUtil C2];
        _hashTitle.font = [GUIUtil fitFont:12];
        _hashTitle.text = @"TxHash：";
    }
    return _hashTitle;
}
- (UILabel *)hashText{
    if(!_hashText){
        _hashText = [[UILabel alloc] init];
        _hashText.textColor = [GColorUtil C13];
        _hashText.font = [GUIUtil fitFont:12];
        _hashText.numberOfLines=0;
        _hashText.text = @"--";
        WEAK_SELF;
        [_hashText g_clickBlock:^(UITapGestureRecognizer *tap) {
            NSString *link = [NDataUtil stringWith:weakSelf.config[@"turl"] valid:@""];
            link = [link stringByAppendingString:[NDataUtil stringWith:weakSelf.config[@"txtid"]]];
            if ([NDataUtil stringWith:weakSelf.config[@"txtid"]].length>0) {
                [CFDJumpUtil jumpToWeb:@"" link:link animated:YES];
            }
        }];
    }
    return _hashText;
}



@end

