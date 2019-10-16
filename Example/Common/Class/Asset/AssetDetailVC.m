//
//  AssetDetailVC.m
//  Bitmixs
//
//  Created by ngw15 on 2019/6/11.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "AssetDetailVC.h"
#import "AssetActionView.h"
#import "BaseTableView.h"
#import "AssetDetailCell.h"

@interface AssetDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)BaseView *headerView;
@property (nonatomic,strong)BaseLabel *title1Label;
@property (nonatomic,strong)BaseLabel *text1Label;
@property (nonatomic,strong)BaseLabel *value1Label;
@property (nonatomic,strong)BaseLabel *title2Label;
@property (nonatomic,strong)BaseImageView *markImgView;
@property (nonatomic,strong)BaseLabel *text2Label;
@property (nonatomic,strong)BaseLabel *value2Label;
@property (nonatomic,strong)BaseLabel *title3Label;
@property (nonatomic,strong)BaseLabel *text3Label;
@property (nonatomic,strong)BaseLabel *value3Label;
@property (nonatomic,strong)BaseView *separate1View;
@property (nonatomic,strong)AssetActionView *controlView;
@property (nonatomic,strong)BaseView *separate2View;
@property (nonatomic,strong)BaseTableView *tableView;

@property (nonatomic,strong)BaseView *sectionView;
@property (nonatomic,strong)BaseLabel *sectionTitleLabel;
@property (nonatomic,strong)BaseLabel *sectionTextLabel;

@property (nonatomic,strong)NSDictionary *config;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSArray *dataArrayClose;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *tips;
@property(nonatomic,assign) BOOL openEye;
@end

@implementation AssetDetailVC

+ (void)jumpTo:(NSString *)title{
    
    AssetDetailVC *target = [AssetDetailVC new];
    target.type = title;
    target.hidesBottomBarWhenPushed = YES;
    [GJumpUtil pushVC:target animated:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = self.type;
    WEAK_SELF;
    _openEye = [NLocalUtil boolForKey:@"openEye_assetsDetail"];
    [self setVCRighticon];
    [self setupUI];
    [self autoLayout];
    
    [self loadProfit:NO];
    [GUIUtil refreshWithHeader:_tableView refresh:^{
        [weakSelf loadProfit:NO];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startTimer];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [NTimeUtil stopTimer:@"AssetDetailVC"];
}

- (void)setupUI{
    [self.view addSubview:self.tableView];
    [self.headerView addSubview:self.title1Label];
    [self.headerView addSubview:self.text1Label];
    [self.headerView addSubview:self.value1Label];
    [self.headerView addSubview:self.title2Label];
    [self.headerView addSubview:self.text2Label];
    [self.headerView addSubview:self.markImgView];
    [self.headerView addSubview:self.value2Label];
    [self.headerView addSubview:self.title3Label];
    [self.headerView addSubview:self.text3Label];
    [self.headerView addSubview:self.value3Label];
    [self.headerView addSubview:self.separate1View];
    [self.headerView addSubview:self.controlView];
    [self.headerView addSubview:self.separate2View];
}

- (void)autoLayout{
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [_title1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.mas_equalTo([GUIUtil fit:15]);
    }];
    [_text1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title1Label);
        make.top.equalTo(self.title1Label.mas_bottom).mas_offset([GUIUtil fit:1]);
    }];
    [_value1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title1Label);
        make.top.equalTo(self.text1Label.mas_bottom).mas_offset([GUIUtil fit:2]);
    }];
    [_title2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.equalTo(self.value1Label.mas_bottom).mas_offset([GUIUtil fit:30]);
    }];
    [_markImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.title2Label.mas_centerY);
        make.left.equalTo(self.title2Label.mas_right).mas_offset([GUIUtil fit:5]);
    }];
    [_text2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title2Label);
        make.top.equalTo(self.title2Label.mas_bottom).mas_offset([GUIUtil fit:3]);
    }];
    [_value2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title2Label);
        make.top.equalTo(self.text2Label.mas_bottom).mas_offset([GUIUtil fit:2]);
    }];
    [_title3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:198]);
        make.top.equalTo(self.title2Label);
    }];
    [_text3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title3Label);
        make.top.equalTo(self.title3Label.mas_bottom).mas_offset([GUIUtil fit:3]);
    }];
    [_value3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title3Label);
        make.top.equalTo(self.text3Label.mas_bottom).mas_offset([GUIUtil fit:2]);
    }];
    [_separate1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([GUIUtil fit:7]);
        make.top.equalTo(self.value3Label.mas_bottom).mas_offset([GUIUtil fit:15]);
    }];
    [_controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.separate1View.mas_bottom).mas_offset([GUIUtil fit:00]);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([AssetActionView heightOfView]);
    }];
    [_separate2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([GUIUtil fit:7]);
        make.top.equalTo(self.controlView.mas_bottom).mas_offset([GUIUtil fit:0]);
        make.bottom.mas_equalTo(0);
    }];
    
}

//MARK: - Load

- (void)loadProfit:(BOOL)isAuto{
    if (![UserModel isLogin]) {
        [self.tableView.mj_header endRefreshing];
        return;
    }
    WEAK_SELF;
    [DCService postgetUserAccountDetail:_type success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            [weakSelf updateView:data[@"data"]];
            if (isAuto==NO) {
                [weakSelf.tableView.mj_header endRefreshing];
            }
        }else{
            if (isAuto==NO) {
                [weakSelf.tableView.mj_header endRefreshing];
                [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
            }
        }
    } failure:^(NSError *error) {
        if (isAuto==NO) {
            [weakSelf.tableView.mj_header endRefreshing];
            [FTConfig webTips];
        }
    }];
}

- (void)startTimer{
    WEAK_SELF;
    [NTimeUtil startTimer:@"AssetDetailVC" interval:5 repeats:YES action:^{
        [weakSelf loadProfit:YES];
    }];
}

- (void)updateView:(NSDictionary *)dic{
    _config = dic;
    _tips = [NDataUtil stringWith:dic[@"tip"]];
    _sectionTextLabel.text = _sectionTextLabel.text = [NSString stringWithFormat:@"%@%@",CFDLocalizedString(@"实时汇率："),[NDataUtil stringWith:dic[@"rate"]]];
    _dataArray = [NDataUtil arrayWith:dic[@"accountDetailList"]];
    NSMutableArray *tem = [NSMutableArray array];
    for (NSInteger i=0 ; i<_dataArray.count; i++) {
        NSDictionary *d = _dataArray[i];
        NSMutableDictionary *dict = d.mutableCopy;
        [dict setObject:@"*****" forKey:@"amount"];
        [dict setObject:@"*****" forKey:@"amountCNY"];
        [tem addObject:dict];
    }
    _dataArrayClose = tem.copy;
    [self eyeChangedAction];
}

- (void)eyeChangedAction{
    
    [NLocalUtil setBool:_openEye forKey:@"openEye_assetsDetail"];
    if (_openEye==NO) {
        _text1Label.text = @"*****";
        _value1Label.text = [NSString stringWithFormat:@"≈**CNY"];
        _text2Label.text = @"*****";
        _value2Label.text = [NSString stringWithFormat:@"≈**CNY"];
        _text3Label.text = @"*****";
        _value3Label.text = [NSString stringWithFormat:@"≈**CNY"];
        _value1Label.txColor =
        _text1Label.txColor = C2_ColorType;
    }else{
        if ([_text1Label.text floatValue]>0) {
            _value1Label.txColor =
            _text1Label.txColor = C11_ColorType;
        }else if ([_text1Label.text floatValue]<0){
            _value1Label.txColor =
            _text1Label.txColor = C12_ColorType;
        }else{
            _value1Label.txColor =
            _text1Label.txColor = C2_ColorType;
        }
        _text1Label.text = [NDataUtil stringWith:_config[@"totalProfit"]];
        _value1Label.text = [NSString stringWithFormat:@"≈%@CNY",[NDataUtil stringWith:_config[@"totalProfitCNY"]]];
        _text2Label.text = [NDataUtil stringWith:_config[@"totalAmount"]];
        _value2Label.text = [NSString stringWithFormat:@"≈%@CNY",[NDataUtil stringWith:_config[@"totalAmountCNY"]]];
        _text3Label.text = [NDataUtil stringWith:_config[@"totalCanUseAmount"]];
        _value3Label.text = [NSString stringWithFormat:@"≈%@CNY",[NDataUtil stringWith:_config[@"totalCanUseAmountCNY"]]];
    }
    [_tableView reloadData];
}

//TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssetDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssetDetailCell"];
    NSDictionary *dic = _openEye?[NDataUtil dataWithArray:_dataArray index:indexPath.row]:[NDataUtil dataWithArray:_dataArrayClose index:indexPath.row];
    [cell configOfCell:dic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  [GUIUtil fit:60];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [GUIUtil fit:49];
}

//MARK: - Getter

- (BaseImageView *)setVCRighticon{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.2f, 44)];
    BaseImageView *righticon=[[BaseImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.2f-15,(44-15)/2,15,15)];
    if (self.openEye) {
        righticon.imageName = @"assets_icon_eye";
    }else{
        righticon.imageName = @"assets_icon_eye_close";
    }
    [customView addSubview:righticon];
    WEAK_SELF;
    [customView g_clickBlock:^(UITapGestureRecognizer *tap) {
        weakSelf.openEye = !weakSelf.openEye;
        [weakSelf eyeChangedAction];
        if (weakSelf.openEye) {
            righticon.imageName = @"assets_icon_eye";
        }else{
            righticon.imageName = @"assets_icon_eye_close";
        }
    }];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.navigationItem.rightBarButtonItems=@[item];
    return righticon;
}

- (BaseView *)headerView{
    if (!_headerView) {
        CGFloat height = [GUIUtil fit:15] + [GUIUtil fitFont:12].lineHeight + [GUIUtil fit:1] + [GUIUtil fitFont:25].lineHeight + [GUIUtil fit:2] + [GUIUtil fitFont:12].lineHeight + [GUIUtil fit:30] + [GUIUtil fitFont:12].lineHeight + [GUIUtil fit:3] + [GUIUtil fitFont:16].lineHeight + [GUIUtil fit:2] + [GUIUtil fitFont:12].lineHeight + [GUIUtil fit:15] + [GUIUtil fit:7] + [AssetActionView heightOfView] + [GUIUtil fit:7];
        _headerView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ceil((height)))];
        _headerView.backgroundColor = [GColorUtil C6];
    }
    return _headerView;
}


- (BaseLabel *)title1Label{
    if(!_title1Label){
        _title1Label = [[BaseLabel alloc] init];
        _title1Label.txColor = C2_ColorType;
        _title1Label.font = [GUIUtil fitFont:12];
        _title1Label.text = CFDLocalizedString(@"浮动盈亏");
    }
    return _title1Label;
}
- (BaseLabel *)text1Label{
    if(!_text1Label){
        _text1Label = [[BaseLabel alloc] init];
        _text1Label.txColor = C2_ColorType;
        _text1Label.font = [GUIUtil fitFont:25];
        _text1Label.text = @"--";
    }
    return _text1Label;
}
- (BaseLabel *)value1Label{
    if(!_value1Label){
        _value1Label = [[BaseLabel alloc] init];
        _value1Label.txColor = C2_ColorType;
        _value1Label.font = [GUIUtil fitFont:12];
        _value1Label.text = @"--";
    }
    return _value1Label;
}
- (BaseLabel *)title2Label{
    if(!_title2Label){
        _title2Label = [[BaseLabel alloc] init];
        _title2Label.txColor = C2_ColorType;
        _title2Label.font = [GUIUtil fitFont:12];
        _title2Label.text = CFDLocalizedString(@"总权益");
        WEAK_SELF;
        [_title2Label g_clickBlock:^(UITapGestureRecognizer *tap) {
            [DCAlert showAlert:@"" detail:weakSelf.tips sureTitle:CFDLocalizedString(@"知道了") sureHander:^{
                
            }];
        }];
    }
    return _title2Label;
}
- (BaseImageView *)markImgView{
    if (!_markImgView) {
        _markImgView = [[BaseImageView alloc] init];
        _markImgView.image = [GColorUtil imageNamed:@"assets_icon_instructions"];
        WEAK_SELF;
        [_markImgView g_clickBlock:^(UITapGestureRecognizer *tap) {
            
            [DCAlert showAlert:@"" detail:weakSelf.tips sureTitle:CFDLocalizedString(@"知道了") sureHander:^{
                
            }];
        }];
    }
    return _markImgView;
}
- (BaseLabel *)text2Label{
    if(!_text2Label){
        _text2Label = [[BaseLabel alloc] init];
        _text2Label.txColor = C2_ColorType;
        _text2Label.font = [GUIUtil fitFont:16];
        _text2Label.text = @"--";
    }
    return _text2Label;
}
- (BaseLabel *)value2Label{
    if(!_value2Label){
        _value2Label = [[BaseLabel alloc] init];
        _value2Label.txColor = C2_ColorType;
        _value2Label.font = [GUIUtil fitFont:12];
        _value2Label.text = @"--";
    }
    return _value2Label;
}
- (BaseLabel *)title3Label{
    if(!_title3Label){
        _title3Label = [[BaseLabel alloc] init];
        _title3Label.txColor = C2_ColorType;
        _title3Label.font = [GUIUtil fitFont:12];
        _title3Label.text = CFDLocalizedString(@"可用余额");
    }
    return _title3Label;
}
- (BaseLabel *)text3Label{
    if(!_text3Label){
        _text3Label = [[BaseLabel alloc] init];
        _text3Label.txColor = C2_ColorType;
        _text3Label.font = [GUIUtil fitFont:16];
        _text3Label.text = @"--";
    }
    return _text3Label;
}
- (BaseLabel *)value3Label{
    if(!_value3Label){
        _value3Label = [[BaseLabel alloc] init];
        _value3Label.txColor = C2_ColorType;
        _value3Label.font = [GUIUtil fitFont:12];
        _value3Label.text = @"--";
    }
    return _value3Label;
}

- (BaseView *)separate1View{
    if (!_separate1View) {
        _separate1View = [[BaseView alloc] init];
        _separate1View.bgColor = C8_ColorType;
    }
    return _separate1View;
}

- (AssetActionView *)controlView{
    if (!_controlView) {
        _controlView = [[AssetActionView alloc] init];
        _controlView.bgColor = C6_ColorType;
        _controlView.type = _type;
    }
    return _controlView;
}

- (BaseView *)separate2View{
    if (!_separate2View) {
        _separate2View = [[BaseView alloc] init];
        _separate2View.bgColor = C8_ColorType;
    }
    return _separate2View;
}

- (BaseView *)sectionView{
    if (!_sectionView) {
        _sectionView = [[BaseView alloc] init];
        _sectionView.backgroundColor = [GColorUtil C6];
        [_sectionView addSubview:self.sectionTitleLabel];
        [_sectionView addSubview:self.sectionTextLabel];
        [_sectionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:15]);
            make.centerY.mas_equalTo([GUIUtil fit:0]);
        }];
        [_sectionTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo([GUIUtil fit:-15]);
            make.centerY.mas_equalTo([GUIUtil fit:0]);
        }];
    }
    return _sectionView;
}

- (BaseLabel *)sectionTitleLabel{
    if(!_sectionTitleLabel){
        _sectionTitleLabel = [[BaseLabel alloc] init];
        _sectionTitleLabel.txColor = C3_ColorType;
        _sectionTitleLabel.font = [GUIUtil fitFont:14];
        _sectionTitleLabel.text = CFDLocalizedString(@"资产明细");
    }
    return _sectionTitleLabel;
}
- (BaseLabel *)sectionTextLabel{
    if(!_sectionTextLabel){
        _sectionTextLabel = [[BaseLabel alloc] init];
        _sectionTextLabel.txColor = C13_ColorType;
        _sectionTextLabel.font = [GUIUtil fitFont:12];
        _sectionTextLabel.text = @"--";
    }
    return _sectionTextLabel;
}

- (BaseTableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-BOTTOM_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bgColor = C6_ColorType;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[AssetDetailCell class] forCellReuseIdentifier:@"AssetDetailCell"];
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

@end
