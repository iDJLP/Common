//
//  FundTransferVC.m
//  Bitmixs
//
//  Created by ngw15 on 2019/6/12.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "FundTransferVC.h"
#import "FundRecordVC.h"
#import "CurrenttypeSelectedSheet.h"

@interface FundInfoRow : BaseView

@property (nonatomic,strong) UILabel *btcView;
@property (nonatomic,strong) UILabel *btcText;
@property (nonatomic,strong) UIView *btcLine;

@property (nonatomic,strong) NSDictionary *config;

@end

@implementation FundInfoRow

+ (CGFloat)heightOfRow{
    
    return [GUIUtil fit:50];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.bgColor = C6_ColorType;
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.btcView];
    [self addSubview:self.btcText];
    [self addSubview:self.btcLine];
}

- (void)autoLayout{
    [self.btcView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:0]);
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.height.mas_equalTo([GUIUtil fit:50]);
    }];
    [self.btcText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btcView);
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.height.mas_equalTo([GUIUtil fit:50]);
    }];
    [self.btcLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.btcText.mas_bottom);
        make.height.mas_equalTo([GUIUtil fitLine]);
        make.left.right.mas_equalTo([GUIUtil fit:0]);
    }];
}

- (void)configOfRow:(NSDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _config = dict;
    _btcView.text = [NDataUtil stringWith:dict[@"currencyType"]];
    _btcText.text = [NDataUtil stringWith:dict[@"canUseMoney"]];
}
//MARK:Getter

-(UILabel *)btcView{
    if (!_btcView) {
        _btcView = [[UILabel alloc] init];
        _btcView.textColor = [GColorUtil C2];
        _btcView.font = [GUIUtil fitBoldFont:16];
        _btcView.text = @"";
    }
    return _btcView;
}
-(UILabel *)btcText{
    if (!_btcText) {
        _btcText = [[UILabel alloc] init];
        _btcText.textColor = [GColorUtil C2];
        _btcText.font = [GUIUtil fitBoldFont:16];
        _btcText.text = @"--";
    }
    return _btcText;
}
-(UIView *)btcLine{
    if (!_btcLine) {
        _btcLine = [[UIView alloc] init];
        _btcLine.backgroundColor = [GColorUtil C7];
    }
    return _btcLine;
}

@end

@interface FundTransferVC ()<UITextFieldDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UILabel *headerTitle;
@property (nonatomic,strong) NSMutableArray <FundInfoRow *> *rowList;
@property (nonatomic,strong) UIView *headerSeparateView;

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIView *varityView;
@property (nonatomic,strong) UIImageView *transfer1ArrowView;
@property (nonatomic,strong) UIImageView *transfer2ArrowView;
@property (nonatomic,strong) UIImageView *transferArrowView;
@property (nonatomic,strong) UILabel *transfer1VarityLabel;
@property (nonatomic,strong) UILabel *transfer2VarityLabel;
@property (nonatomic,strong) UILabel *rateLabel;
@property (nonatomic,strong) UIImageView *transfer1ImgView;
@property (nonatomic,strong) UIImageView *transfer2ImgView;
@property (nonatomic,strong) UIImageView *transferImgView;
@property (nonatomic,strong) UILabel *transfer1TitleLabel;
@property (nonatomic,strong) UILabel *transfer2TitleLabel;
@property (nonatomic,strong) UITextField *transfer1TextField;
@property (nonatomic,strong) UITextField *transfer2TextField;
@property (nonatomic,strong) UIButton *allTransferBtn;
@property (nonatomic,strong) UIView *tipsMinMark;
@property (nonatomic,strong) UIView *tipsMaxMark;
@property (nonatomic,strong) UIView *tipsMark;
@property (nonatomic,strong) UILabel *tipsLabel;
@property (nonatomic,strong) UIButton *commitBtn;

@property (nonatomic,strong) NSArray *accountList;
@property (nonatomic,copy) NSString *rate;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *toType;
@property (nonatomic,assign) BOOL isTransfer2Respond;

@end

@implementation FundTransferVC

+ (void)jumpTo:(NSString *)type{
    FundTransferVC *target = [FundTransferVC new];
    target.type = type;
    target.hidesBottomBarWhenPushed = YES;
    [GJumpUtil pushVC:target animated:YES];
}

- (void)dealloc{
    [self removeNotic];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startTimer];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [NTimeUtil stopTimer:@"FundTransferVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [GColorUtil C6];
    self.title = CFDLocalizedString(@"币币兑换");
    [self setupUI];
    [self autoLayout];
    [self addNotic];
    [self loadData:NO];
    WEAK_SELF;
    [GUIUtil refreshWithHeader:_scrollView refresh:^{
        [weakSelf loadData:NO];
    }];
    [GNavUtil rightTitle:self title:CFDLocalizedString(@"资金记录") color:C2_ColorType onClick:^{
        [FundRecordVC jumpTo:4];
    }];
}

- (void)startTimer{
    WEAK_SELF;
    [NTimeUtil startTimer:@"FundTransferVC" interval:5 repeats:YES action:^{
        [weakSelf loadData:YES];
    }];
}

- (void)setupUI{
    _rowList = [NSMutableArray array];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.commitBtn];
    [self.scrollView addSubview:self.headerView];
    [self.scrollView addSubview:self.contentView];
    
    [self.headerView addSubview:self.headerTitle];
    [self.headerView addSubview:self.headerSeparateView];
    
    [self.contentView addSubview:self.varityView];
    [self.contentView addSubview:self.transfer1VarityLabel];
    [self.contentView addSubview:self.transfer2VarityLabel];
    [self.contentView addSubview:self.rateLabel];
    [self.contentView addSubview:self.transfer1TitleLabel];
    [self.contentView addSubview:self.transfer2TitleLabel];
    [self.contentView addSubview:self.tipsLabel];
    [self.contentView addSubview:self.transfer1TextField];
    [self.contentView addSubview:self.transfer2TextField];
    [self.contentView addSubview:self.transfer1ArrowView];
    [self.contentView addSubview:self.transfer2ArrowView];
    [self.contentView addSubview:self.transferArrowView];
    [self.contentView addSubview:self.transfer1ImgView];
    [self.contentView addSubview:self.transfer2ImgView];
    [self.contentView addSubview:self.transferImgView];
    [self.contentView addSubview:self.allTransferBtn];
    [self.contentView addSubview:self.tipsMinMark];
    [self.contentView addSubview:self.tipsMaxMark];
    [self.contentView addSubview:self.tipsMark];
}

- (void)autoLayout{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo([GUIUtil fit:-50-IPHONE_X_BOTTOM_HEIGHT]);
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(self.headerView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-IPHONE_X_BOTTOM_HEIGHT);
        make.height.mas_equalTo([GUIUtil fit:50]);
    }];
    {
        
        [self.headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo([GUIUtil fit:15]);
            make.left.mas_equalTo([GUIUtil fit:15]);
        }];
        
        [self.headerSeparateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo([GUIUtil fit:0]);
            make.height.mas_equalTo([GUIUtil fit:7]);
            make.bottom.mas_equalTo(0);
        }];
    }
    {
        [_varityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo([GUIUtil fit:60]);
            make.top.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
        }];
        [_transfer1VarityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:15]);
            make.height.mas_equalTo([GUIUtil fit:60]);
            make.top.mas_equalTo(0);
        }];
        [_transfer1ArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.transfer1VarityLabel);
            make.left.mas_equalTo([GUIUtil fit:85]);
            make.size.mas_equalTo([GUIUtil fitWidth:8 height:5]);
        }];
        [_transferArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.transfer1VarityLabel);
            make.centerX.mas_equalTo([GUIUtil fit:0]);
            make.size.mas_equalTo([GUIUtil fitWidth:23 height:23]);
        }];
        [_transfer2VarityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:281]);
            make.height.mas_equalTo([GUIUtil fit:60]);
            make.top.mas_equalTo(0);
        }];
        [_transfer2ArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.transfer1VarityLabel);
            make.right.mas_equalTo([GUIUtil fit:-15]);
            make.size.mas_equalTo([GUIUtil fitWidth:8 height:5]);
        }];
        [_rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo([GUIUtil fit:-15]);
            make.top.equalTo(self.transfer2VarityLabel.mas_bottom).mas_offset([GUIUtil fit:12]);
        }];
        [_transfer1ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:16]);
            make.centerY.equalTo(self.transfer1TitleLabel);
            make.size.mas_equalTo([GUIUtil fitWidth:25 height:25]);
        }];
        [_transfer1TitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.transfer1ImgView.mas_right).mas_offset([GUIUtil fit:12]); make.top.equalTo(self.rateLabel.mas_bottom).mas_offset([GUIUtil fit:30]);
        }];
        [_transfer1TextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.transfer1TitleLabel.mas_bottom).mas_offset([GUIUtil fit:0]);
            make.height.mas_equalTo([GUIUtil fit:50]);
            make.width.mas_equalTo([GUIUtil fit:270]);
            make.left.equalTo(self.transfer1TitleLabel);
        }];
        [_transferImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.transfer1ImgView);
            make.top.equalTo(self.transfer1ImgView.mas_bottom).mas_offset([GUIUtil fit:25]);
            make.size.mas_equalTo([GUIUtil fitWidth:8 height:15]);
        }];
        [_transfer2ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:16]);
            make.centerY.equalTo(self.transfer2TitleLabel);
            make.size.mas_equalTo([GUIUtil fitWidth:25 height:25]);
        }];
        [_transfer2TitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(self.transfer2ImgView.mas_right).mas_offset([GUIUtil fit:12]); make.top.equalTo(self.transfer1TitleLabel.mas_bottom).mas_offset([GUIUtil fit:75]);
        }];
        [_transfer2TextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.transfer2TitleLabel.mas_bottom).mas_offset([GUIUtil fit:0]);
            make.height.mas_equalTo([GUIUtil fit:50]);
            make.width.mas_equalTo([GUIUtil fit:240]);
            make.left.equalTo(self.transfer2TitleLabel);
        }];
        [_allTransferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo([GUIUtil fit:-15]);
            make.centerY.equalTo(self.transfer2TextField);
        }];
        
        [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.transfer2TextField.mas_bottom).mas_offset([GUIUtil fit:15]);
            make.left.mas_equalTo([GUIUtil fit:15]);
            make.right.mas_equalTo([GUIUtil fit:-15]);
            make.bottom.mas_equalTo([GUIUtil fit:-25]);
        }];
    }
}

- (void)loadData:(BOOL)isAuto{
    [DCService postgetUserAmounts:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            NSDictionary *dict = [NDataUtil dictWith:data[@"data"]];
            [self updateHeader:[NDataUtil arrayWith:dict[@"accounts"]]];
            [self loadRate];
        }else{
            if (!isAuto) {
                [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
            }
        }
        [self.scrollView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        if (!isAuto) {
            [HUDUtil showInfo:[FTConfig webTips]];
        }
        [self.scrollView.mj_header endRefreshing];
    }];
}

- (void)loadRate{
    NSString *currency = [NSString stringWithFormat:@"%@/%@",_type,_toType];
    WEAK_SELF;
    [DCService getCurrencyRate:currency success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            NSDictionary *dic = [NDataUtil dataWithArray:data[@"data"] index:0];
            if ([NDataUtil boolWithDic:dic key:@"firstCurrency" isEqual:weakSelf.type]&&[NDataUtil boolWithDic:dic key:@"secondCurrency" isEqual:weakSelf.toType]) {
                weakSelf.rate = [NDataUtil stringWith:dic[@"exchangeRate"]];
                weakSelf.rateLabel.text = [NSString stringWithFormat:@"%@1%@=%@%@",CFDLocalizedString(@"汇率:"),weakSelf.type,weakSelf.rate,weakSelf.toType];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

//MARK: - Action

- (void)updateHeader:(NSArray *)dataList{
    if (_accountList.count==dataList.count) {
        _accountList = dataList;
        for (NSInteger i=0; i<dataList.count; i++) {
            FundInfoRow *row = [NDataUtil dataWithArray:_rowList index:i];
            [row configOfRow:[NDataUtil dataWithArray:dataList index:i]];
        }
        [self updatePlaceholder];
        return;
    }
    _accountList = dataList;
    UIView *refer = nil;
    for (NSInteger i=0; i<dataList.count; i++) {
        FundInfoRow *row = [NDataUtil dataWithArray:_rowList index:i];
        row.hidden = NO;
        if (row==nil) {
            row = [[FundInfoRow alloc] init];
            [self.headerView addSubview:row];
            [self.rowList addObject:row];
        }
        [row configOfRow:[NDataUtil dataWithArray:dataList index:i]];
        [row mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (refer==nil) {
                make.top.equalTo(self.headerTitle.mas_bottom);
            }else{
                make.top.equalTo(refer.mas_bottom);
            }
            make.height.mas_equalTo([FundInfoRow heightOfRow]);
            make.left.right.mas_equalTo(0);
        }];
        refer = row;
    }
    for (NSInteger i=dataList.count; i<_rowList.count; i++) {
        FundInfoRow *row = [NDataUtil dataWithArray:_rowList index:i];
        row.hidden = YES;
        [row mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (refer==nil) {
                make.top.equalTo(self.headerTitle.mas_bottom);
            }else{
                make.top.equalTo(refer.mas_bottom);
            }
            make.height.mas_equalTo([FundInfoRow heightOfRow]);
            make.left.right.mas_equalTo(0);
        }];
    }
    [refer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerSeparateView.mas_top);
    }];
    NSInteger index = 0;
    for (NSDictionary *dict in dataList) {
        if ([NDataUtil boolWithDic:dict key:@"currencyType" isEqual:_type]&&_type.length>0) {
            index = [dataList indexOfObject:dict];
        }
    }
    NSInteger toIndex = index+1;
    if (toIndex>=dataList.count) {
        toIndex=0;
    }
    NSDictionary *fromDic = [NDataUtil dictWith:dataList[index]];
    NSDictionary *toDic = [NDataUtil dictWith:dataList[toIndex]];
    _type = [NDataUtil stringWith:fromDic[@"currencyType"]];
    _toType = [NDataUtil stringWith:toDic[@"currencyType"]];
    [GUIUtil imageViewWithUrl:_transfer1ImgView url:fromDic[@"icon"]];
    _transfer1TitleLabel.text =
    _transfer1VarityLabel.text = _type;
    [GUIUtil imageViewWithUrl:_transfer2ImgView url:toDic[@"icon"]];
    NSString *money = [GUIUtil compareFloat:fromDic[@"canUseMoney"] with:fromDic[@"maxExchangeMoney"]]==NSOrderedDescending?[NDataUtil stringWith:fromDic[@"maxExchangeMoney"]]:[NDataUtil stringWith:fromDic[@"canUseMoney"]];
    _transfer1TextField.placeholder = [NSString stringWithFormat:@"%@%@%@",CFDLocalizedString(@"最多可换出"),money,_type];
    _transfer1TextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_transfer1TextField.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
    _transfer2TitleLabel.text =
    _transfer2VarityLabel.text = _toType;
    NSString *str = [NDataUtil stringWith:fromDic[@"tipList"]];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    attStr.lineSpacing = [GUIUtil fit:5];
    _tipsLabel.attributedText = attStr;
}

- (void)setRate:(NSString *)rate{
    _rate = rate;
    if (_isTransfer2Respond) {
        _transfer1TextField.text = [GUIUtil decimalDivide:_transfer2TextField.text num:_rate];
        if (_transfer2TextField.text.length<=0) {
            _transfer1TextField.text = @"";
        }else{
            _transfer1TextField.text = [GUIUtil notRoundingString:_transfer1TextField.text afterPoint:8];
        }
    }else{
        _transfer2TextField.text = [GUIUtil decimalMultiply:_transfer1TextField.text num:_rate];
        if (_transfer1TextField.text.length<=0) {
            _transfer2TextField.text = @"";
        }else{
            _transfer2TextField.text = [GUIUtil notRoundingString:_transfer2TextField.text afterPoint:8];
        }
    }
    [self updatePlaceholder];
}


- (void)updatePlaceholder{
    NSInteger index = 0;
    for (NSDictionary *dict in _accountList) {
        if ([NDataUtil boolWithDic:dict key:@"currencyType" isEqual:_type]&&_type.length>0) {
            index = [_accountList indexOfObject:dict];
        }
    }
    NSDictionary *fromDic = [NDataUtil dictWith:_accountList[index]];
    NSString *money = [GUIUtil compareFloat:fromDic[@"canUseMoney"] with:fromDic[@"maxExchangeMoney"]]==NSOrderedDescending?[NDataUtil stringWith:fromDic[@"maxExchangeMoney"]]:[NDataUtil stringWith:fromDic[@"canUseMoney"]];
    _transfer1TextField.placeholder = [NSString stringWithFormat:@"%@%@%@",CFDLocalizedString(@"最多可换出"),money,_type];
    _transfer1TextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_transfer1TextField.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
    NSString *amount =  @"";
    if (_rate.length<=0||[_rate isEqualToString:@"--"] ) {
        amount =  @"--";
    }else{
        amount = [GUIUtil decimalMultiply:money num:_rate];
        amount = [GUIUtil notRoundingString:amount afterPoint:8];
    }
    _transfer2TextField.placeholder = [NSString stringWithFormat:@"%@%@%@",CFDLocalizedString(@"最多可换为"),amount,_toType];
    _transfer2TextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_transfer2TextField.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
}

- (void)commitAction{
    NSInteger index = 0;
    for (NSDictionary *dict in _accountList) {
        if ([NDataUtil boolWithDic:dict key:@"currencyType" isEqual:_type]&&_type.length>0) {
            index = [_accountList indexOfObject:dict];
        }
    }
    NSDictionary *fromDic = [NDataUtil dictWith:_accountList[index]];
    
    if ([_type isEqualToString:_toType]) {
        [HUDUtil showInfo:CFDLocalizedString(@"同币种不可兑换")];
    }else if([GUIUtil compareFloat:_transfer1TextField.text with:fromDic[@"canUseMoney"]]==NSOrderedDescending){
        [HUDUtil showInfo:CFDLocalizedString(@"可兑换金额不足")];
    }else if ([GUIUtil compareFloat:_transfer1TextField.text with:fromDic[@"maxExchangeMoney"]]==NSOrderedDescending){
        [HUDUtil showInfo:[NSString stringWithFormat:@"%@%@%@",CFDLocalizedString(@"不能超过单次最大兑换金额"),fromDic[@"maxExchangeMoney"],_type]];
    }else if ([GUIUtil compareFloat:_transfer1TextField.text with:fromDic[@"minExchangeMoney"]]==NSOrderedAscending){
        [HUDUtil showInfo:[NSString stringWithFormat:@"%@%@%@",CFDLocalizedString(@"不能小于单次最小兑换金额"),fromDic[@"minExchangeMoney"],_type]];
    }else{
        WEAK_SELF;
        NSString *detail = [NSString stringWithFormat:CFDLocalizedString(@"确认将%@%@兑换为%@"),_transfer1TextField.text,_type,_toType];
        [DCAlert showAlert:@"" detail:detail sureTitle:CFDLocalizedString(@"确认_yes") sureHander:^{
            [weakSelf commitHander];
        } cancelTitle:CFDLocalizedString(@"取消_no") cancelHander:^{
            
        }];
        
    }
}

- (void)commitHander{
    [HUDUtil showProgress:@""];
    [DCService currencyexchange:_transfer1TextField.text fromcurrency:_type tocurrency:_toType success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            [HUDUtil showInfo:CFDLocalizedString(@"操作成功")];
            self.transfer1TextField.text = @"";
            self.transfer2TextField.text = @"";
            [self loadData:NO];
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
        }
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
    }];
}
- (void)allTransferAction{
    NSInteger index = 0;
    for (NSDictionary *dict in _accountList) {
        if ([NDataUtil boolWithDic:dict key:@"currencyType" isEqual:_type]&&_type.length>0) {
            index = [_accountList indexOfObject:dict];
        }
    }
    NSDictionary *fromDic = [NDataUtil dictWith:_accountList[index]];
    NSString *money = [GUIUtil compareFloat:fromDic[@"canUseMoney"] with:fromDic[@"maxExchangeMoney"]]==NSOrderedDescending?[NDataUtil stringWith:fromDic[@"maxExchangeMoney"]]:[NDataUtil stringWith:fromDic[@"canUseMoney"]];
    self.transfer1TextField.text = money;
    [self transfer1TextChanged];
}

- (void)transfer1TitleWillChange:(NSString *)type{
    NSInteger index = 0;
    for (NSDictionary *dict in _accountList) {
        if ([NDataUtil boolWithDic:dict key:@"currencyType" isEqual:type]&&type.length>0) {
            index = [_accountList indexOfObject:dict];
        }
    }
    NSDictionary *fromDic = [NDataUtil dictWith:_accountList[index]];
    [GUIUtil imageViewWithUrl:_transfer1ImgView url:fromDic[@"icon"]];
    if (![type isEqualToString:_type]) {
        _transfer1TitleLabel.text =
        _transfer1VarityLabel.text = type;
        NSString *money = [GUIUtil compareFloat:fromDic[@"canUseMoney"] with:fromDic[@"maxExchangeMoney"]]==NSOrderedDescending?[NDataUtil stringWith:fromDic[@"maxExchangeMoney"]]:[NDataUtil stringWith:fromDic[@"canUseMoney"]];
        _transfer1TextField.placeholder = [NSString stringWithFormat:@"%@%@%@",CFDLocalizedString(@"最多可换出"),money,_type];
        _transfer1TextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_transfer1TextField.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
        NSString *str = [NDataUtil stringWith:fromDic[@"tipList"]];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        attStr.lineSpacing = [GUIUtil fit:5];
        _tipsLabel.attributedText = attStr;
        self.rate = @"--";
        self.rateLabel.text = [NSString stringWithFormat:@"%@1%@=%@%@",CFDLocalizedString(@"汇率:"),type,self.rate,self.toType];
        [self loadRate];
    }
}

- (void)transfer2TitleWillChange:(NSString *)type{
    NSInteger toIndex = 0;
    for (NSDictionary *dict in _accountList) {
        if ([NDataUtil boolWithDic:dict key:@"currencyType" isEqual:type]&&type.length>0) {
            toIndex = [_accountList indexOfObject:dict];
        }
    }
    NSDictionary *toDic = [NDataUtil dictWith:_accountList[toIndex]];
    [GUIUtil imageViewWithUrl:_transfer2ImgView url:toDic[@"icon"]];
    if (![type isEqualToString:_toType]) {
        _transfer2TitleLabel.text =
        _transfer2VarityLabel.text = type;
        self.rate = @"--";
        self.rateLabel.text = [NSString stringWithFormat:@"%@1%@=%@%@",CFDLocalizedString(@"汇率:"),self.type,self.rate,type];
        [self loadRate];
    }
}

- (void)transfer1TextChanged{
    _isTransfer2Respond = NO;
    _transfer2TextField.text = [GUIUtil decimalMultiply:_transfer1TextField.text num:_rate];
    if (_transfer1TextField.text.length<=0) {
        _transfer2TextField.text = @"";
    }else{
        _transfer2TextField.text = [GUIUtil notRoundingString:_transfer2TextField.text afterPoint:8];
    }
}
- (void)transfer2TextChanged{
    _isTransfer2Respond = YES;
    _transfer1TextField.text = [GUIUtil decimalDivide:_transfer2TextField.text num:_rate];
    if (_transfer2TextField.text.length<=0) {
        _transfer1TextField.text = @"";
    }else{
        _transfer1TextField.text = [GUIUtil notRoundingString:_transfer1TextField.text afterPoint:8];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    NSInteger _decLength = 8;
    if ([string isEqualToString:@"."]) {
        NSInteger l = textField.text.length-range.location;
        if (l>_decLength) {
            return NO;
        }
    }
    NSRange ran = [textField.text rangeOfString:@"."];
    BOOL flag = ran.location != NSNotFound&&(ran.length+ran.location<=textField.text.length);
    BOOL pointFlag = [string isEqualToString:@"."];
    NSInteger pointNum =textField.text.length-_decLength;
    NSInteger ranNum = ran.length+ran.location;
    BOOL decFlag = (ran.location == NSNotFound)||(ranNum-pointNum>0); //小数点后是否没到两位
    BOOL numFlag = ([string integerValue]>0&&[string integerValue]<=9)||[string isEqualToString:@"0"];
    if (textField == _transfer1TextField||textField==_transfer2TextField){
        BOOL isReturn = NO;
        if (!flag&&pointFlag){
            isReturn = YES;
        }else if (numFlag&&decFlag) {
            isReturn = YES;
        }
        if (isReturn) {
            //限制长度9位;
            NSInteger strLength = textField.text.length - range.length + string.length;
            return (strLength <= 10+_decLength);
        }else{
            return NO;
        }
    }
    return YES;
}

- (void)addNotic{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotic{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notic{
    if (_transfer1TextField.isFirstResponder||_transfer2TextField.isFirstResponder) {
        UITextField *textField = _transfer2TextField;
        CGFloat textFieldBottom = [self.view convertPoint:CGPointMake(0, textField.bottom) fromView:_contentView].y;
        
        CGFloat keyboardFrameH = [[[notic userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height; //获得键盘
        BOOL flag = textFieldBottom+keyboardFrameH>SCREEN_HEIGHT;
        if (flag) {
            CGFloat duration = [[[notic userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]; //获得键盘时间
            WEAK_SELF;
            [UIView animateWithDuration:duration animations:^{
                weakSelf.scrollView.contentOffset = CGPointMake(0,textFieldBottom+keyboardFrameH-self.scrollView.height);
            }];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notic{
    [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
}


//MARK: - Getter

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [GColorUtil C6];
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.alwaysBounceHorizontal = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [GColorUtil C6];
    }
    return _headerView;
}
-(UILabel *)headerTitle{
    if (!_headerTitle) {
        _headerTitle = [[UILabel alloc] init];
        _headerTitle.textColor = [GColorUtil C3];
        _headerTitle.font = [GUIUtil fitBoldFont:14];
        _headerTitle.text = CFDLocalizedString(@"可用余额");
    }
    return _headerTitle;
}

-(UIView *)headerSeparateView{
    if (!_headerSeparateView) {
        _headerSeparateView = [[UIView alloc] init];
        _headerSeparateView.backgroundColor = [GColorUtil C8];
    }
    return _headerSeparateView;
}

-(UIView *)contentView{
    if(!_contentView){
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [GColorUtil C6];
    }
    return _contentView;
}
-(UIView *)varityView{
    if(!_varityView){
        _varityView = [[UIView alloc] init];
        _varityView.backgroundColor = [GColorUtil C6];
        WEAK_SELF;
        [_varityView g_clickBlock:^(UITapGestureRecognizer *tap) {
            [weakSelf.view endEditing:YES];
            CGFloat x = [tap locationInView:weakSelf.varityView].x;
            if (x<SCREEN_WIDTH/2-[GUIUtil fit:20]) {
                [CurrenttypeSelectedSheet showAlert:CFDLocalizedString(@"请选择币种") selected:weakSelf.type sureHander:^(NSDictionary * _Nonnull dict) {
                    weakSelf.transfer1TextField.text = @"";
                    weakSelf.transfer2TextField.text = @"";
                    NSString *type = [NDataUtil stringWith:dict[@"currency"]];
                    [weakSelf transfer1TitleWillChange:type];
                    weakSelf.type = type;
                    [weakSelf updatePlaceholder];
                }];
            }else if(x>SCREEN_WIDTH/2+[GUIUtil fit:20]){
                [CurrenttypeSelectedSheet showAlert:CFDLocalizedString(@"请选择币种") selected:weakSelf.toType sureHander:^(NSDictionary * _Nonnull dict) {
                    weakSelf.transfer1TextField.text = @"";
                    weakSelf.transfer2TextField.text = @"";
                    NSString *type = [NDataUtil stringWith:dict[@"currency"]];
                    [weakSelf transfer2TitleWillChange:type];
                    weakSelf.toType = type;
                    [weakSelf updatePlaceholder];
                }];
            }else{
                weakSelf.transfer1TextField.text = @"";
                weakSelf.transfer2TextField.text = @"";
                NSString *type = weakSelf.toType;
                NSString *toType = weakSelf.type;
                [weakSelf transfer1TitleWillChange:type];
                weakSelf.type = type;
                [weakSelf transfer2TitleWillChange:toType];
                weakSelf.toType = toType;
                [weakSelf updatePlaceholder];
            }
            
        }];
    }
    return _varityView;
}
-(UILabel *)transfer1VarityLabel{
    if(!_transfer1VarityLabel){
        _transfer1VarityLabel = [[UILabel alloc] init];
        _transfer1VarityLabel.textColor = [GColorUtil C2];
        _transfer1VarityLabel.font = [GUIUtil fitBoldFont:16];
    }
    return _transfer1VarityLabel;
}
-(UILabel *)transfer2VarityLabel{
    if(!_transfer2VarityLabel){
        _transfer2VarityLabel = [[UILabel alloc] init];
        _transfer2VarityLabel.textColor = [GColorUtil C2];
        _transfer2VarityLabel.font = [GUIUtil fitBoldFont:16];
    }
    return _transfer2VarityLabel;
}
-(UILabel *)rateLabel{
    if(!_rateLabel){
        _rateLabel = [[UILabel alloc] init];
        _rateLabel.textColor = [GColorUtil C13];
        _rateLabel.font = [GUIUtil fitFont:12];
    }
    return _rateLabel;
}
-(UILabel *)transfer1TitleLabel{
    if(!_transfer1TitleLabel){
        _transfer1TitleLabel = [[UILabel alloc] init];
        _transfer1TitleLabel.textColor = [GColorUtil C2];
        _transfer1TitleLabel.font = [GUIUtil fitFont:14];
    }
    return _transfer1TitleLabel;
}
-(UILabel *)transfer2TitleLabel{
    if(!_transfer2TitleLabel){
        _transfer2TitleLabel = [[UILabel alloc] init];
        _transfer2TitleLabel.textColor = [GColorUtil C2];
        _transfer2TitleLabel.font = [GUIUtil fitFont:14];
    }
    return _transfer2TitleLabel;
}

-(UILabel *)tipsLabel{
    if(!_tipsLabel){
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.textColor = [GColorUtil C3];
        _tipsLabel.font = [GUIUtil fitFont:12];
        _tipsLabel.numberOfLines = 0;
    }
    return _tipsLabel;
}
-(UITextField *)transfer1TextField{
    if(!_transfer1TextField){
        _transfer1TextField = [[UITextField alloc] init];
        _transfer1TextField.textColor = [GColorUtil C2];
        _transfer1TextField.font = [GUIUtil fitFont:16];
        _transfer1TextField.placeholder = [NSString stringWithFormat:@"%@--",CFDLocalizedString(@"最多可换出")];
        _transfer1TextField.keyboardType = UIKeyboardTypeDecimalPad;
        _transfer1TextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_transfer1TextField.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
        _transfer1TextField.delegate = self;
        _transfer1TextField.adjustsFontSizeToFitWidth = YES;
        _transfer1TextField.minimumFontSize = 0.5;
        WEAK_SELF;
        [_transfer1TextField addTarget:weakSelf action:@selector(transfer1TextChanged) forControlEvents:UIControlEventEditingChanged];
        _transfer1TextField.enabled = YES;
        _transfer1TextField.userInteractionEnabled = YES;
        [_transfer1TextField addToolbar];
    }
    return _transfer1TextField;
}
-(UITextField *)transfer2TextField{
    if(!_transfer2TextField){
        _transfer2TextField = [[UITextField alloc] init];
        _transfer2TextField.textColor = [GColorUtil C2];
        _transfer2TextField.font = [GUIUtil fitFont:16];
        _transfer2TextField.placeholder = [NSString stringWithFormat:@"%@--",CFDLocalizedString(@"最多可换为")];
        _transfer2TextField.keyboardType = UIKeyboardTypeDecimalPad;
        _transfer2TextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_transfer2TextField.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
        _transfer2TextField.delegate = self;
        _transfer2TextField.adjustsFontSizeToFitWidth = YES;
        _transfer2TextField.minimumFontSize = 0.5;
        WEAK_SELF;
        [_transfer2TextField addTarget:weakSelf action:@selector(transfer2TextChanged) forControlEvents:UIControlEventEditingChanged];
        [_transfer2TextField addToolbar];
    }
    return _transfer2TextField;
}

-(UIImageView *)transfer1ArrowView{
    if(!_transfer1ArrowView){
        _transfer1ArrowView = [[UIImageView alloc] init];
        _transfer1ArrowView.image = [GColorUtil imageNamed:@"market_icon_under_blue_down"];
    }
    return _transfer1ArrowView;
}
-(UIImageView *)transfer2ArrowView{
    if(!_transfer2ArrowView){
        _transfer2ArrowView = [[UIImageView alloc] init];
        _transfer2ArrowView.image = [GColorUtil imageNamed:@"market_icon_under_blue_down"];
    }
    return _transfer2ArrowView;
}
-(UIImageView *)transferArrowView{
    if(!_transferArrowView){
        _transferArrowView = [[UIImageView alloc] init];
        _transferArrowView.image = [GColorUtil imageNamed:@"assets_exchange_icon_arrow2"];
    }
    return _transferArrowView;
}
-(UIImageView *)transfer1ImgView{
    if(!_transfer1ImgView){
        _transfer1ImgView = [[UIImageView alloc] init];
    }
    return _transfer1ImgView;
}
-(UIImageView *)transfer2ImgView{
    if(!_transfer2ImgView){
        _transfer2ImgView = [[UIImageView alloc] init];
    }
    return _transfer2ImgView;
}
-(UIImageView *)transferImgView{
    if(!_transferImgView){
        _transferImgView = [[UIImageView alloc] init];
        _transferImgView.image = [GColorUtil imageNamed:@"assets_exchange_icon_arrow3"];
    }
    return _transferImgView;
}
-(UIButton *)allTransferBtn{
    if(!_allTransferBtn){
        _allTransferBtn = [[UIButton alloc] init];
        [_allTransferBtn setTitle:CFDLocalizedString(@"全部兑换") forState:UIControlStateNormal];
        [_allTransferBtn setTitleColor:[GColorUtil C13] forState:UIControlStateNormal];
        _allTransferBtn.titleLabel.font = [GUIUtil fitFont:12];
        [_allTransferBtn addTarget:self action:@selector(allTransferAction) forControlEvents:UIControlEventTouchUpInside];
        [_allTransferBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
    }
    return _allTransferBtn;
}
-(UIView *)tipsMinMark{
    if(!_tipsMinMark){
        _tipsMinMark = [[UIImageView alloc] init];
        _tipsMinMark.backgroundColor = [GColorUtil C4];
        _tipsMinMark.layer.cornerRadius = [GUIUtil fit:3];
        _tipsMinMark.layer.masksToBounds = YES;
        _tipsMinMark.hidden = YES;
    }
    return _tipsMinMark;
}
-(UIView *)tipsMaxMark{
    if(!_tipsMaxMark){
        _tipsMaxMark = [[UIView alloc] init];
        _tipsMaxMark.backgroundColor = [GColorUtil C4];
        _tipsMaxMark.layer.cornerRadius = [GUIUtil fit:3];
        _tipsMaxMark.layer.masksToBounds = YES;
        _tipsMaxMark.hidden = YES;
    }
    return _tipsMaxMark;
}
-(UIView *)tipsMark{
    if(!_tipsMark){
        _tipsMark = [[UIImageView alloc] init];
        _tipsMark.backgroundColor = [GColorUtil C4];
        _tipsMark.layer.cornerRadius = [GUIUtil fit:3];
        _tipsMark.layer.masksToBounds = YES;
        _tipsMark.hidden = YES;
    }
    return _tipsMark;
}
-(UIButton *)commitBtn{
    if(!_commitBtn){
        _commitBtn = [[UIButton alloc] init];
        _commitBtn.backgroundColor = [GColorUtil C13];
        [_commitBtn setTitle:CFDLocalizedString(@"提交订单_兑换") forState:UIControlStateNormal];
        [_commitBtn setTitleColor:[GColorUtil C5] forState:UIControlStateNormal];
        _commitBtn.titleLabel.font = [GUIUtil fitFont:16];
        [_commitBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}



@end
