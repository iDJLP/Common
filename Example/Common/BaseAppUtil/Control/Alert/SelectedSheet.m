//
//  SelectedSheet.m
//  Bitmixs
//
//  Created by ngw15 on 2019/6/11.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "SelectedSheet.h"

@interface SelectedSheetRow : UIView

@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIView *line;

@property (nonatomic,strong)NSDictionary *config;
@end

@implementation SelectedSheetRow



+ (CGFloat)heightOfRow{
    
    return [GUIUtil fit:50];
}

- (instancetype)init{
    if (self = [super init]) {
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.imgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.line];
}

- (void)autoLayout{
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.equalTo(self.titleLabel.mas_left).mas_offset([GUIUtil fit:-15]);
        make.size.mas_equalTo([GUIUtil fitWidth:20 height:20]);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
}

- (void)configOfRow:(NSDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _config = dict;
    [GUIUtil imageViewWithUrl:_imgView url:dict[@"icon"]];
    _titleLabel.text = [NDataUtil stringWith:dict[@"currency"]];
    if ([NDataUtil boolWithDic:dict key:@"isSelected" isEqual:@"1"]) {
        self.backgroundColor = [ChartsUtil C13:0.1];
        self.titleLabel.textColor = [GColorUtil C13];
    }else{
        self.backgroundColor = [GColorUtil C6];
        self.titleLabel.textColor = [GColorUtil C2];
    }
}
//MARK:Getter

- (UIImageView *)imgView{
    if(!_imgView){
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [GColorUtil C2];
        _titleLabel.font = [GUIUtil fitBoldFont:14];
    }
    return _titleLabel;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [GColorUtil C7];
    }
    return _line;
}

@end

@interface SelectedSheetView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)NSMutableArray <SelectedSheetRow *>*rowList;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UIView *line;

@property (nonatomic,strong)NSArray *dataList;
@property (nonatomic,strong) void(^sureHander)(NSDictionary *);

@end

@implementation SelectedSheetView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [GColorUtil colorWithHex:0x000000 alpha:0.4];
        [self setupUI];
        [self autoLayout];
        WEAK_SELF;
        [self g_clickBlock:^(UITapGestureRecognizer *tap) {
            [weakSelf cancelAction];
        }];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.line1];
    [self.contentView addSubview:self.cancelBtn];
    [self.contentView addSubview:self.line];
    self.rowList = [NSMutableArray array];
    WEAK_SELF;
    for (NSInteger i=0; i<3; i++) {
        SelectedSheetRow *row = [[SelectedSheetRow alloc] init];
        __weak typeof(row) weakRow = row;
        [row g_clickBlock:^(UITapGestureRecognizer *tap) {
            [weakSelf sureAction:weakRow.config];
        }];
        [self.contentView addSubview:row];
        [self.rowList addObject:row];
    }
}

- (void)autoLayout{
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:0]);
        make.left.mas_equalTo([GUIUtil fit:20]);
        make.height.mas_equalTo([GUIUtil fit:60]);
    }];
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.cancelBtn.mas_top);
        make.height.mas_equalTo([GUIUtil fit:7]);
    }];
   
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-IPHONE_X_BOTTOM_HEIGHT);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([GUIUtil fit:50]);
    }];
}

- (void)setDataList:(NSArray *)dataList{
    _dataList = dataList;
    UIView *refer = nil;
    WEAK_SELF;
    for (NSInteger i=0; i<dataList.count; i++) {
        SelectedSheetRow *row = [NDataUtil dataWithArray:_rowList index:i];
        row.hidden = NO;
        if (row==nil) {
            row = [[SelectedSheetRow alloc] init];
            [self.contentView addSubview:row];
            [self.rowList addObject:row];
            __weak typeof(row) weakRow = row;
            [row g_clickBlock:^(UITapGestureRecognizer *tap) {
                [weakSelf sureAction:weakRow.config];
            }];
        }
        [row configOfRow:[NDataUtil dataWithArray:dataList index:i]];
        [row mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (refer==nil) {
                make.top.equalTo(self.titleLabel.mas_bottom);
            }else{
                make.top.equalTo(refer.mas_bottom);
            }
            make.height.mas_equalTo([SelectedSheetRow heightOfRow]);
            make.left.right.mas_equalTo(0);
        }];
        refer = row;
    }
    for (NSInteger i=dataList.count; i<_rowList.count; i++) {
        SelectedSheetRow *row = [NDataUtil dataWithArray:_rowList index:i];
        row.hidden = YES;
    }
    [refer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.line.mas_top);
    }];
}

//MARK: - Action

- (void)showAnimation{
    [self layoutIfNeeded];
    self.contentView.top = SCREEN_HEIGHT;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.bottom = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)sureAction:(NSDictionary *)dic{
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if(self.sureHander){
            self.sureHander(dic);
        }
    }];
}

- (void)cancelAction{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//MARK: - Getter

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [GColorUtil C6];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = CFDLocalizedString(@"请选择币种");
        _titleLabel.font =[GUIUtil fitFont:16];
        _titleLabel.textColor = [GColorUtil C2];
    }
    return _titleLabel;
}

- (UIView *)line1{
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = [GColorUtil C7];
    }
    return _line1;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [GColorUtil C8];
    }
    return _line;
}


- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:CFDLocalizedString(@"取消") forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [GUIUtil fitFont:16];
        [_cancelBtn setTitleColor:[GColorUtil C3] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

@end

@interface SelectedSheet ()

@end

@implementation SelectedSheet

+ (void)showAlert:(NSString *)title
         dataList:(NSArray *)dataList
       sureHander:(void(^)(NSDictionary *))sureHander{
    UIWindow *window = [GJumpUtil window];
    SelectedSheetView *view = [[SelectedSheetView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.dataList = dataList;
    view.titleLabel.text = title;
    view.sureHander = sureHander;
    view.tag = 4612;
    [window addSubview:view];
    [view showAnimation];
}

+ (void)hide{
    UIWindow *window = [GJumpUtil window];
    SelectedSheetView *view = [window viewWithTag:4612];
    [view cancelAction];
    [view removeFromSuperview];
}

@end


