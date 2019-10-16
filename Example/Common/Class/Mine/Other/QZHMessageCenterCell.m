//
//  QZHMessageCenterCell.m
//  qzh_ftox
//
//  Created by jly on 2017/11/17.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "QZHMessageCenterCell.h"
#import "MarkView.h"

@interface QZHMessageCenterCell ()
@property (nonatomic,strong)UILabel     *title;
@property (nonatomic,strong)MarkView *redDot;
@property (nonatomic,strong)UIImageView *arrowImg;
@property (nonatomic,strong)UIView      *line;

@end

@implementation QZHMessageCenterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.hasPressEffect = YES;
        [self addSubView];
        [self layout];
        
    }
    return self;
}

- (void)addSubView
{
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.redDot];
    [self.contentView addSubview:self.arrowImg];
    [self.contentView addSubview:self.line];
}
- (void)layout
{

    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:20]);
        make.centerY.mas_equalTo([GUIUtil fit:0]);
    }];
    
    [self.redDot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImg.mas_left).mas_offset([GUIUtil fit:-15]);
        make.centerY.equalTo(self.title);
    }];
    
    [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.title);
        make.right.mas_equalTo([GUIUtil fit:-20]);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:20]);
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(.5);
    }];
}

- (void)updateData:(id)data
{
    self.title.text = [NDataUtil stringWith:data[@"title"] valid:@""];
}

- (void)showRedDot:(NSString *)count
{
    if ([count integerValue]>99) {
        count=@"99+";
    }
    self.redDot.text = count;
    self.redDot.hidden = [count integerValue]<=0;
}
#pragma mark----setter and getter
- (UIImageView *)arrowImg
{
    if(!_arrowImg)
    {
        _arrowImg = [[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"public_icon_more"]];
    }
    return _arrowImg;
}
- (UILabel *)title
{
    if(!_title)
    {
        _title = [UILabel new];
        _title.textColor = [GColorUtil C2];
        _title.font      = [GUIUtil fitFont:14];
    }
    return _title;
}


- (MarkView *)redDot
{
    if(!_redDot)
    {
        _redDot = [[MarkView alloc]init];
        _redDot.backgroundColor = [GColorUtil C14];
        _redDot.layer.cornerRadius = [GUIUtil fitFont:12].lineHeight/2;
        _redDot.font = [GUIUtil fitFont:12];
        _redDot.textColor = [GColorUtil C5];
        _redDot.hPadding = [GUIUtil fit:3];
        _redDot.vPadding = [GUIUtil fit:1];
        _redDot.clipsToBounds = YES;
        _redDot.hidden = YES;
    }
    return _redDot;
}

- (UIView *)line
{
    if(!_line)
    {
        _line = [UIView new];
        _line.backgroundColor = [GColorUtil C7];
    }
    return _line;
}
@end
