//
//  HelpBannerView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/27.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "HelpBannerView.h"
#import "BaseScrollView.h"
#import "BaseLabel.h"

@interface HelpBannerRow : UIControl

@property (nonatomic,strong) UIImageView *img;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) NSDictionary *config;
@end

@implementation HelpBannerRow

+ (CGSize)sizeOfRow{
    return [GUIUtil fitWidth:167 height:90];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.img];
        [self addSubview:self.titleLabel];
        [_img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.width.equalTo(self);
        }];
    }
    return self;
}

- (void)configView:(NSDictionary *)dic{
    _config = dic;
    [GUIUtil imageViewWithUrl:_img url:[NDataUtil stringWith:dic[@"iconUrl"]]];
    _titleLabel.text = [NDataUtil stringWith:dic[@"title"]];
}

- (UIImageView *)img{
    if (!_img) {
        _img = [[UIImageView alloc] init];
    }
    return _img;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [GColorUtil C5];
        _titleLabel.font = [GUIUtil fitBoldFont:16];
        _titleLabel.numberOfLines = 1;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.minimumScaleFactor = 0.5;
        _titleLabel.hidden = YES;
    }
    return _titleLabel;
}

@end

@interface HelpBannerView ()

@property (nonatomic,strong) BaseScrollView *scrollView;
@property (nonatomic,strong) BaseLabel *titleLabel;
@property (nonatomic,strong) NSMutableArray *stockRowList;


@property (nonatomic,assign) BOOL isLoaded;
@end

@implementation HelpBannerView

+ (CGFloat)heightOfView:(NSInteger)count{
    return  [GUIUtil fit:15]+[GUIUtil fitBoldFont:18].lineHeight+[GUIUtil fit:20]+([HelpBannerRow sizeOfRow].height+[GUIUtil fit:10])*((count-1)/2+1) + [GUIUtil fit:5];
}

- (instancetype)init{
    if (self = [super init]) {
        _count = 6;
        self.bgColor = C6_ColorType;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.titleLabel];
    [self addSubview:self.scrollView];
    _stockRowList = [NSMutableArray array];
    HelpBannerRow *lastRow = nil;
    for (int i =0; i<6; i++) {
        HelpBannerRow *row = self.stockRow;
        [_scrollView addSubview:row];
        [_stockRowList addObject:row];
        [row mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i==0) {
                make.left.mas_equalTo([GUIUtil fit:15]);
                make.top.mas_equalTo([GUIUtil fit:0]);
            }
            make.size.mas_equalTo([HelpBannerRow sizeOfRow]);
        }];
        lastRow = row;
    }
    [lastRow mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]).priority(500);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:15]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.titleLabel.mas_bottom).mas_offset([GUIUtil fit:20]);
        make.bottom.mas_equalTo([GUIUtil fit:-15]);
    }];
}

//MARK: - Action

- (void)configOfView:(NSArray *)list{
    _count = list.count;
    HelpBannerRow *lastRow = nil;
    for (int i =0; i<_stockRowList.count; i++) {
        HelpBannerRow *row= _stockRowList[i];
        NSInteger listCount = list.count;
        if (i<listCount) {
            NSDictionary *model = [NDataUtil dataWithArray:list index:i];
            if (lastRow) {
                if (i%2==0) {
                    [row mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(lastRow.mas_bottom).mas_offset([GUIUtil fit:10]);
                        make.left.mas_equalTo([GUIUtil fit:15]);
                        make.size.mas_equalTo([HelpBannerRow sizeOfRow]);
                    }];
                }else{
                    [row mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(lastRow.mas_right).mas_offset([GUIUtil fit:10]);
                        make.top.equalTo(lastRow);
                    }];
                }
            }
            row.hidden = NO;
            [row configView:model];
            lastRow = row;
        }else{
            row.hidden = YES;
            [lastRow mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo([GUIUtil fit:-15]);
            }];
        }
    }
    
    if(list.count>_stockRowList.count){
        for (NSInteger i =_stockRowList.count; i<list.count; i++) {
            HelpBannerRow *row = self.stockRow;
            row.hidden = NO;
            [_scrollView addSubview:row];
            [_stockRowList addObject:row];
            [row mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo([GUIUtil fit:0]);
                make.size.mas_equalTo([HelpBannerRow sizeOfRow]);
            }];
            if (lastRow) {
                if (i%2==0) {
                    [row mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(lastRow.mas_bottom).mas_offset([GUIUtil fit:10]);
                    }];
                }else{
                    [row mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(lastRow.mas_right).mas_offset([GUIUtil fit:10]);
                        make.top.equalTo(lastRow);
                    }];
                }
            }else{
                [row mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo([GUIUtil fit:15]);
                }];
            }
            
            [row configView:[NDataUtil dataWithArray:list index:i]];
            lastRow = row;
        }
        [lastRow mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo([GUIUtil fit:-15]);
        }];
    }
}

- (void)rowSelectedAction:(HelpBannerRow *)row{
    _selectedRow(row.config);
}

//MARK:Getter

- (HelpBannerRow *)stockRow{
    HelpBannerRow *row = [[HelpBannerRow alloc] init];
    [row addTarget:self action:@selector(rowSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
    row.hidden = YES;
    return row;
}

- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[BaseLabel alloc] init];
        _titleLabel.txColor = C2_ColorType;
        _titleLabel.font = [GUIUtil fitBoldFont:18];
        _titleLabel.textBlock = CFDLocalizedStringBlock(@"帮助指引");
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (BaseScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[BaseScrollView alloc] init];
        _scrollView.bgColor = C6_ColorType;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled=NO;
    }
    return _scrollView;
}

@end
