//
//  FundFlowCell.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/20.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "FundFlowCell.h"

@interface FundFlowCell ()
@property (nonatomic,strong)UILabel *leftTextLabel;
@property (nonatomic,strong)UILabel *leftDetailLabel;
@property (nonatomic,strong)UILabel *rightTextLabel;
@property (nonatomic,strong)UILabel *rightDetailLabel;

@end
@implementation FundFlowCell

+ (CGFloat)heightOfCell:(NSDictionary *)dict{
    NSString *op = [NDataUtil stringWith:dict[@"op"] valid:@""];
    if ([[FTConfig sharedInstance].lang isEqualToString:@"cn"]&&[op containsString:@" "]) {
        op = [op stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
    }
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:op];
    attStr.lineSpacing = [GUIUtil fit:5];
    attStr.font = [GUIUtil fitFont:14];
    CGFloat height = [GUIUtil sizeWith:attStr width:[GUIUtil fit:200]].height;
    if (height>[GUIUtil fitFont:14].lineHeight+[GUIUtil fit:10]) {
        return [GUIUtil fit:85];
    }else{
        return [GUIUtil fit:70];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.hasPressEffect=NO;
        [self setupUI];
        [self autoLayout];
    }
    return self;
}


- (void)setupUI
{
    [self.contentView addSubview:self.leftTextLabel];
    [self.contentView addSubview:self.leftDetailLabel];
    [self.contentView addSubview:self.rightTextLabel];
    [self.contentView addSubview:self.rightDetailLabel];
}

- (void)autoLayout
{
    [self.leftTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.mas_equalTo([GUIUtil fit:15]);
        make.width.mas_equalTo([GUIUtil fit:200]);
    }];
    
    [self.leftDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.leftTextLabel.mas_bottom).mas_offset([GUIUtil fit:6]);
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.width.mas_equalTo([GUIUtil fit:215]);
    }];
    
    [self.rightTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.centerY.equalTo(self.leftTextLabel);
        make.width.mas_equalTo([GUIUtil fit:210]);
    }];
    
    [self.rightDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.leftDetailLabel);
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.width.mas_equalTo([GUIUtil fit:210]);
    }];
}

- (void)configCell:(NSDictionary *)dict
{
    NSString *op = [NDataUtil stringWith:dict[@"op"] valid:@""];
    if ([[FTConfig sharedInstance].lang isEqualToString:@"cn"]&&[op containsString:@" "]) {
        op = [op stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
    }
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:op];
    attStr.font = [GUIUtil fitFont:14];
    attStr.lineSpacing = [GUIUtil fit:5];
    self.leftTextLabel.attributedText = attStr;
    self.leftDetailLabel.text   = [NDataUtil stringWith:dict[@"optime"] valid:@""];
    NSString *fundAmount = [NDataUtil stringWith:dict[@"amount"] valid:@""];
    NSMutableAttributedString *fundStr = [[NSMutableAttributedString alloc] initWithString:fundAmount];
    fundStr.color = [fundAmount floatValue] > 0? [GColorUtil C13]:[GColorUtil C2];
    fundStr.lineSpacing = [GUIUtil fit:5];
    fundStr.alignment = NSTextAlignmentRight;
    self.rightTextLabel.attributedText    = fundStr;
    self.rightDetailLabel.text  = [NDataUtil stringWith:dict[@"canusedamount"] valid:@""];
}
#pragma mark ------ init

- (UILabel *)leftTextLabel
{
    if(!_leftTextLabel)
    {
        _leftTextLabel = [UILabel new];
        _leftTextLabel.font = [GUIUtil fitFont:14];
        _leftTextLabel.textColor =[GColorUtil C2];
        _leftTextLabel.numberOfLines = 0;
    }
    return _leftTextLabel;
}
- (UILabel *)leftDetailLabel
{
    if(!_leftDetailLabel)
    {
        _leftDetailLabel = [UILabel new];
        _leftDetailLabel.font = [GUIUtil fitFont:12];
        _leftDetailLabel.textColor = [GColorUtil C3];
    }
    return _leftDetailLabel;
}


- (UILabel *)rightTextLabel
{
    if(!_rightTextLabel)
    {
        _rightTextLabel = [UILabel new];
        _rightTextLabel.font = [GUIUtil fitFont:14];
        _rightTextLabel.adjustsFontSizeToFitWidth = YES;
        _rightTextLabel.minimumScaleFactor = 0.5;
        _rightTextLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightTextLabel;
}

- (UILabel *)rightDetailLabel
{
    if(!_rightDetailLabel)
    {
        _rightDetailLabel = [UILabel new];
        _rightDetailLabel.font = [GUIUtil fitFont:12];
        _rightDetailLabel.textColor = [GColorUtil C3];
        _rightDetailLabel.textAlignment = NSTextAlignmentRight;
        _rightDetailLabel.adjustsFontSizeToFitWidth = YES;
        _rightDetailLabel.minimumScaleFactor = 0.5;
    }
    return _rightDetailLabel;
}

@end

