//
//  SecurityStepDetailView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/5/21.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "SecurityStepDetailView.h"
#import "SecurityVerifyView.h"
#import "PhoneVerifyAlert.h"
#import <Photos/PHPhotoLibrary.h>

@interface SecurityStepDetailView ()

@property (nonatomic,strong)UIView *step1View;
@property (nonatomic,strong)UIView *step2View;
@property (nonatomic,strong)UIView *step3View;

@property (nonatomic,strong)UILabel *loadTitleLabel;
@property (nonatomic,strong)UIButton *loadBtn;
@property (nonatomic,strong)UIButton *loadNextBtn;

@property (nonatomic,strong)UIView *bindSeparatView;
@property (nonatomic,strong)UILabel *bindTitleLabel;
@property (nonatomic,strong)UIView *bindContentView;
@property (nonatomic,strong)UIImageView *bindCodeBgImgView;
@property (nonatomic,strong)UIImageView *bindCodeImgView;
@property (nonatomic,strong)UIImageView *bindCodeLogoImgView;
@property (nonatomic,strong)UILabel *bindSaveLabel;
@property (nonatomic,strong)UIImageView *bindLine;
@property (nonatomic,strong)UILabel *bindKeyLabel;
@property (nonatomic,strong)UILabel *bindCopyLabel;
@property (nonatomic,strong)UILabel *bindRemarkLabel;
@property (nonatomic,strong)UIButton *bindNextBtn;

@property (nonatomic,strong)SecurityVerifyView *verifyView;
@property (nonatomic,strong)UIButton *verifyNextBtn;

@property (nonatomic,copy)NSString *key1;
@property (nonatomic,copy)NSString *key2;
@end


@implementation SecurityStepDetailView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self autoLayout];
        [self updateStep:1];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.step1View];
    [self addSubview:self.step2View];
    [self addSubview:self.step3View];
}

- (void)autoLayout{
    [_step1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [_step2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [_step3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)loadData{
    WEAK_SELF;
    [DCService getGoogleAuthInfo:^(id data) {
        if ([NDataUtil stringWith:data[@"status"] valid:@"1"]) {
            [weakSelf configOfView:data[@"data"]];
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"message"] valid:[FTConfig webTips]]];
        }
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
    }];
}

- (void)configOfView:(NSDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *qrcode = [NDataUtil stringWith:dict[@"qrCodeSetup"]];
   
    UIImage *image = [GUIUtil createQRimageString:qrcode sizeWidth:[GUIUtil  fit:168] fillColor:[GColorUtil colorWithHex:0xffffff]];
    image = [image imageByResizeToSize:[GUIUtil fitWidth:SCREEN_WIDTH height:SCREEN_WIDTH]];
    image = [image imageByTintColor:[GColorUtil colorWithHex:0x000000]];
    _bindCodeImgView.image = image;
    
    
    _bindKeyLabel.text = [NSString stringWithFormat:@"%@%@",CFDLocalizedString(@"密钥："),[NDataUtil stringWith:dict[@"gEntryKey"]]];
    _key1 =[NDataUtil stringWith:dict[@"gSecretkey"]];
    _key2 =[NDataUtil stringWith:dict[@"gEntryKey"]];
}

- (void)updateStep:(NSInteger)index{
    if (index==1) {
        _step1View.hidden = NO;
        _step2View.hidden = _step3View.hidden = YES;
    }else if (index==2){
        _step2View.hidden = NO;
        _step1View.hidden = _step3View.hidden = YES;
        [self loadData];
    }else{
        [_verifyView becomeFirstRespond];
        _step3View.hidden = NO;
        _step1View.hidden = _step2View.hidden = YES;
    }
}

//MARK: - Action

- (void)loadAction{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[UserModel sharedInstance].gooleAuthLoadUrl]];
    
}

- (void)loadNextAction{
    [self updateStep:2];
    _stepChangedHander(2);
}

- (void)saveQRCodeAction{
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
            if (weakSelf.key1.length>0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *img = [weakSelf.bindCodeImgView snapshotImageAfterScreenUpdates:NO];
                    UIImageWriteToSavedPhotosAlbum(img, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:),nil);
                });
            }
        }else{
            NSLog(@"Denied or Restricted");
            //----为什么没有在这个里面进行权限判断，因为会项目会蹦。。。
        }
    }];
}

- (void)copyKeyAction{
    NSString *text = _key2;
    if (text.length>0) {
        UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = text;
        [HUDUtil showInfo:CFDLocalizedString(@"复制成功")];
    }
}

- (void)bindNextAction{
    [self updateStep:3];
    _stepChangedHander(3);
}

- (void)verifyNextAction{
    WEAK_SELF;
    [DCService verifyGoogleAuth:_verifyView.pwdText key:_key1 success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            [PhoneVerifyAlert showAlert:^{
                [UserModel sharedInstance].openGoogleAuth=YES;
                [weakSelf.viewController.navigationController popViewControllerAnimated:YES];
            } key1:weakSelf.key1 key2:weakSelf.key2 googleCode:weakSelf.verifyView.pwdText];
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"message"] valid:[FTConfig webTips]]];
        }
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
    }];
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = CFDLocalizedString(@"保存图片失败");
    }else{
        msg = CFDLocalizedString(@"保存图片成功") ;
    }
    [HUDUtil showInfo:msg];
}

//MARK:Getter

- (UIView *)step1View{
    if (!_step1View) {
        _step1View = [[UIView alloc] init];
        [_step1View addSubview:self.loadTitleLabel];
        [_step1View addSubview:self.loadBtn];
        [_step1View addSubview:self.loadNextBtn];
        [_loadTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo([GUIUtil fit:90]);
            make.centerX.mas_equalTo(0);
        }];
        [_loadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.equalTo(self.loadTitleLabel.mas_bottom).mas_offset([GUIUtil fit:30]);
            make.size.mas_equalTo([GUIUtil fitWidth:130 height:40]);
        }];
        [_loadNextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-IPHONE_X_BOTTOM_HEIGHT);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(49);
        }];
    }
    return _step1View;
}

- (UIView *)step2View{
    if (!_step2View) {
        _step2View = [[UIView alloc] init];
        [_step2View addSubview:self.bindSeparatView];
        [_step2View addSubview:self.bindTitleLabel];
        [_step2View addSubview:self.bindContentView];
        [_step2View addSubview:self.bindRemarkLabel];
        [_step2View addSubview:self.bindNextBtn];
        [_bindContentView addSubview:self.bindCodeBgImgView];
        [_bindCodeBgImgView addSubview:self.bindCodeImgView];
        [_bindCodeImgView addSubview:self.bindCodeLogoImgView];
        [_bindContentView addSubview:self.bindSaveLabel];
        [_bindContentView addSubview:self.bindLine];
        [_bindContentView addSubview:self.bindKeyLabel];
        [_bindContentView addSubview:self.bindCopyLabel];
        [_bindSeparatView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo([GUIUtil fit:7]);
        }];
        [_bindTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bindSeparatView.mas_bottom).mas_offset([GUIUtil fit:20]);
            make.left.mas_equalTo([GUIUtil fit:15]);
            make.right.mas_equalTo([GUIUtil fit:-15]);

        }];
        [_bindContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:15]);
            make.right.mas_equalTo([GUIUtil fit:-15]);
            make.top.equalTo(self.bindTitleLabel.mas_bottom).mas_offset([GUIUtil fit:12]);
        }];
        [_bindCodeBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo([GUIUtil fit:20]);
            make.size.mas_equalTo([GUIUtil fitWidth:95 height:95]);
        }];
        
        [_bindCodeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.bindCodeBgImgView);
            make.size.mas_equalTo([GUIUtil fitWidth:84 height:84]);
        }];
        [_bindCodeLogoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.bindCodeImgView);
            make.size.mas_equalTo([GUIUtil fitWidth:18 height:18]);
        }];
        [_bindSaveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.equalTo(self.bindCodeBgImgView.mas_bottom).mas_offset([GUIUtil fit:10]);
        }];
        [_bindLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0); make.top.equalTo(self.bindSaveLabel.mas_bottom).mas_offset([GUIUtil fit:12]);
        }];
        [_bindKeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bindLine.mas_bottom).mas_offset([GUIUtil fit:0]);
            make.left.mas_equalTo([GUIUtil fit:15]);
            make.right.mas_equalTo([GUIUtil fit:-15]);
            make.height.mas_equalTo([GUIUtil fit:48]);
            make.bottom.mas_equalTo(0);
        }];
        [_bindCopyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo([GUIUtil fit:-15]);
            make.centerY.equalTo(self.bindKeyLabel);
        }];
        [_bindRemarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bindContentView.mas_bottom).mas_offset([GUIUtil fit:15]);
            make.left.mas_equalTo([GUIUtil fit:15]);
            make.right.mas_equalTo([GUIUtil fit:-15]);
        }];
        [_bindNextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-IPHONE_X_BOTTOM_HEIGHT);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(49);
        }];
    }
    return _step2View;
}

- (UIView *)step3View{
    if (!_step3View) {
        _step3View = [[UIView alloc] init];
        [_step3View addSubview:self.verifyView];
        [_step3View addSubview:self.verifyNextBtn];
        [_verifyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo([GUIUtil fit:55]);
            make.bottom.mas_equalTo(0);
        }];
        [_verifyNextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-IPHONE_X_BOTTOM_HEIGHT);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(49);
        }];
    }
    return _step3View;
}

- (UILabel *)loadTitleLabel{
    if (!_loadTitleLabel) {
        _loadTitleLabel = [[UILabel alloc] init];
        _loadTitleLabel.textColor = [GColorUtil C13];
        _loadTitleLabel.numberOfLines=0;
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:CFDLocalizedString(@"下载并安装谷歌验证器\n")];
        attStr.font = [GUIUtil fitFont:16];
        NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:@"(Google Authenticator)"];
        attStr1.font = [GUIUtil fitFont:14];
        [attStr appendAttributedString:attStr1];
        attStr.lineSpacing = 5;
        attStr.alignment = NSTextAlignmentCenter;
        _loadTitleLabel.attributedText = attStr;
    }
    return _loadTitleLabel;
}

- (UIButton *)loadBtn{
    if (!_loadBtn) {
        _loadBtn = [[UIButton alloc] init];
        [_loadBtn setTitle:CFDLocalizedString(@"立即下载") forState:UIControlStateNormal];
        [_loadBtn setTitleColor:[GColorUtil C13] forState:UIControlStateNormal];
        [_loadBtn addTarget:self action:@selector(loadAction) forControlEvents:UIControlEventTouchUpInside];
        _loadBtn.layer.borderColor = [GColorUtil C13].CGColor;
        _loadBtn.layer.borderWidth = 1;
        _loadBtn.layer.cornerRadius = [GUIUtil fit:4];
        _loadBtn.layer.masksToBounds = YES;
    }
    return _loadBtn;
}

- (UIButton *)loadNextBtn{
    if (!_loadNextBtn) {
        _loadNextBtn = [[UIButton alloc] init];
        [_loadNextBtn setTitle:CFDLocalizedString(@"下一步") forState:UIControlStateNormal];
        _loadNextBtn.backgroundColor = [GColorUtil C13];
        [_loadNextBtn addTarget:self action:@selector(loadNextAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loadNextBtn;
}

- (UIView *)bindSeparatView{
    if (!_bindSeparatView) {
        _bindSeparatView = [[UIView alloc] init];
        _bindSeparatView.backgroundColor = [GColorUtil C8];
    }
    return _bindSeparatView;
}

- (UILabel *)bindTitleLabel{
    if (!_bindTitleLabel) {
        _bindTitleLabel = [[UILabel alloc] init];
        _bindTitleLabel.textColor = [GColorUtil C2];
        _bindTitleLabel.font = [GUIUtil fitFont:12];
        _bindTitleLabel.text = CFDLocalizedString(@"使用谷歌验证器APP扫描该二维码或输入密钥");
        _bindTitleLabel.numberOfLines=0;
    }
    return _bindTitleLabel;
}

- (UIView *)bindContentView{
    if (!_bindContentView) {
        _bindContentView = [[UIView alloc] init];
        _bindContentView.backgroundColor = [GColorUtil C16];
    }
    return _bindContentView;
}

- (UIImageView *)bindCodeBgImgView{
    if (!_bindCodeBgImgView) {
        _bindCodeBgImgView = [[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"mine_pic_qrcode"]];
        WEAK_SELF;
        [_bindCodeBgImgView g_clickBlock:^(UITapGestureRecognizer *tap) {
            [weakSelf saveQRCodeAction];
        }];
    }
    return _bindCodeBgImgView;
}

- (UIImageView *)bindCodeImgView{
    if (!_bindCodeImgView) {
        _bindCodeImgView = [[UIImageView alloc] init];
        _bindCodeImgView.backgroundColor = [GColorUtil C5];
    }
    return _bindCodeImgView;
}

- (UIImageView *)bindCodeLogoImgView{
    if (!_bindCodeLogoImgView) {
        _bindCodeLogoImgView = [[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"mine_logo_qrcode"]];
    }
    return _bindCodeLogoImgView;
}

- (UILabel *)bindSaveLabel{
    if (!_bindSaveLabel) {
        _bindSaveLabel = [[UILabel alloc] init];
        _bindSaveLabel.textColor = [GColorUtil C3];
        _bindSaveLabel.font = [GUIUtil fitFont:10];
        _bindSaveLabel.text = CFDLocalizedString(@"保存图片到手机");
    }
    return _bindSaveLabel;
}

- (UIImageView *)bindLine{
    if (!_bindLine) {
        _bindLine = [[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"mine_line_long"]];
    }
    return _bindLine;
}

- (UILabel *)bindKeyLabel{
    if (!_bindKeyLabel) {
        _bindKeyLabel = [[UILabel alloc] init];
        _bindKeyLabel.textColor = [GColorUtil C2];
        _bindKeyLabel.font = [GUIUtil fitFont:14];
        _bindKeyLabel.text = [NSString stringWithFormat:@"%@--",CFDLocalizedString(@"密钥：")];
        WEAK_SELF;
        [_bindKeyLabel g_clickBlock:^(UITapGestureRecognizer *tap) {
            [weakSelf copyKeyAction];
        }];
    }
    return _bindKeyLabel;
}

- (UILabel *)bindCopyLabel{
    if (!_bindCopyLabel) {
        _bindCopyLabel = [[UILabel alloc] init];
        _bindCopyLabel.textColor = [GColorUtil C13];
        _bindCopyLabel.font = [GUIUtil fitFont:14];
        _bindCopyLabel.text = CFDLocalizedString(@"复制");
    }
    return _bindCopyLabel;
}

- (UILabel *)bindRemarkLabel{
    if (!_bindRemarkLabel) {
        _bindRemarkLabel = [[UILabel alloc] init];
        _bindRemarkLabel.textColor = [GColorUtil C3];
        _bindRemarkLabel.font = [GUIUtil fitFont:12];
        _bindRemarkLabel.text = CFDLocalizedString(@"请将16位密钥记录在纸上，并保存在安全的地方。如遇手机丢失， 你可以通过该密钥恢复你的谷歌验证");
        _bindRemarkLabel.numberOfLines=0;
    }
    return _bindRemarkLabel;
}

- (UIButton *)bindNextBtn{
    if (!_bindNextBtn) {
        _bindNextBtn = [[UIButton alloc] init];
        [_bindNextBtn setTitle:CFDLocalizedString(@"下一步") forState:UIControlStateNormal];
        _bindNextBtn.backgroundColor = [GColorUtil C13];
        [_bindNextBtn addTarget:self action:@selector(bindNextAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bindNextBtn;
}

- (SecurityVerifyView *)verifyView{
    if (!_verifyView) {
        _verifyView = [[SecurityVerifyView alloc] init];
        WEAK_SELF;
        _verifyView.pwdChangedHander = ^{
            if (weakSelf.verifyView.pwdText.length==6) {
                weakSelf.verifyNextBtn.enabled = YES;
            }else{
                weakSelf.verifyNextBtn.enabled = NO;
            }
        };
    }
    return _verifyView;
}

- (UIButton *)verifyNextBtn{
    if (!_verifyNextBtn) {
        _verifyNextBtn = [[UIButton alloc] init];
        [_verifyNextBtn setTitle:CFDLocalizedString(@"开启") forState:UIControlStateNormal];
        _verifyNextBtn.backgroundColor = [GColorUtil C13];
        [_verifyNextBtn addTarget:self action:@selector(verifyNextAction) forControlEvents:UIControlEventTouchUpInside];
        _verifyNextBtn.enabled = NO;
    }
    return _verifyNextBtn;
}

@end
