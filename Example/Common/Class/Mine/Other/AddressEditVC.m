//
//  AddressEditVC.m
//  Bitmixs
//
//  Created by ngw15 on 2019/10/9.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "AddressEditVC.h"
#import "QRCodeVC.h"

@interface AddressEditVC ()

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIView *typeView;
@property (nonatomic,strong)UILabel *typeTitle;
@property (nonatomic,strong)UILabel *typeText;

@property (nonatomic,strong)UILabel *markTitle;
@property (nonatomic,strong)UIView *markView;
@property (nonatomic,strong)UITextField *markField;

@property (nonatomic,strong)UILabel *addressTitle;
@property (nonatomic,strong)UIView *addressView;
@property (nonatomic,strong)UITextField *addressField;
@property (nonatomic,strong)UIButton *addressBtn;
@property (nonatomic,strong)UIButton *commitBtn;

@property (nonatomic,strong)UILabel *errorLabel;

@property (nonatomic,strong)NSDictionary *config;


@end

@implementation AddressEditVC

+ (void)jumpTo:(NSDictionary *)config{
    AddressEditVC *target = [[AddressEditVC alloc] init];
    target.config = config;
    target.hidesBottomBarWhenPushed = YES;
    [GJumpUtil pushVC:target animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [GColorUtil C8];
    if (_config.count<=1) {
        //添加地址
        self.title=  CFDLocalizedString(@"添加地址");
    }else{
        //编辑地址
        self.title=  CFDLocalizedString(@"编辑出金地址");
        WEAK_SELF;
        [GNavUtil rightTitle:self title:CFDLocalizedString(@"删除") color:C2_ColorType onClick:^{
            [DCAlert showAlert:@"" detail:CFDLocalizedString(@"您确定删除该出金地址吗？") sureTitle:CFDLocalizedString(@"确定") sureHander:^{
                [weakSelf deleteAction];
            } cancelTitle:CFDLocalizedString(@"取消") cancelHander:^{
                
            }];
        }];
    }
    [self setupUI];
    [self autoLayout];
    [self configVC];
}

- (void)setupUI{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.typeView];
    [self.scrollView addSubview:self.typeTitle];
    [self.scrollView addSubview:self.typeText];
    [self.scrollView addSubview:self.markTitle];
    [self.scrollView addSubview:self.markView];
    [self.scrollView addSubview:self.markField];
    [self.scrollView addSubview:self.addressTitle];
    [self.scrollView addSubview:self.addressView];
    [self.scrollView addSubview:self.addressField];
    [self.scrollView addSubview:self.errorLabel];
    [self.view addSubview:self.commitBtn];
}

- (void)autoLayout{
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo([GUIUtil fit:-49]-IPHONE_X_BOTTOM_HEIGHT);
    }];
    [_typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:10]);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([GUIUtil fit:60]);
    }];
    [_typeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.centerY.equalTo(self.typeView);
    }];
    [_typeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_left).mas_offset(SCREEN_WIDTH-[GUIUtil fit:15]);
        make.centerY.equalTo(self.typeView);
    }];
    [_markTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeView.mas_bottom).mas_offset([GUIUtil fit:15]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [_markView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.markTitle.mas_bottom).mas_offset([GUIUtil fit:5]);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([GUIUtil fit:60]);
    }];
    [_markField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.centerY.equalTo(self.markView);
        make.right.equalTo(self.view.mas_left).mas_offset(SCREEN_WIDTH-[GUIUtil fit:15]);
        make.height.mas_equalTo([GUIUtil fit:60]);
    }];
    [_addressTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.markView.mas_bottom).mas_offset([GUIUtil fit:15]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [_addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressTitle.mas_bottom).mas_offset([GUIUtil fit:5]);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([GUIUtil fit:60]);
    }];
    [_addressField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.centerY.equalTo(self.addressView);
        make.right.equalTo(self.view.mas_left).mas_offset(SCREEN_WIDTH-[GUIUtil fit:15]);
        make.height.mas_equalTo([GUIUtil fit:60]);
    }];
    [_errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressView.mas_bottom).mas_offset([GUIUtil fit:12]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
       make.height.mas_equalTo([GUIUtil fit:49]);
        make.bottom.mas_equalTo(-IPHONE_X_BOTTOM_HEIGHT);
        
    }];
}

//MARK: - Getter

- (void)configVC{
    _typeText.text = [NDataUtil stringWith:_config[@"currentType"]];
    _markField.text = [NDataUtil stringWith:_config[@"label"]];
    _addressField.text = [NDataUtil stringWith:_config[@"address"]];
}

- (void)commitAction{
    NSString *errorText = @"";
    if (_markField.text.length<=0) {
        errorText = CFDLocalizedString(@"输入标签，不超过10个字符");
    }
    else if (_addressField.text.length<=0) {
        errorText = CFDLocalizedString(@"输入地址或点击右方图标扫码");
    }
    else if (_markField.text.length>10) {
        errorText = CFDLocalizedString(@"标签内容不得超过10个字符");
    }
    if (errorText.length>0) {
        _errorLabel.text = errorText;
        _errorLabel.hidden = NO;
        return;
    }
    _errorLabel.hidden = YES;
    if (_config.count<=1) {
        //添加地址
        [self addAction];
    }else{
        //编辑地址
        [self updateAction];
    }
}

- (void)deleteAction{
    NSDictionary *dict = @{@"addressid":[NDataUtil stringWith:_config[@"addressid"]]};
    [DCService addressManage:@"3" currenttype:_config[@"currentType"] params:dict success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            [HUDUtil showInfo:CFDLocalizedString(@" 操场成功")];
            [GJumpUtil popAnimated:YES];
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
        }
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
    }];
}

- (void)updateAction{
    NSDictionary *dict = @{@"addressid":[NDataUtil stringWith:_config[@"addressid"]],@"address":_addressField.text,@"label":_markField.text};
    [DCService addressManage:@"1" currenttype:_config[@"currentType"] params:dict success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            [HUDUtil showInfo:CFDLocalizedString(@" 操场成功")];
            [GJumpUtil popAnimated:YES];
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
        }
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
    }];
}

- (void)addAction{
    NSDictionary *dict = @{@"address":_addressField.text,@"label":_markField.text};
    [DCService addressManage:@"2" currenttype:_config[@"currentType"] params:dict success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            [HUDUtil showInfo:CFDLocalizedString(@" 操场成功")];
            [GJumpUtil popAnimated:YES];
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
        }
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
    }];
}

- (void)addressAction{
    WEAK_SELF;
    [QRCodeVC jumpToFetchAddress:^(NSString *address) {
        weakSelf.addressField.text = address;
    }];
}

//MARK: - Getter

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

- (UIView *)typeView{
    if (!_typeView) {
        _typeView = [[UIView alloc] init];
        _typeView.backgroundColor = [GColorUtil C6];
    }
    return _typeView;
}
- (UILabel *)typeTitle{
    if (!_typeTitle) {
        _typeTitle = [[UILabel alloc] init];
        _typeTitle.textColor = [GColorUtil C2];
        _typeTitle.font = [GUIUtil fitFont:16];
        _typeTitle.text = CFDLocalizedString(@"币种_edit");
    }
    return _typeTitle;
}
- (UILabel *)typeText{
    if (!_typeText) {
        _typeText = [[UILabel alloc] init];
        _typeText.textColor = [GColorUtil C3];
        _typeText.font = [GUIUtil fitFont:16];
    }
    return _typeText;
}
- (UILabel *)markTitle{
    if (!_markTitle) {
        _markTitle = [[UILabel alloc] init];
        _markTitle.textColor = [GColorUtil C3];
        _markTitle.font = [GUIUtil fitFont:14];
        _markTitle.text = CFDLocalizedString(@"标签");
    }
    return _markTitle;
}
- (UIView *)markView{
    if (!_markView) {
        _markView = [[UIView alloc] init];
        _markView.backgroundColor = [GColorUtil C6];
    }
    return _markView;
}
- (UITextField *)markField{
    if (!_markField) {
        _markField = [[UITextField alloc] init];
        _markField.textColor = [GColorUtil C2];
        _markField.font = [GUIUtil fitFont:14];
        _markField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:CFDLocalizedString(@"输入标签，不超过10个字符") attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
    }
    return _markField;
}
- (UILabel *)addressTitle{
    if (!_addressTitle) {
        _addressTitle = [[UILabel alloc] init];
        _addressTitle.textColor = [GColorUtil C3];
        _addressTitle.font = [GUIUtil fitFont:14];
        _addressTitle.text = CFDLocalizedString(@"提币地址");
    }
    return _addressTitle;
}
- (UIView *)addressView{
    if (!_addressView) {
        _addressView = [[UIView alloc] init];
        _addressView.backgroundColor = [GColorUtil C6];
    }
    return _addressView;
}
- (UITextField *)addressField{
    if (!_addressField) {
        _addressField = [[UITextField alloc] init];
        _addressField.textColor = [GColorUtil C2];
        _addressField.font = [GUIUtil fitFont:14];
        _addressField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:CFDLocalizedString(@"输入地址或点击右方图标扫码") attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
        _addressField.rightView = self.addressBtn;
        _addressField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _addressField;
}

- (UIButton *)addressBtn{
    if (!_addressBtn) {
        _addressBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 17, 17)];
        _addressBtn.titleLabel.font = [GUIUtil fitFont:12];
        [_addressBtn setTitleColor:[GColorUtil C13] forState:UIControlStateNormal];
        [_addressBtn setImage:[GColorUtil imageNamed:@"mine_icon_scan"] forState:UIControlStateNormal];
        [_addressBtn addTarget:self action:@selector(addressAction) forControlEvents:UIControlEventTouchUpInside];
        [_addressBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
    }
    return _addressBtn;
}

- (UILabel *)errorLabel{
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc] init];
        _errorLabel.textColor = [GColorUtil C14];
        _errorLabel.font = [GUIUtil fitFont:14];
        _errorLabel.hidden = YES;
        _errorLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _errorLabel;
}

- (UIButton *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [[UIButton alloc] init];
        _commitBtn.backgroundColor = [GColorUtil C13];
        [_commitBtn setTitle:CFDLocalizedString(@"保存") forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}


@end
