//
//  RuleCell.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/26.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "RuleCell.h"

@interface RuleCell ()

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *valueLabel;

@end

@implementation RuleCell

+ (CGFloat)heightOfCell:(NSDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return 0;
    }
    NSString *name = [NDataUtil stringWith:dict[@"name"]];
    NSString *value = [NDataUtil stringWith:dict[@"value"]];
    CGFloat nameHeight = [GUIUtil sizeWith:name fontSize:14 width:[GUIUtil fit:100]].height;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NDataUtil stringWith:dict[@"value"]]];
    att.lineSpacing = 5;
    att.font = [GUIUtil fitFont:12];
    CGFloat valueHeight = [GUIUtil sizeWith:att width:[GUIUtil fit:220]].height;
    
    CGFloat height = ceil(MAX(nameHeight, valueHeight)) + [GUIUtil fit:18];
    return height;
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
    [self.contentView addSubview:self.valueLabel];
}

- (void)autoLayout{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo([GUIUtil fit:100]);
    }];
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:140]);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo([GUIUtil fit:220]);
    }];
}

- (void)configOfCell:(NSDictionary *)dict isSingle:(BOOL)isSingle{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    self.bgColorType = isSingle?C8_ColorType:C6_ColorType;
    _titleLabel.text = [NDataUtil stringWith:dict[@"name"]];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NDataUtil stringWith:dict[@"value"]]];
    att.lineSpacing = 5;
    _valueLabel.attributedText = att;
}
//MARK:Getter

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [GColorUtil C3];
        _titleLabel.font = [GUIUtil fitFont:12];
        _titleLabel.numberOfLines=0;
    }
    return _titleLabel;
}

- (UILabel *)valueLabel{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.textColor = [GColorUtil C2];
        _valueLabel.font = [GUIUtil fitFont:12];
        _valueLabel.numberOfLines=0;
    }
    return _valueLabel;
}

@end
