//
//  QRCodeVC.m
//  qzh_ftox
//
//  Created by ngw15 on 2018/4/18.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "QRCodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/PHPhotoLibrary.h>


#define LEFT mainRectWidth/6
#define TOP mainRectHeight/2 - 2*mainRectWidth/3+64
#define WIDTH 2*mainRectWidth/3
#define RIGHT LEFT+WIDTH
#define BOTTOM TOP+WIDTH

@interface QRCodeView:UIView{
    UIImageView *lineView;
    CGFloat lineY;
}

@end

@implementation QRCodeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO; // 设置为透明的
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGRect mainRect = [UIScreen mainScreen].bounds;
    [self addClearRect:mainRect];
    [self addFourBorder:mainRect];
    [self addMovingLine:mainRect];
}

- (void)addClearRect:(CGRect)mainRect {
    CGFloat mainRectWidth = mainRect.size.width;
    CGFloat mainRectHeight = mainRect.size.height;
    [[UIColor colorWithWhite:0 alpha:0.4] setFill];
    UIRectFill(mainRect);
    CGRect clearRect = CGRectMake(LEFT, TOP, WIDTH, WIDTH);
    CGRect clearIntersection = CGRectIntersection(clearRect, mainRect);
    [[UIColor clearColor] setFill];
    UIRectFill(clearIntersection);
}

- (void)addFourBorder:(CGRect)mainRect {
    CGFloat mainRectWidth = mainRect.size.width;
    CGFloat mainRectHeight = mainRect.size.height;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 5);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    CGPoint upLeftPoints[] = {CGPointMake(LEFT, TOP), CGPointMake(LEFT + 20, TOP), CGPointMake(LEFT, TOP), CGPointMake(LEFT, TOP + 20)};
    CGPoint upRightPoints[] = {CGPointMake(RIGHT - 20, TOP), CGPointMake(RIGHT, TOP), CGPointMake(RIGHT, TOP), CGPointMake(RIGHT, TOP + 20)};
    CGPoint belowLeftPoints[] = {CGPointMake(LEFT, BOTTOM), CGPointMake(LEFT, BOTTOM - 20), CGPointMake(LEFT, BOTTOM), CGPointMake(LEFT +20, BOTTOM)};
    CGPoint belowRightPoints[] = {CGPointMake(RIGHT, BOTTOM), CGPointMake(RIGHT - 20, BOTTOM), CGPointMake(RIGHT, BOTTOM), CGPointMake(RIGHT, BOTTOM - 20)};
    CGContextStrokeLineSegments(ctx, upLeftPoints, 4);
    CGContextStrokeLineSegments(ctx, upRightPoints, 4);
    CGContextStrokeLineSegments(ctx, belowLeftPoints, 4);
    CGContextStrokeLineSegments(ctx, belowRightPoints, 4);
}

- (void)addMovingLine:(CGRect)mainRect {
    if (!lineView) {
        [self initLineView:mainRect];
    }
    WEAK_SELF;
    [NTimeUtil startTimer:@"QRCodeView" interval:0.02 repeats:YES action:^{
        [weakSelf moveLine];
    }];
}

- (void)initLineView:(CGRect)mainRect {
    CGFloat mainRectWidth = mainRect.size.width;
    CGFloat mainRectHeight = mainRect.size.height;
    lineView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT, TOP, WIDTH, 2)];
//    lineView.image = [GColorUtil imageNamed:@"line"];
    lineView.backgroundColor = [UIColor whiteColor];
    [self addSubview:lineView];
    lineY = lineView.frame.origin.y;
}

- (void)moveLine {
    [UIView animateWithDuration:0.02 animations:^{
        CGRect rect = lineView.frame;
        rect.origin.y = lineY;
        lineView.frame = rect;
    } completion:^(BOOL finished) {
        CGRect mainRect = [UIScreen mainScreen].bounds;
        CGFloat mainRectHeight = mainRect.size.height;
        CGFloat mainRectWidth = mainRect.size.width;
        CGFloat maxLineY = BOTTOM;
        if (lineY >= maxLineY) {
            lineY = TOP;
        } else {
            lineY ++;
        }
    }];
}

@end

@interface QRCodeVC ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
//输入设备 也就是摄像头
@property(nonatomic, strong)AVCaptureDeviceInput *input;
//输出的元数据
@property(nonatomic, strong)AVCaptureMetadataOutput *output;
//展示图层
@property(nonatomic, strong)AVCaptureVideoPreviewLayer *preLayer;
//会话(输入设备、输出的元数据和展示图层都需要与会话相关联)
@property(nonatomic, strong)AVCaptureSession *session;

@property (nonatomic,strong) UIView *navView;
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *navLine;
@property (nonatomic,strong) QRCodeView *bgView;

@property (nonatomic,copy) void(^ hander)(NSString *address);

@end

@implementation QRCodeVC

+ (void)jumpToFetchAddress:(void(^)(NSString *address))hander{
    QRCodeVC *target = [[QRCodeVC alloc] init];
    target.hander = hander;
    [GJumpUtil pushVC:target animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self qrcodeStart];
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.navView];
    
    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(TOP_BAR_HEIGHT);
        make.left.right.mas_equalTo(0);
    }];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.session startRunning];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)qrcodeStart{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
        // 无权限 做一个友好的提示
        [DCAlert showAlert:CFDLocalizedString(@"温馨提示") detail:CFDLocalizedString(@"请您设置允许该应用访问您的相机") sureTitle:CFDLocalizedString(@"去设置") sureHander:^{
            [GJumpUtil jumpToAppSetting];
        } cancelTitle:CFDLocalizedString(@"取消")
              cancelHander:^{
                  
              }];
        return ;
    }
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device==nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:CFDLocalizedString(@"提示") message:CFDLocalizedString(@"设备没有摄像头") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:CFDLocalizedString(@"确认_yes") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    AVCaptureDeviceDiscoverySession *discoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    //获取设备 也就是摄像头 这里只获取后置摄像头
    NSArray *devices = discoverySession.devices;
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:[devices firstObject] error:nil];
    self.output = [[AVCaptureMetadataOutput alloc]init];
    //设置扫描区域
 
    CGRect mainRect = [UIScreen mainScreen].bounds;
    CGFloat mainRectWidth = mainRect.size.width;
    CGFloat mainRectHeight = mainRect.size.height;
    CGRect rect = CGRectMake(LEFT, TOP, WIDTH, WIDTH);
    CGRect interestRect = CGRectMake(rect.origin.y/mainRect.size.height, rect.origin.x/mainRect.size.width, rect.size.height/mainRect.size.height, rect.size.width/mainRect.size.width);//参照坐标是横屏左上角
    [_output setRectOfInterest:interestRect];
    self.session = [[AVCaptureSession alloc]init];
    //将输入设备与会话关联
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    //将输出设备与会话关联
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    //设置输出设备的代理
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //输出元数据类型为二维码
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    //将展示图层与会话关联
    self.preLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    
    self.preLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.preLayer];
    [self.session setSessionPreset:AVCaptureSessionPreset1920x1080];
}

//解析完毕会调用这个方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    AVMetadataMachineReadableCodeObject *objc = [metadataObjects firstObject];
    //输出扫描结果
    if (objc.stringValue.length>0) {
        [self.session stopRunning];
        if (_hander) {
            _hander(objc.stringValue);
        }
        [self backAction];
    }
}

- (void)getImageFromIpc
{
    // 1.判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    // 2. 创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    /**
     typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
     UIImagePickerControllerSourceTypePhotoLibrary, // 相册
     UIImagePickerControllerSourceTypeCamera, // 用相机拍摄获取
     UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相簿
     }
     */
    // 3. 设置打开照片相册类型(显示所有相簿)
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    // 照相机
    // ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    // 4.设置代理
    ipc.delegate = self;
    // 5.modal出这个控制器
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark -- <UIImagePickerControllerDelegate>--
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 设置图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSString *qrCode = [GUIUtil readQRCodeFromImage:image];
    if (qrCode.length>0) {
        if (_hander) {
            _hander(qrCode);
        }
        // 销毁控制器
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self backAction];
    }else{
        [self.session startRunning];
    }
    
}

//MARK: - Getter

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction{
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
            [weakSelf getImageFromIpc];
        }else{
            NSLog(@"Denied or Restricted");
            //----为什么没有在这个里面进行权限判断，因为会项目会蹦。。。
        }
    }];
    
}


//MARK: - Getter

- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc] init];
        _navView.backgroundColor = [GColorUtil C6];
        [_navView addSubview:self.backBtn];
        [_navView addSubview:self.rightBtn];
        [_navView addSubview:self.titleLabel];
        [_navView addSubview:self.navLine];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:15]);
            make.centerY.mas_equalTo(STATUS_BAR_HEIGHT/2);
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backBtn);
            make.centerX.mas_equalTo(0);
        }];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo([GUIUtil fit:-15]);
            make.centerY.equalTo(self.backBtn);
        }];
        [_navLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo([GUIUtil fitLine]);
        }];
    }
    return _navView;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:[GColorUtil imageNamed:@"nav_icon_back"] forState:UIControlStateNormal];
        [_backBtn setImage:[GColorUtil imageNamed:@"nav_icon_back"] forState:UIControlStateHighlighted];
        [_backBtn addTarget:self
                     action:@selector(backAction)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setTitleColor:[GColorUtil C13] forState:UIControlStateNormal];
        [_rightBtn setTitle:CFDLocalizedString(@"照片") forState:UIControlStateNormal];
        [_rightBtn addTarget:self
                     action:@selector(rightAction)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UIView *)navLine{
    if (!_navLine) {
        _navLine = [[UIView alloc] init];
        _navLine.backgroundColor = [GColorUtil C7];
    }
    return _navLine;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [GColorUtil C13];
        _titleLabel.font = [GUIUtil fitBoldFont:16];
        _titleLabel.text = CFDLocalizedString(@"二维码");
    }
    return _titleLabel;
}

- (QRCodeView *)bgView{
    if (!_bgView) {
        _bgView = [[QRCodeView alloc] init];
    }
    return _bgView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
