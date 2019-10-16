//
//  LockerView.m
//  Chart
//
//  Created by ngw15 on 2019/3/4.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "LockerView.h"
#import "SectionView.h"
#import "BaseView.h"

@interface LockerView ()<UIScrollViewDelegate,LockerScrollProtocol>

@property (nonatomic,strong)BaseView *contentView;
@property (nonatomic,strong)SectionView *sectionView;
@property (nonatomic,strong)UIScrollView *hScrollView;

@property (nonatomic,assign)CGFloat topHeight;
@property (nonatomic,strong)NSArray <NSDictionary *>*list;
@property (nonatomic,strong)NSMutableArray <UIScrollView *>*tableViewList;
@property (nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic,assign)CGFloat sectionHeight;
@property (nonatomic,assign)BOOL shouldHScroll;
@end

@implementation LockerView

+ (CGFloat)sectionHeight{
    return [GUIUtil fit:35];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    
    if ([otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]){
        return NO;
    }
    
    if (self.contentOffset.x <= 0) {
        if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScreenEdgePanGestureRecognizer")]) {
            if (_shouldEdgePanable) {
                return _shouldEdgePanable();
            }else{            
                return YES;
            }
        }
    }
    return !_shouldHScroll;
}

- (instancetype)initWithTopHeight:(CGFloat)topHeight lists:(NSArray <NSDictionary *>*)list 
{
    return [self initWithTopHeight:topHeight lists:list sectionType:SectionTypeDivideWidth];
}

- (instancetype)initWithTopHeight:(CGFloat)topHeight lists:(NSArray <NSDictionary *>*)list sectionType:(SectionType)type
{
    self = [super init];
    if (self) {
        _list = list;
        _topHeight = ceil(topHeight);
        _sectionHeight = [GUIUtil fit:35];
        _shouldHScroll = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.bounces = YES;
        self.delegate = self;
        
        _tableViewList = [NSMutableArray array];
        NSMutableArray *titleList = [NSMutableArray array];
        UIScrollView *referView = nil;
        for (NSDictionary *dic in list) {
            [titleList addObject:[NDataUtil stringWith:dic[@"title"]]];
            UIScrollView <LockerScrollProtocol>*view = dic[@"view"];
            view.scrollDelegate = self;
            [_tableViewList addObject:view];
            [self.hScrollView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                if (referView==nil) {
                    make.left.mas_equalTo(0);
                }else{
                    make.left.equalTo(referView.mas_right);
                }
                make.width.mas_equalTo(SCREEN_WIDTH);
                make.top.mas_equalTo(0);
                make.height.equalTo(self.hScrollView);
            }];
            referView = view;
        }
        [referView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
        }];
        WEAK_SELF;
        _sectionView = [[SectionView alloc] initWithList:titleList sectionType:type];
        _sectionView.changedSelectedIndex = ^(NSInteger index) {
            [weakSelf changedSelectedIndex:index];
        };
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.contentView];
    [self addSubview:self.sectionView];
    [self addSubview:self.hScrollView];
}

- (void)autoLayout{
    [_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(self.topHeight);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [_sectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.topHeight);
        make.height.mas_equalTo(self.sectionHeight);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [_hScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.equalTo(self.sectionView.mas_bottom);
        make.height.equalTo(self).mas_offset(-self.sectionHeight);
        make.bottom.mas_equalTo(0);
    }];
}

//MARK: - Action

- (void)hScrollviewShouldScroll:(BOOL)flag{
    _hScrollView.scrollEnabled = flag;
    _shouldHScroll = flag;
}

- (void)updateTopHeight:(CGFloat)height{
    _topHeight = ceil(height);
    [self autoLayout];
}

- (void)updateTitleList:(NSArray *)list{
    [_sectionView updateTitleList:list];
}

- (void)setSectionBgColor:(ColorType)sectionBgColor sectionTextFont:(UIFont *)font sectionTextColor:(ColorType)textColor sectionSelTextColor:(ColorType)selColor hasLine:(BOOL)hasLine{
    [_sectionView setSectionBgColor:sectionBgColor sectionTextFont:font sectionTextColor:textColor sectionSelTextColor:selColor hasLine:hasLine];
}

- (void)changedSelectedIndex:(NSInteger)index{
    _selectedIndex = index;
    if (_hScrollView.dragging==NO) {    
        [_hScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*_selectedIndex, 0) animated:NO];
    }
    if (_selectedIndexHander) {
        _selectedIndexHander(index);
    }
}

//MARK: - Getter

- (UIScrollView *)hScrollView{
    if (!_hScrollView) {
        _hScrollView = [[UIScrollView alloc] init];
        _hScrollView.showsHorizontalScrollIndicator = NO;
        _hScrollView.showsVerticalScrollIndicator = NO;
        _hScrollView.bounces = NO;
        _hScrollView.pagingEnabled = YES;
        _hScrollView.delegate = self;
    }
    return _hScrollView;
}

- (BaseView *)contentView{
    if (!_contentView) {
        _contentView = [[BaseView alloc] init];
        _contentView.bgColor = C6_ColorType;
    }
    return _contentView;
}

- (SectionView *)sectionView{
    if (!_sectionView) {
        _sectionView = [[SectionView alloc] init];
        _sectionView.bgColor = C6_ColorType;
    }
    return _sectionView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //滚动的是主视图
    if (scrollView==self) {
        //主视图不能横行滚动
        if (scrollView.contentOffset.x!=0) {
            return;
        }
        //主视图滚动时，子视图的contentOffset都应是(0, 0)
        UIScrollView *currentSubView = _tableViewList[_selectedIndex];
        if(self.contentOffset.y>=self.topHeight||currentSubView.contentOffset.y>0){
            self.contentOffset = CGPointMake(0, self.topHeight);
        }else{
            for (UIScrollView *view in _tableViewList) {
                view.contentOffset = CGPointMake(0, 0);
            }
        }
    }
    //滚动的是横向视图
    else  if (scrollView==_hScrollView) {
      
        NSInteger index = (_hScrollView.contentOffset.x+SCREEN_WIDTH/2)/SCREEN_WIDTH;
        [_sectionView changeSelectedIndex:index];
    }
    //滚动的是子视图
    else{
        BOOL flag = NO;
        for (UIScrollView *view in _tableViewList) {
            if (scrollView==view) {
                flag=YES;
                break;
            }
        }
        if (flag) {
            //子视图不能横行滚动
            if (scrollView.contentOffset.x!=0) {
                return;
            }
            //横向视图没到顶部
            BOOL isTop = self.contentOffset.y<self.topHeight;
            //横向视图没显示完整
            BOOL isH = (NSInteger)self.hScrollView.contentOffset.x%(NSInteger)SCREEN_WIDTH!=0;
            if(isTop||isH){
                for (UIScrollView *view in _tableViewList) {
                    view.contentOffset = CGPointMake(0, 0);
                }
            }
        }
    }
    
   
}

@synthesize scrollDelegate;

@end
