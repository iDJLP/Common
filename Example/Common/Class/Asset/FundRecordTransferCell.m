//
//  FundRecordTransferCell.m
//  Bitmixs
//
//  Created by ngw15 on 2019/6/12.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "FundRecordTransferCell.h"

@interface FundRecordTransferCell ()
@property (nonatomic,strong)BaseView *bgView;
@property (nonatomic,strong)BaseImageView *transfer1ImgView;
@property (nonatomic,strong)BaseImageView *transferImgView;
@property (nonatomic,strong)BaseImageView *transfer2ImgView;
@property (nonatomic,strong)BaseLabel *transfer1Label;
@property (nonatomic,strong)BaseLabel *transfer2Label;
@property (nonatomic,strong)BaseLabel *dateLabel;
@end

@implementation FundRecordTransferCell

+ (CGFloat)heightOfCell{
    
    return [GUIUtil fit:15]+[GUIUtil fit:25]+[GUIUtil fitFont:16].lineHeight+[GUIUtil fit:15]+[GUIUtil fitFont:14].lineHeight+[GUIUtil fit:15];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.transfer1Label];
    [self.bgView addSubview:self.transfer2Label];
    [self.bgView addSubview:self.dateLabel];
    [self.bgView addSubview:self.transferImgView];
    [self.bgView addSubview:self.transfer1ImgView];
    [self.bgView addSubview:self.transfer2ImgView];
}

- (void)autoLayout{
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.top.mas_equalTo([GUIUtil fit:10]);
    }];
    [_transfer1ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:10]);
        make.centerY.equalTo(self.transfer1Label);
        make.size.mas_equalTo([GUIUtil fitWidth:15 height:15]);
    }];
    [_transfer1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:25]);
        make.left.equalTo(self.transfer1ImgView.mas_right).mas_offset([GUIUtil fit:10]);
        make.width.mas_equalTo([GUIUtil fit:130]);
    }];
    [_transferImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.equalTo(self.transfer1Label);
        
    }];
    [_transfer2ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:205]);
        make.centerY.equalTo(self.transfer1Label);
        make.size.mas_equalTo([GUIUtil fitWidth:15 height:15]);
    }];
    [_transfer2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:25]);
        make.left.equalTo(self.transfer2ImgView.mas_right).mas_offset([GUIUtil fit:10]);
        make.width.mas_equalTo([GUIUtil fit:130]);
    }];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:10]);
        make.top.equalTo(self.transfer1Label.mas_bottom).mas_offset([GUIUtil fit:20]);
        make.bottom.mas_equalTo([GUIUtil fit:-15]);
    }];
}

- (void)configOfCell:(NSDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    [GUIUtil imageViewWithUrl:_transfer1ImgView url:dict[@"fromIcon"]];
    [GUIUtil imageViewWithUrl:_transfer2ImgView url:dict[@"toIcon"]];
    _transfer1Label.text = [NDataUtil stringWith:dict[@"fromAmount"]];
    _transfer2Label.text = [NDataUtil stringWith:dict[@"toAmount"]];
    _dateLabel.text = [NDataUtil stringWith:dict[@"time"]];
}
//MARK:Getter

- (BaseView *)bgView{
    if (!_bgView) {
        _bgView = [[BaseView alloc] init];
        _bgView.bgColor = C16_ColorType;
    }
    return _bgView;
}

-(BaseImageView *)transfer1ImgView{
    if(!_transfer1ImgView){
        _transfer1ImgView = [[BaseImageView alloc] init];
    }
    return _transfer1ImgView;
}
-(BaseImageView *)transferImgView{
    if(!_transferImgView){
        _transferImgView = [[BaseImageView alloc] init];
        _transferImgView.image = [GColorUtil imageNamed:@"assets_exchange_icon_arrow"];
    }
    return _transferImgView;
}
-(BaseImageView *)transfer2ImgView{
    if(!_transfer2ImgView){
        _transfer2ImgView = [[BaseImageView alloc] init];
    }
    return _transfer2ImgView;
}

-(BaseLabel *)transfer1Label{
    if(!_transfer1Label){
        _transfer1Label = [[BaseLabel alloc] init];
        _transfer1Label.txColor = C2_ColorType;
        _transfer1Label.font = [GUIUtil fitFont:16];
        _transfer1Label.adjustsFontSizeToFitWidth = YES;
        _transfer1Label.minimumScaleFactor = 0.5;
    }
    return _transfer1Label;
}
-(BaseLabel *)transfer2Label{
    if(!_transfer2Label){
        _transfer2Label = [[BaseLabel alloc] init];
        _transfer2Label.txColor = C2_ColorType;
        _transfer2Label.font = [GUIUtil fitFont:16];
        _transfer2Label.adjustsFontSizeToFitWidth = YES;
        _transfer2Label.minimumScaleFactor = 0.5;
    }
    return _transfer2Label;
}
-(BaseLabel *)dateLabel{
    if(!_dateLabel){
        _dateLabel = [[BaseLabel alloc] init];
        _dateLabel.txColor = C2_ColorType;
        _dateLabel.font = [GUIUtil fitFont:14];
    }
    return _dateLabel;
}

@end
