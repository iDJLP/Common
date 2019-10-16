//
//  AssetDetailCell.m
//  Bitmixs
//
//  Created by ngw15 on 2019/6/12.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "AssetDetailCell.h"

@interface AssetDetailCell ()

@property (nonatomic,strong)BaseLabel *titleLabel;
@property (nonatomic,strong)BaseLabel *amountLabel;
@property (nonatomic,strong)BaseLabel *valueLabel;
@property (nonatomic,strong)BaseView *lineView;
@end

@implementation AssetDetailCell

+ (CGFloat)heightOfCell{
    return [GUIUtil fit:60];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.hasPressEffect = NO;
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.amountLabel];
    [self.contentView addSubview:self.valueLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)autoLayout{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.centerY.mas_equalTo(0);
    }];
    [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.titleLabel.mas_centerY);
        make.right.mas_equalTo([GUIUtil fit:-15]);
    }];
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountLabel.mas_bottom).mas_offset([GUIUtil fit:1]);
        make.right.mas_equalTo([GUIUtil fit:-15]);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
}

- (void)configOfCell:(NSDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _titleLabel.text = [NDataUtil stringWith:dict[@"title"]];
    _amountLabel.text = [NDataUtil stringWith:dict[@"amount"]];
    _valueLabel.text = [NSString stringWithFormat:@"≈%@CNY",[NDataUtil stringWith:dict[@"amountCNY"]]];
}
//MARK:Getter

- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[BaseLabel alloc] init];
        _titleLabel.txColor = C2_ColorType;
        _titleLabel.font = [GUIUtil fitFont:14];
    }
    return _titleLabel;
}

- (BaseLabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel = [[BaseLabel alloc] init];
        _amountLabel.txColor = C2_ColorType;
        _amountLabel.font = [GUIUtil fitBoldFont:14];
    }
    return _amountLabel;
}

- (BaseLabel *)valueLabel{
    if (!_valueLabel) {
        _valueLabel = [[BaseLabel alloc] init];
        _valueLabel.txColor = C2_ColorType;
        _valueLabel.font = [GUIUtil fitFont:12];
    }
    return _valueLabel;
}

- (BaseView *)lineView{
    if (!_lineView) {
        _lineView = [[BaseView alloc] init];
        _lineView.backgroundColor = [GColorUtil C7];
    }
    return _lineView;
}

@end
