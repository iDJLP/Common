//
//  AssetActionView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/6/11.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "AssetActionView.h"
#import "FundRecordVC.h"
#import "FundTransferVC.h"

@interface AssetActionView()

@property (nonatomic,strong)BaseImageView *depositImgView;
@property (nonatomic,strong)BaseImageView *drawlImgView;
@property (nonatomic,strong)BaseImageView *transferImgView;
@property (nonatomic,strong)BaseImageView *fundRecordImgView;
@property (nonatomic,strong)BaseLabel *depositLabel;
@property (nonatomic,strong)BaseLabel *drawlLabel;
@property (nonatomic,strong)BaseLabel *transferLabel;
@property (nonatomic,strong)BaseLabel *fundRecordLabel;

@end

@implementation AssetActionView

+ (CGFloat)heightOfView{
    
    return [GUIUtil fit:88];
}

- (instancetype)init{
    if (self = [super init]) {
        [self setupUI];
        [self autoLayout];
        WEAK_SELF;
        [self g_clickBlock:^(UITapGestureRecognizer *tap) {
            CGFloat offsetX = [tap locationInView:weakSelf].x;
            CGFloat offset1 = (SCREEN_WIDTH-[GUIUtil fit:30])/4+[GUIUtil fit:15];
            CGFloat offset2 = (SCREEN_WIDTH-[GUIUtil fit:30])*2/4+[GUIUtil fit:15];
            CGFloat offset3 = (SCREEN_WIDTH-[GUIUtil fit:30])*3/4+[GUIUtil fit:15];
            if (offsetX<offset1) {
                [CFDJumpUtil jumpToDeposit:weakSelf.type];
            }else if (offsetX<offset2){
                [CFDJumpUtil jumpToDrawl:weakSelf.type];
            }else if (offsetX<offset3){
                [FundTransferVC jumpTo:weakSelf.type];
            }else{
                [FundRecordVC jumpTo];
            }
        }];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.depositImgView];
    [self addSubview:self.depositLabel];
    [self addSubview:self.drawlImgView];
    [self addSubview:self.drawlLabel];
    [self addSubview:self.transferImgView];
    [self addSubview:self.transferLabel];
    [self addSubview:self.fundRecordImgView];
    [self addSubview:self.fundRecordLabel];
}

- (void)autoLayout{
    [_depositImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:35]);
        make.top.mas_equalTo([GUIUtil fit:10]);;
    }];
    [_depositLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.depositImgView.mas_bottom).mas_offset([GUIUtil fit:8]);
        make.centerX.equalTo(self.depositImgView);
    }];
    [_drawlImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:122]);
        make.top.equalTo(self.depositImgView);
    }];
    [_drawlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.depositLabel);
        make.centerX.equalTo(self.drawlImgView);
    }];
    [_transferImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:212]);
        make.top.equalTo(self.depositImgView);
    }];
    [_transferLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.depositLabel);
        make.centerX.equalTo(self.transferImgView);
    }];
    [_fundRecordImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:300]);
        make.top.equalTo(self.depositImgView);
    }];
    [_fundRecordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.depositLabel);
        make.centerX.equalTo(self.fundRecordImgView);
    }];
}

//MARK:Getter


-(BaseImageView *)depositImgView{
    if (!_depositImgView) {
        _depositImgView = [[BaseImageView alloc] init];
        _depositImgView.imageName = @"assets_homeicon1";
    }
    return _depositImgView;
}
-(BaseImageView *)drawlImgView{
    if (!_drawlImgView) {
        _drawlImgView = [[BaseImageView alloc] init];
        _drawlImgView.imageName = @"assets_homeicon2";
    }
    return _drawlImgView;
}
-(BaseImageView *)transferImgView{
    if (!_transferImgView) {
        _transferImgView = [[BaseImageView alloc] init];
        _transferImgView.imageName = @"assets_homeicon3";
    }
    return _transferImgView;
}
-(BaseImageView *)fundRecordImgView{
    if (!_fundRecordImgView) {
        _fundRecordImgView = [[BaseImageView alloc] init];
        _fundRecordImgView.imageName = @"assets_homeicon4";
    }
    return _fundRecordImgView;
}

-(BaseLabel *)depositLabel{
    if(!_depositLabel){
        _depositLabel = [[BaseLabel alloc] init];
        _depositLabel.font = [GUIUtil fitFont:12];
        _depositLabel.txColor = C2_ColorType;
        _depositLabel.textBlock = CFDLocalizedStringBlock(@"入金");
    }
    return _depositLabel;
}
-(BaseLabel *)drawlLabel{
    if(!_drawlLabel){
        _drawlLabel = [[BaseLabel alloc] init];
        _drawlLabel.font = [GUIUtil fitFont:12];
        _drawlLabel.txColor = C2_ColorType;
        _drawlLabel.textBlock = CFDLocalizedStringBlock(@"出金");
    }
    return _drawlLabel;
}
-(BaseLabel *)transferLabel{
    if(!_transferLabel){
        _transferLabel = [[BaseLabel alloc] init];
        _transferLabel.font = [GUIUtil fitFont:12];
        _transferLabel.txColor = C2_ColorType;
        _transferLabel.textBlock = CFDLocalizedStringBlock(@"币币兑换");
    }
    return _transferLabel;
}
-(BaseLabel *)fundRecordLabel{
    if(!_fundRecordLabel){
        _fundRecordLabel = [[BaseLabel alloc] init];
        _fundRecordLabel.font = [GUIUtil fitFont:12];
        _fundRecordLabel.txColor = C2_ColorType;
        _fundRecordLabel.textBlock = CFDLocalizedStringBlock(@"资金记录");
    }
    return _fundRecordLabel;
}

@end
