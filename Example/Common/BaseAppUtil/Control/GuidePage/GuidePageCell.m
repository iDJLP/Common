//
//  GuidePageCell.m
//  globalwin
//
//  Created by 张洪林 on 2018/7/25.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "GuidePageCell.h"
#import "GuidePageManager.h"

@interface GuidePageCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *startButton;
@end
@implementation GuidePageCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setSubView];
    }
    return self;
}
-(void)setSubView{
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.startButton];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    

}
- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
}
// 判断当前cell是否是最后一页
- (void)setIndexPath:(NSIndexPath *)indexPath count:(NSUInteger)count
{
    if (indexPath.row == count - 1) { // 最后一页,显示分享和开始按钮
        
//        self.startButton.hidden = NO;
        
    }else{ // 非最后一页，隐藏分享和开始按钮
        
//        self.startButton.hidden = YES;
    }
}

- (UIButton *)startButton
{
    if (!_startButton) {
        CGSize size = [GUIUtil sizeWith:CFDLocalizedString(@"跳过") fontSize:[GUIUtil fitFontSize:12]];
        _startButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (IS_IPHONE_X?40:20)+[GUIUtil fit:5], size.width+[GUIUtil fit:8], size.width+[GUIUtil fit:8])];
        _startButton.right = SCREEN_WIDTH-[GUIUtil fit:15];
        [_startButton setTitle:CFDLocalizedString(@"跳过") forState:(UIControlStateNormal)];
        [_startButton setTitleColor:[GColorUtil C6] forState:UIControlStateNormal];
        [_startButton setBackgroundColor:[GColorUtil colorWithHex:0x000000 alpha:0.3]];
        _startButton.titleLabel.font = [GUIUtil fitFont:12];
        [_startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        _startButton.layer.cornerRadius = (size.width+[GUIUtil fit:8])/2;
        _startButton.layer.masksToBounds = YES;
        [_startButton g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
    }
    return _startButton;
}
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
// 点击开始的时候调用
- (void)start{
    [GuidePageManager stopGuideAction];
}
@end
