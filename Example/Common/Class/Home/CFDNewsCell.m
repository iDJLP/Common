//
//  QZHNewsCell.m
//  niuguwang
//
//  Created by jly on 2017/6/27.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "CFDNewsCell.h"
#import "BaseLabel.h"
#import "BaseView.h"

@interface CFDNewsCell ()
@property (nonatomic,strong)BaseLabel *titleLabel;
@property (nonatomic,strong)BaseLabel *detailLabel;
@property (nonatomic,strong)BaseLabel *remarkLabel;
@property (nonatomic,strong)UIImageView*imgView;
@property (nonatomic,strong)BaseView*lineView;

@end
@implementation CFDNewsCell

+ (CGFloat)heightOfCell{
    return [GUIUtil fit:115];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.hasPressEffect = YES;
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.remarkLabel];
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.lineView];
}

- (void)autoLayout
{
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.width.mas_equalTo([GUIUtil fit:110]);
        make.height.mas_equalTo([GUIUtil fit:85]);
        make.top.mas_equalTo([GUIUtil fit:15]);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imgView.mas_left).mas_offset([GUIUtil fit:-15]);
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.equalTo(self.imgView).mas_offset([GUIUtil fit:5]);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).mas_offset([GUIUtil fit:5]);
        make.left.right.equalTo(self.titleLabel);
    }];
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.imgView.mas_bottom).mas_offset([GUIUtil fit:-5]);
        make.left.right.equalTo(self.titleLabel);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
}

- (void)updateCell:(NSDictionary *)data
{
    if(![data isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    NSString *key = [NSString stringWithFormat:@"articleid%@",[NDataUtil stringWith:data[@"articleid"] valid:@""]];
    BOOL hasRead = [NLocalUtil boolForKey:key];;
    if(hasRead)
    {
        self.titleLabel.txColor =
        self.detailLabel.txColor = C3_ColorType;
    }
    else
    {
        self.titleLabel.txColor =
        self.detailLabel.txColor = C2_ColorType;
    }
    self.titleLabel.text = [NDataUtil stringWith:data[@"title"] valid:@""];
    [GUIUtil adjustLineSpace:self.titleLabel lineSpace:[GUIUtil fit:5]];
    NSString *source = [NDataUtil stringWith:data[@"source"] valid:@""];
    NSString *time = [NDataUtil stringWith:data[@"publishtime"] valid:@""];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:source];
    if (source.length>0) {
        [attStr appendString:@"  "];
    }
    [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:time]];
    self.remarkLabel.attributedText = attStr;
    NSString *thumbnails = [NDataUtil stringWith:data[@"thumbnails"] valid:@""];
    if(thumbnails.length)
    {
        WEAK_SELF;
        NSString *tolerant = [NSString stringWithFormat:@"news_%@_gray",[FTConfig sharedInstance].iconnameprefix];
        [GUIUtil imageViewWithUrl:self.imgView url:thumbnails placeholder:tolerant completedBlock:^(UIImage *image, NSError *error, NSInteger cacheType, NSURL *imageURL) {
            if(error)
            {
                weakSelf.imgView.image = [GColorUtil imageNamed:[NSString stringWithFormat:@"news_%@_light",[FTConfig sharedInstance].iconnameprefix]];
            }
        }];
    }else{
        self.imgView.image = [GColorUtil imageNamed:[NSString stringWithFormat:@"news_%@_light",[FTConfig sharedInstance].iconnameprefix]];
    }
}

#pragma mark setter and getter
- (BaseLabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [BaseLabel new];
        _titleLabel.txColor = C2_ColorType;
        _titleLabel.font  = [GUIUtil fitBoldFont:18];
        _titleLabel.numberOfLines=2;
    }
    return _titleLabel;
}

- (BaseLabel *)detailLabel
{
    if(!_detailLabel)
    {
        _detailLabel = [BaseLabel new];
        _detailLabel.txColor = C2_ColorType;
        _detailLabel.font  = [GUIUtil fitBoldFont:14];
        _detailLabel.numberOfLines=2;
    }
    return _detailLabel;
}

- (BaseLabel *)remarkLabel
{
    if(!_remarkLabel)
    {
        _remarkLabel = [BaseLabel new];
        _remarkLabel.txColor = C3_ColorType;
        _remarkLabel.font  = [GUIUtil fitBoldFont:12];
        _remarkLabel.numberOfLines=1;
    }
    return _remarkLabel;
}

- (UIImageView *)imgView
{
    if(!_imgView)
    {
        _imgView = [UIImageView new];
        _imgView.layer.cornerRadius = [GUIUtil fit:3];
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}

- (BaseView *)lineView{
    if (!_lineView) {
        _lineView = [[BaseView alloc] init];
        _lineView.bgColor = C7_ColorType;
    }
    return _lineView;
}

@end
