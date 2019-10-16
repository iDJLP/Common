//
//  FundRecordChainCell.m
//  Bitmixs
//
//  Created by ngw15 on 2019/4/26.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "FundRecordChainCell.h"
#import "ChainTradeView.h"

@interface FundRecordChainCell ()
@property (nonatomic,strong)ChainTradeView *chainView;

@end

@implementation FundRecordChainCell

+ (CGFloat)heightOfCell{
    
    return [ChainTradeView heightOfView]+[GUIUtil fit:15];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.hasPressEffect = YES;
        self.bgColorType = C8_ColorType;
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.chainView];
}

- (void)autoLayout{
    [_chainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo([GUIUtil fit:15]);
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.height.mas_equalTo([ChainTradeView heightOfView]);
    }];
}

- (void)configCell:(NSDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    if ([dict containsObjectForKey:@"priceArrow"]) {
        BOOL isBuy = [NDataUtil boolWithDic:dict key:@"priceArrow" isEqual:@"BUY"];
        if (isBuy==NO) {        
            _chainView.amountTitle.text = CFDLocalizedString(@"数量");
        }
    }
    [_chainView configView:dict];
}

//MARK:Getter

- (ChainTradeView *)chainView{
    if (!_chainView) {
        _chainView = [[ChainTradeView alloc] init];
        _chainView.layer.cornerRadius = 4;
        _chainView.layer.masksToBounds = YES;
    }
    return _chainView;
}

@end
