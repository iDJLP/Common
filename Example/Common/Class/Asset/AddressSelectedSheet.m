//
//  AddressSelectedSheet.m
//  Bitmixs
//
//  Created by ngw15 on 2019/10/11.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "AddressSelectedSheet.h"
#import "SelectedSheet.h"
#import "BaseCell.h"
#import "AddressEditVC.h"

@interface AddressSelectedSheetCell : BaseCell

@property (nonatomic,strong)UIImageView *logoView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *remarkLabel;
@property (nonatomic,strong)UIImageView *selectedImgView;
@property (nonatomic,strong)UIView *line;

@property (nonatomic,strong)NSDictionary *config;
@end

@implementation AddressSelectedSheetCell



+ (CGFloat)heightOfRow{
    
    return [GUIUtil fit:75];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self autoLayout];
    }
    return self;
}


- (void)setupUI{
    [self.contentView addSubview:self.logoView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.remarkLabel];
    [self.contentView addSubview:self.selectedImgView];
    [self.contentView addSubview:self.line];
}

- (void)autoLayout{
    [_logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.centerY.mas_equalTo([GUIUtil fit:0]);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:50]);
        make.bottom.equalTo(self.contentView.mas_centerY).mas_offset([GUIUtil fit:-2]);
    }];
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:50]);
        make.top.equalTo(self.contentView.mas_centerY).mas_offset([GUIUtil fit:3]);
    }];
    [_selectedImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.centerY.mas_equalTo(0);
    }];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
}

- (void)configOfRow:(NSDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _config = dict;
    
    _titleLabel.text = [NDataUtil stringWith:dict[@"label"]];
    _remarkLabel.text = [NDataUtil stringWith:dict[@"address"]];
    if ([NDataUtil boolWithDic:dict key:@"isSelected" isEqual:@"1"]) {
        self.selectedImgView.hidden = NO;
        self.titleLabel.textColor =
        self.remarkLabel.textColor = [GColorUtil C13];
    }else{
        self.titleLabel.textColor =
        self.remarkLabel.textColor = [GColorUtil C2];
        self.selectedImgView.hidden = YES;
    }
    NSString *type = [NDataUtil stringWith:dict[@"currentType"]];
    if ([type isEqualToString:@"USDT"]) {
        _logoView.image = [UIImage imageNamed:@"assets_popicon_usdt"];
    }else if ([type isEqualToString:@"BTC"]){
        _logoView.image = [UIImage imageNamed:@"assets_popicon_btc"];
    }else if ([type isEqualToString:@"ETH"]){
        _logoView.image = [UIImage imageNamed:@"assets_popicon_eth"];
    }
}
//MARK:Getter

- (UIImageView *)logoView{
    if(!_logoView){
        _logoView = [[UIImageView alloc] init];
    }
    return _logoView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [GColorUtil C2];
        _titleLabel.font = [GUIUtil fitFont:16];
    }
    return _titleLabel;
}

- (UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.textColor = [GColorUtil C2];
        _remarkLabel.font = [GUIUtil fitFont:12];
    }
    return _remarkLabel;
}

- (UIImageView *)selectedImgView{
    if(!_selectedImgView){
        _selectedImgView = [[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"mine_icon_selecte_blue"]];
    }
    return _selectedImgView;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [GColorUtil C7];
    }
    return _line;
}

@end

@interface AddressSelectedSheetView : UIControl <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *remarkLabel;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UIView *line;

@property (nonatomic,strong)NSArray *dataList;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,strong) void(^sureHander)(NSDictionary *);

@end

@implementation AddressSelectedSheetView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [GColorUtil colorWithHex:0x000000 alpha:0.4];
        [self setupUI];
        [self autoLayout];
        [self addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.remarkLabel];
    [self.contentView addSubview:self.line1];
    [self.contentView addSubview:self.cancelBtn];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.tableView];
}

- (void)autoLayout{
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:0]);
        make.left.mas_equalTo([GUIUtil fit:20]);
        make.height.mas_equalTo([GUIUtil fit:60]);
    }];
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.mas_equalTo([GUIUtil fit:-20]);
    }];
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.line1.mas_bottom);
        make.height.mas_equalTo([GUIUtil fit:180]);
    }];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.cancelBtn.mas_top);
        make.height.mas_equalTo([GUIUtil fit:7]);
    }];
   
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-IPHONE_X_BOTTOM_HEIGHT);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([GUIUtil fit:50]);
    }];
}

- (void)setDataList:(NSArray *)dataList{
    _dataList = dataList;
    [_tableView reloadData];
}

//MARK: - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressSelectedSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressSelectedSheetCell"];
    [cell configOfRow:[NDataUtil dataWithArray:_dataList index:indexPath.row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = [NDataUtil dataWithArray:_dataList index:indexPath.row];
    [self sureAction:dict];
}

//MARK: - Action

- (void)showAnimation{
    [self layoutIfNeeded];
    self.contentView.top = SCREEN_HEIGHT;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.bottom = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)sureAction:(NSDictionary *)dic{
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if(self.sureHander){
            self.sureHander(dic);
        }
    }];
}

- (void)cancelAction{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//MARK: - Getter

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [GColorUtil C6];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-BOTTOM_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [GColorUtil C6];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = [AddressSelectedSheetCell heightOfRow];
        [_tableView registerClass:[AddressSelectedSheetCell class] forCellReuseIdentifier:@"AddressSelectedSheetCell"];
    }
    return _tableView;
}


-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = CFDLocalizedString(@"请选择币种");
        _titleLabel.font =[GUIUtil fitFont:16];
        _titleLabel.textColor = [GColorUtil C2];
    }
    return _titleLabel;
}

-(UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.text = CFDLocalizedString(@"添加地址");
        _remarkLabel.font =[GUIUtil fitFont:12];
        _remarkLabel.textColor = [GColorUtil C13];
        WEAK_SELF;
        [_remarkLabel g_clickBlock:^(UITapGestureRecognizer *tap) {
            [weakSelf cancelAction];
            [AddressEditVC jumpTo:@{@"currentType":weakSelf.type}];
        }];
    }
    return _remarkLabel;
}



- (UIView *)line1{
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = [GColorUtil C7];
    }
    return _line1;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [GColorUtil C8];
    }
    return _line;
}


- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:CFDLocalizedString(@"取消") forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [GUIUtil fitFont:16];
        [_cancelBtn setTitleColor:[GColorUtil C3] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

@end


@implementation AddressSelectedSheet

+ (void)loadData:(NSString *)type success:(void (^)(NSArray *data))success failure:(dispatch_block_t)failure{
    [DCService addresslist:type success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            [HUDUtil hide];
            NSArray *dataList = [NDataUtil arrayWith:data[@"data"]];
            success(dataList);
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
        }
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
    }];
    
}

+ (NSArray *)dataListAddSelected:(NSString *)selected dataList:(NSArray *)list{
    NSMutableArray *tem = [NSMutableArray array];
    for (NSDictionary *dic in list) {
        NSMutableDictionary *dict = dic.mutableCopy;
        if ([NDataUtil boolWithDic:dic key:@"address" isEqual:selected]) {
            [dict setObject:@"1" forKey:@"isSelected"];
        }
        [tem addObject:dict];
    }
    return tem;
}


+ (void)showAlert:(NSString *)title
         selected:(NSString *)selected
             type:(NSString *)type
       sureHander:(void(^)(NSDictionary *))sureHander{
    
    [self loadData:type success:^(NSArray *dataList){
        NSArray *data = [self dataListAddSelected:selected dataList:dataList];
        UIWindow *window = [GJumpUtil window];
        AddressSelectedSheetView *view = [[AddressSelectedSheetView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        view.dataList = data;
        view.type = type;
        view.titleLabel.text = title;
        view.sureHander = sureHander;
        view.tag = 4616;
        [window addSubview:view];
        [view showAnimation];
    } failure:^{
        
    }];
}

@end




