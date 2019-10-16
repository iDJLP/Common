//
//  DCOtherChargedView.m
//  niuguwang
//
//  Created by ngw15 on 2018/12/13.
//  Copyright © 2018 taojinzhe. All rights reserved.
//

#import "ChainDepositView.h"
#import "ChainTradeView.h"
#import "ChainDetailRecordVC.h"
#import "FundRecordVC.h"
#import "CurrenttypeSelectedSheet.h"

#import <Photos/PHPhotoLibrary.h>

@interface ChainDepositView ()

@property (nonatomic,strong) UIView *varityView;
@property (nonatomic,strong) UILabel *varityTitle;
@property (nonatomic,strong) UILabel *varityText;
@property (nonatomic,strong) UIImageView *varityArrowImg;
@property (nonatomic,strong) UILabel *desTitle;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIImageView *bgCodeImg;
@property (nonatomic,strong) UIImageView *toImg;
@property (nonatomic,strong) UIImageView *centerCodeImg;
@property (nonatomic,strong) UIButton *saveImg;
@property (nonatomic,strong) UIView *topLine;
@property (nonatomic,strong) UILabel *urlTitle;
@property (nonatomic,strong) UIButton *saveUrl;

@property (nonatomic,strong) UIView *remarkView;
@property (nonatomic,strong) UILabel *remarkTitle;
@property (nonatomic,strong) UILabel *remarkText;

@property (nonatomic,strong) UILabel *hisLabel;
@property (nonatomic,strong) ChainTradeView *tradeView;
@property (nonatomic,strong) UIButton *moreBtn;
@property (nonatomic,strong) UIView *spaceView;

@property (nonatomic,strong)NSDictionary *config;

@end

@implementation ChainDepositView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [GColorUtil C6];
        [self setupUI];
        [self autoLayout];
        WEAK_SELF;
        [GUIUtil refreshWithHeader:self refresh:^{
            [weakSelf loadData];
            [weakSelf loadTradeOrder];
        }];
    }
    return self;
}


- (void)setupUI{
    [self addSubview:self.varityView];
    [self.varityView addSubview:self.varityTitle];
    [self.varityView addSubview:self.varityText];
    [self.varityView addSubview:self.varityArrowImg];
    [self addSubview:self.desTitle];
    [self addSubview:self.topView];
    [self.topView addSubview:self.bgCodeImg];
    [self.topView addSubview:self.toImg];
    [self.toImg addSubview:self.centerCodeImg];
    [self.topView addSubview:self.saveImg];
    [self.topView addSubview:self.topLine];
    [self.topView addSubview:self.urlTitle];
    [self.topView addSubview:self.saveUrl];
    
    [self addSubview:self.remarkView];
    [self.remarkView  addSubview:self.remarkTitle];
    [self.remarkView  addSubview:self.remarkText];
    
    [self  addSubview:self.hisLabel];
    [self  addSubview:self.moreBtn];
    [self  addSubview:self.tradeView];
    [self  addSubview:self.spaceView];
    //给这个UITextField的对象添加UIToolbar
    
}

- (void)autoLayout{
    [_varityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fit:60]);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [_varityTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fit:60]);
    }];
    [_varityText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.varityArrowImg.mas_left).mas_offset([GUIUtil fit:-15]);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fit:60]);
    }];
    [_varityArrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.centerY.mas_equalTo(self.varityText);
    }];
    [_desTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil  fit:15]);
        make.top.equalTo(self.varityTitle.mas_bottom);
    }];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.desTitle.mas_bottom).mas_offset([GUIUtil  fit:10]);
        make.left.mas_equalTo([GUIUtil  fit:15]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:30]);
    }];
    
    [_bgCodeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.toImg);
        make.size.mas_equalTo([GUIUtil fitWidth:95 height:95]);
    }];
    [_toImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.desTitle.mas_bottom).mas_offset([GUIUtil  fit:30]);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo([GUIUtil fitWidth:84 height:84]);
    }];
    [_centerCodeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.toImg);
        make.size.mas_equalTo([GUIUtil fitWidth:18 height:18]);
    }];
    [_saveImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.toImg.mas_bottom).mas_offset([GUIUtil  fit:10]);
    }];
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil  fit:33]);
        make.right.mas_equalTo([GUIUtil  fit:-33]);
        make.height.mas_equalTo([GUIUtil  fitLine]);
        make.top.equalTo(self.saveImg.mas_bottom).mas_offset([GUIUtil  fit:13]);
    }];
    [_urlTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil  fit:15]);
        make.right.mas_equalTo([GUIUtil  fit:-15]);
        make.top.equalTo(self.topLine).mas_offset([GUIUtil  fit:15]);
    }];
    [_saveUrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.urlTitle.mas_bottom).mas_offset([GUIUtil  fit:10]);
        make.bottom.mas_equalTo([GUIUtil  fit:-15]);
    }];
    [_remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).mas_offset([GUIUtil  fit:5]);
        make.left.mas_equalTo([GUIUtil  fit:0]);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [_remarkTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil  fit:15]);
        make.top.mas_equalTo([GUIUtil  fit:10]);
    }];
    [_remarkText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil  fit:15]);
        make.right.equalTo(self.mas_left).mas_equalTo(SCREEN_WIDTH+[GUIUtil fit:-15]);
        make.top.equalTo(self.remarkTitle.mas_bottom).mas_offset([GUIUtil  fit:10]);
        make.bottom.mas_equalTo([GUIUtil  fit:-15]);
    }];
    [_hisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil  fit:15]);
        make.top.equalTo(self.remarkText.mas_bottom).mas_offset([GUIUtil  fit:25]);
    }];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_left).mas_equalTo(SCREEN_WIDTH+[GUIUtil fit:-15]);
        make.centerY.equalTo(self.hisLabel);
    }];
    [_tradeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.width.mas_equalTo([GUIUtil fit:-30]+SCREEN_WIDTH);
        
        make.top.equalTo(self.hisLabel.mas_bottom).mas_offset([GUIUtil  fit:15]);
        make.height.mas_equalTo([ChainTradeView heightOfView]);
    }];
    [_spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.equalTo(self.tradeView.mas_bottom);
        make.bottom.mas_equalTo([GUIUtil fit:-15]-IPHONE_X_BOTTOM_HEIGHT).priority(500);
    }];
}

//MARK: - Action

- (void)saveUrlAction{
    NSString *text = [NDataUtil stringWith:_urlTitle.text];
    if (_isLoaded&&text.length>0) {
        UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = text;
        [HUDUtil showInfo:CFDLocalizedString(@"复制成功")];
    }else{
        [HUDUtil showInfo:CFDLocalizedString(@"请刷新重试")];
    }
}

- (void)saveImgAction{
    
    //----第一次不会进来
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied){
        // 无权限 做一个友好的提示
        [DCAlert showAlert:CFDLocalizedString(@"温馨提示") detail:CFDLocalizedString(@"请您设置允许该应用访问您的相册") sureTitle:CFDLocalizedString(@"去设置") sureHander:^{
            [GJumpUtil jumpToAppSetting];
        } cancelTitle:CFDLocalizedString(@"取消")
              cancelHander:^{
                  
              }];
        return;
    }
    
    WEAK_SELF;
    //----每次都会走进来
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            if (weakSelf.isLoaded) {
                dispatch_async(dispatch_get_main_queue(), ^{
            
                    UIImage *img = [weakSelf convertViewToImage:weakSelf.toImg];
                    UIImageWriteToSavedPhotosAlbum(img, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:),nil);
                });
            }
        }else{
            NSLog(@"Denied or Restricted");
            //----为什么没有在这个里面进行权限判断，因为会项目会蹦。。。
        }
    }];
}

-(UIImage*)convertViewToImage:(UIView*)v{
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = CFDLocalizedString(@"保存图片失败") ;
    }else{
        msg = CFDLocalizedString(@"保存图片成功") ;
    }
    [HUDUtil showInfo:msg];
}

#pragma mark -- Data

- (void)loadData{
    WEAK_SELF;
    [DCService chainusdtPay:_payId currencyType:_type success:^(id data) {
        [weakSelf.mj_header endRefreshing];
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            weakSelf.isLoaded = YES;
            weakSelf.config = data;
            [weakSelf configVC];
            [weakSelf currentyChanged];
            [StateUtil hide:weakSelf];
            [HUDUtil hide];
        }else {
            if(weakSelf.isLoaded==NO){
                NoDataStateView *stateView = (NoDataStateView *)[StateUtil show:weakSelf.tradeView type:StateTypeNodata];
                stateView.title.text = CFDLocalizedString(@"暂无交易订单");
            }else{
                [StateUtil hide:weakSelf];
            }
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
        }
    } failure:^(NSError *error) {
        [weakSelf.mj_header endRefreshing];
        [HUDUtil showInfo:[FTConfig webTips]];
        if(weakSelf.isLoaded==NO){
            ReloadStateView *reloadView = (ReloadStateView *)[StateUtil show:weakSelf type:StateTypeReload];
            [reloadView setOnReload:^{
                [StateUtil hide:weakSelf];
                [weakSelf loadData];
            }];
        }else{
            [StateUtil hide:weakSelf];
        }
    }];
}

- (void)loadTradeOrder{
    WEAK_SELF;
    [DCService getpayOrder:NO success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            if ([NDataUtil stringWith:data[@"txtid"]].length<=0) {
                [StateUtil show:weakSelf.tradeView type:StateTypeNodata];
            }else{
                [weakSelf.tradeView configView:[NDataUtil dictWith:data]];
                [StateUtil hide:weakSelf.tradeView];
            }
            return ;
        }
        ReloadStateView *state = (ReloadStateView *)[StateUtil show:weakSelf.tradeView type:StateTypeReload];
        state.onReload = ^{
            [weakSelf loadTradeOrder];
        };
        [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
        ReloadStateView *state = (ReloadStateView *)[StateUtil show:weakSelf.tradeView type:StateTypeReload];
        state.onReload = ^{
            [weakSelf loadTradeOrder];
        };
    }];
}


- (void)configVC{
    
    NSDictionary *dict = [NDataUtil dictWith:_config[@"data"]];
    _urlTitle.text = [NDataUtil stringWith:dict[@"address"]];
    UIImage *image = [GUIUtil createQRimageString:_urlTitle.text sizeWidth:[GUIUtil  fit:168] fillColor:[GColorUtil colorWithHex:0xffffff]];
    image = [image imageByResizeToSize:[GUIUtil fitWidth:SCREEN_WIDTH height:SCREEN_WIDTH]];
    image = [image imageByTintColor:[GColorUtil colorWithHex:0x000000]];
    _toImg.image = image;
    
    NSString *text = [NDataUtil stringWith:dict[@"intro"]];
    if ([text containsString:@"<br/>"]) {
        text = [text stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\r\n"];
    }
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:text];
    att.lineSpacing = 5;
    _remarkText.attributedText = att;
}

- (void)moreAction{
    [FundRecordVC jumpTo:1];
}

- (void)currentyChanged{
    _varityText.text = _type;
    _desTitle.text = [NSString stringWithFormat:CFDLocalizedString(@"您的个人多重签名%@入金地址"),_type];
}

//MARK: - Getter

- (UIView *)varityView{
    if (!_varityView) {
        _varityView = [[UIView alloc] init];
        _varityView.backgroundColor = [GColorUtil C6];
        WEAK_SELF;
        [_varityView g_clickBlock:^(UITapGestureRecognizer *tap) {
            [CurrenttypeSelectedSheet showAlert:CFDLocalizedString(@"请选择币种") selected:weakSelf.type sureHander:^(NSDictionary * _Nonnull dic) {
                weakSelf.type = [NDataUtil stringWith:dic[@"currency"]];
                [HUDUtil showProgress:@""];
                [weakSelf currentyChanged];
                [weakSelf loadData];
            }];
        }];
    }
    return _varityView;
}

- (UILabel *)varityTitle{
    if(!_varityTitle){
        _varityTitle = [[UILabel alloc] init];
        _varityTitle.textColor = [GColorUtil C2];
        _varityTitle.font = [GUIUtil fitBoldFont:16];
        _varityTitle.text = CFDLocalizedString(@"币种");
    }
    return _varityTitle;
}

- (UILabel *)varityText{
    if(!_varityText){
        _varityText = [[UILabel alloc] init];
        _varityText.textColor = [GColorUtil C2];
        _varityText.font = [GUIUtil  fitBoldFont:16];
    }
    return _varityText;
}

- (UIImageView *)varityArrowImg{
    if (!_varityArrowImg) {
        _varityArrowImg=[[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"market_icon_under_blue_down"]];
    }
    return _varityArrowImg;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [GColorUtil C16];
    }
    return _topView;
}
- (UILabel *)desTitle{
    if(!_desTitle){
        _desTitle = [[UILabel alloc] init];
        _desTitle.textColor =[GColorUtil C2];
        _desTitle.font = [GUIUtil  fitFont:12];
        _desTitle.text = CFDLocalizedString(@"您的个人多重签名入金地址");
        _desTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _desTitle;
}

- (UIImageView *)bgCodeImg{
    if (!_bgCodeImg) {
        _bgCodeImg = [[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"mine_pic_qrcode"]];
        WEAK_SELF;
        [_bgCodeImg g_clickBlock:^(UITapGestureRecognizer *tap) {
            [weakSelf saveImgAction];
        }];
    }
    return _bgCodeImg;
}

- (UIImageView *)toImg{
    if (!_toImg) {
        _toImg = [[UIImageView alloc] init];
        _toImg.backgroundColor = [GColorUtil C5];
    }
    return _toImg;
}

- (UIImageView *)centerCodeImg{
    if (!_centerCodeImg) {
        _centerCodeImg = [[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"mine_logo_qrcode"]];
    }
    return _centerCodeImg;
}

- (UIButton *)saveImg{
    if (!_saveImg) {
        _saveImg = [[UIButton alloc] init];
        [_saveImg setTitle:CFDLocalizedString(@"保存图片到手机") forState:UIControlStateNormal];
        [_saveImg setTitleColor:[GColorUtil C2] forState:UIControlStateNormal];
        _saveImg.titleLabel.font = [GUIUtil  fitFont:10];
        [_saveImg addTarget:self action:@selector(saveImgAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveImg;
}

- (UIView *)topLine{
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = [GColorUtil C7];
    }
    return _topLine;
}

- (UILabel *)urlTitle{
    if(!_urlTitle){
        _urlTitle = [[UILabel alloc] init];
        _urlTitle.textColor = [GColorUtil C2];
        _urlTitle.font = [GUIUtil fitFont:14];
        _urlTitle.textAlignment = NSTextAlignmentCenter;
        _urlTitle.adjustsFontSizeToFitWidth = YES;
        _urlTitle.minimumScaleFactor = 0.5;
        WEAK_SELF;
        [_urlTitle g_clickBlock:^(UITapGestureRecognizer *tap) {
            [weakSelf saveUrlAction];
        }];
    }
    return _urlTitle;
}

- (UIButton *)saveUrl{
    if (!_saveUrl) {
        _saveUrl = [[UIButton alloc] init];
        [_saveUrl setTitle:CFDLocalizedString(@"复制地址") forState:UIControlStateNormal];
        [_saveUrl setTitleColor:[GColorUtil C13] forState:UIControlStateNormal];
        _saveUrl.titleLabel.font = [GUIUtil  fitFont:14];
        [_saveUrl addTarget:self action:@selector(saveUrlAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveUrl;
}

-(UIView *)remarkView{
    if (!_remarkView) {
        _remarkView = [[UIView alloc] init];
        _remarkView.backgroundColor = [GColorUtil C6];
    }
    return _remarkView;
}

- (UILabel *)remarkTitle{
    if(!_remarkTitle){
        _remarkTitle = [[UILabel alloc] init];
        _remarkTitle.textColor = [GColorUtil C2];
        _remarkTitle.font = [GUIUtil  fitBoldFont:14];
        _remarkTitle.text = CFDLocalizedString(@"重要提示");
        _remarkTitle.numberOfLines = 0;
    }
    return _remarkTitle;
}

- (UILabel *)remarkText{
    if(!_remarkText){
        _remarkText = [[UILabel alloc] init];
        _remarkText.textColor = [GColorUtil C3];
        _remarkText.font = [GUIUtil  fitFont:14];
        _remarkText.numberOfLines = 0;
    }
    return _remarkText;
}

- (UILabel *)hisLabel{
    if(!_hisLabel){
        _hisLabel = [[UILabel alloc] init];
        _hisLabel.textColor = [GColorUtil C2];
        _hisLabel.font = [GUIUtil  fitFont:14];
        _hisLabel.text = CFDLocalizedString(@"链上充值记录");
    }
    return _hisLabel;
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        _moreBtn.backgroundColor = [UIColor clearColor];
        _moreBtn.titleLabel.font = [GUIUtil  fitFont:14];
        [_moreBtn setTitle:CFDLocalizedString(@"查看更多记录") forState:UIControlStateNormal];
        [_moreBtn setTitleColor:[GColorUtil C13] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
        [_moreBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
    }
    return _moreBtn;
}

- (ChainTradeView *)tradeView{
    if (!_tradeView) {
        _tradeView = [[ChainTradeView alloc] init];
        WEAK_SELF;
        [_tradeView g_clickBlock:^(UITapGestureRecognizer *tap) {
            NSString *logid = [NDataUtil stringWith:weakSelf.config[@"logid"]];
            NSString *txid = [NDataUtil stringWith:weakSelf.config[@"txtid"]];
            NSString *currenttype = [NDataUtil stringWith:weakSelf.config[@"showCoinCode"]];
            if (txid.length>0) {
                [ChainDetailRecordVC jumpTo:logid txtId:txid date:@"" currenttype:currenttype isDeposit:YES];
            }
        }];
    }
    return _tradeView;
}

- (UIView *)spaceView{
    if (!_spaceView) {
        _spaceView = [[UIView alloc] init];
        _spaceView.backgroundColor = [UIColor clearColor];
    }
    return _spaceView;
}


@end
