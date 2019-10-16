//
//  DCServicerAlert.m
//  LiveTrade
//
//  Created by ngw15 on 2018/11/8.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "DCServicerAlert.h"

@interface DCServicerAlertView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *codeImgView;
@property (nonatomic,strong) UILabel *remarkLabel;
@property (nonatomic,strong) UIButton *cancelBtn;

@property (nonatomic,strong) dispatch_block_t cancelHander;


@end

@implementation DCServicerAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [GColorUtil colorWithHex:0x000000 alpha:0.4];
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.codeImgView];
    [self.contentView addSubview:self.remarkLabel];
    [self addSubview:self.cancelBtn];
}

- (void)autoLayout{
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo([GUIUtil fit:-10]);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo([GUIUtil fit:280]);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:20]);
        make.centerX.mas_equalTo(0);
    }];
    [_codeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).mas_offset([GUIUtil fit:25]);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo([GUIUtil fitWidth:87 height:87]);
    }];
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        
        make.top.equalTo(self.codeImgView.mas_bottom).mas_offset([GUIUtil fit:25]);
        make.bottom.mas_offset([GUIUtil fit:-25]);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.contentView.mas_bottom).mas_offset([GUIUtil fit:15]);
    }];
}

//MARK: - Action

- (void)cancelAction{
    [self removeFromSuperview];
    if (self.cancelHander) {
        self.cancelHander();
    }
}
- (void)configView:(NSDictionary *)dict{
    NSString *wx = [NDataUtil stringWith:dict[@"weixin"]];
    NSString *coreurl = [NDataUtil stringWith:dict[@"gzhqcoreurl"]];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"1、微信扫描二维码进群\n2、微信添加：%@",wx]];
    attStr.lineSpacing = 5;
    _remarkLabel.attributedText = attStr;
    [GUIUtil imageViewWithUrl:_codeImgView url:coreurl placeholder:@"" completedBlock:^(UIImage *image, NSError *error, NSInteger cacheType, NSURL *imageURL) {
        
    }];
}

//MARK: - Getter

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [GColorUtil C6];
        _contentView.layer.cornerRadius = 14;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"添加客服微信号\n为您在线解答问题";
        _titleLabel.font =[GUIUtil fitFont:16];
        _titleLabel.textColor = [GColorUtil C2];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)codeImgView{
    if (!_codeImgView) {
        _codeImgView = [[UIImageView alloc] init];
    }
    return _codeImgView;
}

-(UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.font =[GUIUtil fitFont:16];
        _remarkLabel.textColor = [GColorUtil C3];
        _remarkLabel.numberOfLines = 0;
        _remarkLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _remarkLabel;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setBackgroundImage:[GColorUtil imageNamed:@"pop_icon_close"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [GUIUtil fitFont:16];
        [_cancelBtn setTitleColor:[GColorUtil C2] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

@end

@implementation DCServicerAlert


+ (void)showAlert:(NSDictionary *)dict
     cancelHander:(dispatch_block_t)cancelHander{
    UIWindow *window = [GJumpUtil window];
    DCServicerAlertView *view = [[DCServicerAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [view configView:dict];
    view.cancelHander = cancelHander;
    view.tag = 41812;
    [window addSubview:view];
    view.contentView.transform = CGAffineTransformIdentity;

}

+ (void)hide{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    DCServicerAlertView *view = [window viewWithTag:41812];
    [view cancelAction];
    [view removeFromSuperview];
}

@end


