//
//  QZHMessageCell.m
//  niuguwang
//
//  Created by ngw on 16/3/15.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import "QZHMessageCell.h"

@interface QZHMessageCell()

@property(nonatomic, strong) UIImageView *bgView;
@property(nonatomic,strong) UILabel *labContent;
@property(nonatomic,strong) UIImageView *headView;

@end


@implementation QZHMessageCell

+ (CGFloat)heightWithModel:(NSDictionary *)dic
{
    CGSize size = [GUIUtil sizeWith:dic[@"noticecontent"] width:SCREEN_WIDTH -[GUIUtil fit:105] fontSize:16];
    return  size.height + [GUIUtil fit:24];
    
}

#pragma mark - 快速创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"QZHMessageCell";
    QZHMessageCell *cell = [[QZHMessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [GColorUtil C6];
        self.hasPressEffect = NO;
        // 添加所有子控件
        [self addSomeViews];
        
    }
    return self;
}




#pragma mark - public

- (void)addSomeViews {
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.labContent];
    [self addSubview:self.headView];
}

- (void)config:(NSDictionary *)dict type:(QZHMessageType)type
{
    self.labContent.text = [NDataUtil stringWith:dict[@"noticecontent"] valid:@""];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:60]);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - [GUIUtil fit:75], self.height));
    }];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.mas_equalTo(1);
        make.size.mas_equalTo([GUIUtil fitWidth:40 height:40]);
    }];
    
    CGSize size = [GUIUtil sizeWith:self.labContent.text width:SCREEN_WIDTH -[GUIUtil fit:105] fontSize:16];
    [self.labContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:17]);
        make.top.mas_equalTo([GUIUtil fit:12]);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH -[GUIUtil fit:105] , size.height));
    }];
}


#pragma mark getter and setter
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc]init];
        CGFloat top = 25; // 顶端盖高度
        CGFloat bottom = 20 ; // 底端盖高度
        CGFloat left = 20; // 左端盖宽度
        CGFloat right = 20; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        // 伸缩后重新赋值
        UIImage * bubble = [[GColorUtil imageNamed:@"mine_notice_backdrop"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        _bgView.image = bubble;
    }
    return _bgView;
}

-(UILabel *)labContent
{
    if (!_labContent) {
        _labContent=[UILabel new];
        _labContent.numberOfLines=0;
        _labContent.lineBreakMode=NSLineBreakByWordWrapping;
        _labContent.preferredMaxLayoutWidth = SCREEN_WIDTH - 51;
        _labContent.textColor = [GColorUtil C2];
        _labContent.font=[UIFont systemFontOfSize:16];
    }
    return _labContent;
}

- (UIImageView *)headView
{
    if (!_headView) {
        _headView = [UIImageView new];
        _headView.image = [GColorUtil imageNamed:@"mine_icon_robot"];
        
    }
    return _headView;
}

@end

