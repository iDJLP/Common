//
//  TradeCell.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/26.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "TradeCell.h"
#import "NSDate+Additions.h"

@interface TradeCell ()

@property (nonatomic,strong) UILabel *label1;
@property (nonatomic,strong) UILabel *label2;
@property (nonatomic,strong) UILabel *label3;
@property (nonatomic,strong) UILabel *label4;
@property (nonatomic,strong) UIImageView *imgView;
@end

@implementation TradeCell

+ (CGFloat)heightOfCell{
    return [GUIUtil fit:35];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.label1];
    [self.contentView addSubview:self.label2];
    [self.contentView addSubview:self.label3];
    [self.contentView addSubview:self.label4];
    [self.contentView addSubview:self.imgView];
}

- (void)autoLayout{
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.centerY.mas_equalTo(0);
    }];
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:120]);
        make.centerY.mas_equalTo(0);
    }];
    [self.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:222]);
        make.centerY.mas_equalTo(0);
    }];
    [self.label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.centerY.mas_equalTo(0);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:151]);
        make.centerY.mas_equalTo(0);
    }];
    
}

- (void)configOfCell:(NSDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *date = [NDataUtil stringWith:dict[@"tradeTime"]];
    _label1.text = [NSDate tradeDateByTimestemp:date.longLongValue/1000];
    BOOL isBuy = [NDataUtil boolWithDic:dict key:@"buyerTheMarketMaker" isEqual:@"0"];
    if (isBuy) {
        _label2.text = CFDLocalizedString(@"买入");
        _label2.textColor = [GColorUtil C11];
        _imgView.image = [CFDApp sharedInstance].isRed? [GColorUtil imageNamed:@"market_icon_applies_red"]:[GColorUtil imageNamed:@"market_icon_applies_engreen"];
    }else{
        _label2.text = CFDLocalizedString(@"卖出");
        _label2.textColor = [GColorUtil C12];
        _imgView.image = [CFDApp sharedInstance].isRed? [GColorUtil imageNamed:@"market_icon_applies_green"]:[GColorUtil imageNamed:@"market_icon_applies_enred"];
    }
    
    _label3.text = [NDataUtil stringWith:dict[@"price"]];
    _label4.text = [NDataUtil stringWith:dict[@"quantity"]];
}
//MARK:Getter

- (UILabel *)label1{
    if(!_label1){
        _label1 = [[UILabel alloc] init];
        _label1.textColor = [GColorUtil C2];
        _label1.font = [GUIUtil fitFont:12];
    }
    return _label1;
}
- (UILabel *)label2{
    if(!_label2){
        _label2 = [[UILabel alloc] init];
        _label2.textColor = [GColorUtil C2];
        _label2.font = [GUIUtil fitFont:12];
    }
    return _label2;
}
- (UILabel *)label3{
    if(!_label3){
        _label3 = [[UILabel alloc] init];
        _label3.textColor = [GColorUtil C2];
        _label3.font = [GUIUtil fitFont:12];
    }
    return _label3;
}
- (UILabel *)label4{
    if(!_label4){
        _label4 = [[UILabel alloc] init];
        _label4.textColor = [GColorUtil C2];
        _label4.font = [GUIUtil fitFont:12];
    }
    return _label4;
}
- (UIImageView *)imgView{
    if(!_imgView){
        _imgView = [[UIImageView alloc] init];

    }
    return _imgView;
}

@end
