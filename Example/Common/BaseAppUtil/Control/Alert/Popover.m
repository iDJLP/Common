//
//  Popover.m
//  Bitmixs
//
//  Created by ngw15 on 2019/9/10.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "Popover.h"

@interface PopoverRow : UIControl

@property (nonatomic,strong)UIImageView *iconImg;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIView *line;
@property (nonatomic,strong)NSDictionary *config;
@end

@implementation PopoverRow

+ (CGFloat)heightOfRow{
    return [GUIUtil fit:45];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self autoLayout];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.iconImg];
    [self addSubview:self.titleLabel];
    [self addSubview:self.line];
}

- (void)autoLayout{
    [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:17]);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo([GUIUtil fitWidth:17 height:17]);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImg.mas_right).mas_offset([GUIUtil fit:13]);
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.centerY.mas_equalTo(0);
    }];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([GUIUtil fitLine]);
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.mas_bottom);
    }];
}

- (void)configRow:(NSDictionary *)dict{
    _config = dict;
    _titleLabel.text = [NDataUtil stringWith:dict[@"title"]];
    _iconImg.image = [UIImage imageNamed:dict[@"icon"]];
}

//MARK: - Getter

- (UIImageView *)iconImg{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc] init];
    }
    return _iconImg;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font =[GUIUtil fitFont:16];
        _titleLabel.textColor = [GColorUtil colorWithWhiteColorType:C5_ColorType];
    }
    return _titleLabel;
}
- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [GColorUtil C5];
    }
    return _line;
}

@end

@interface PopoverView : UIControl

@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)UIImageView *arrowImgView;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong) NSMutableArray <PopoverRow *>*rowList;

@property (nonatomic,strong) void (^sureHander)(NSDictionary *dict);
@property (nonatomic,strong) UIColor *tinColor;
@property (nonatomic,strong) NSArray *list;
@end

@implementation PopoverView

- (instancetype)initWithList:(NSArray *)list{
    if (self = [super init]) {
//        self.backgroundColor = [GColorUtil colorWithHex:0x000000 alpha:0.4];
        _tinColor = [GColorUtil C13];
        self.backgroundColor = [UIColor clearColor];
        _list = list;
        [self setupUI];
        [self autoLayout];
        [self addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.arrowImgView];
    [self.contentView addSubview:self.bottomView];
    _rowList = [NSMutableArray array];
    UIView *refer = nil;
    for (NSDictionary *dict in _list) {
        PopoverRow *row = self.row;
        [self.bottomView addSubview:row];
        [self.rowList addObject:row];
        [row configRow:dict];
        [row mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo([GUIUtil fit:0]);
            make.height.mas_equalTo([PopoverRow heightOfRow]);
            if (refer==nil) {
                make.top.mas_equalTo(0);
            }else{
                make.top.equalTo(refer.mas_bottom);
            }
        }];
        refer =row;
    }
}

- (void)autoLayout{
    
    [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:0]);
        make.height.mas_equalTo([GUIUtil fit:5]);
        make.left.right.mas_equalTo(0);
    }];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.arrowImgView.mas_bottom);
        make.height.mas_equalTo([PopoverRow heightOfRow]*self.list.count);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
}

//MARK: - Action

- (void)cancelAction{
    [self removeFromSuperview];
}

- (void)rowAction:(PopoverRow *)row{
    _sureHander(row.config);
    [self cancelAction];
}

//MARK: - Getter

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

- (UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_triangle"]];
    }
    return _arrowImgView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [GColorUtil colorWithHex:0x6D87A8];
        _bottomView.layer.cornerRadius = 5;
        _bottomView.layer.masksToBounds = YES;
    }
    return _bottomView;
}

- (PopoverRow *)row{
    PopoverRow *row = [[PopoverRow alloc] init];
    [row addTarget:self action:@selector(rowAction:) forControlEvents:UIControlEventTouchUpInside];
    return row;
}


@end

@implementation Popover


+ (void)showAlert:(NSArray *)list
             point:(CGPoint)point
       sureHander:(void (^)(NSDictionary *dict))sureHander{
    
    UIWindow *window = [GJumpUtil window];
    PopoverView *view = [[PopoverView alloc] initWithList:list];
    view.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    view.sureHander = sureHander;
    view.tag = 4873;
    [view.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_left).mas_offset(point.x);
        make.top.mas_equalTo(point.y);
    }];
    [window addSubview:view];
    view.contentView.transform = CGAffineTransformIdentity;
}


+ (void)hide{
    UIWindow *window = [GJumpUtil window];
    PopoverView *view = [window viewWithTag:4873];
    [view cancelAction];
    [view removeFromSuperview];
}

@end


