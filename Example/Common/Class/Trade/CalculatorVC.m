//
//  CalculatorVC.m
//  Bitmixs
//
//  Created by ngw15 on 2019/9/10.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "CalculatorVC.h"
#import "SectionView.h"
#import "Calculator1View.h"
#import "Calculator2View.h"
#import "CFDScrollView.h"

@interface CalculatorVC ()<UIScrollViewDelegate>

@property (nonatomic,strong)SectionView *sectionView;
@property (nonatomic,strong)CFDScrollView *hScrollView;
@property (nonatomic,strong)Calculator1View *calculat1View;
@property (nonatomic,strong)Calculator2View *calculat2View;
@property (nonatomic,assign)NSInteger selectedIndex;

@property (nonatomic,strong)NSDictionary *config;
@end

@implementation CalculatorVC

+ (CalculatorVC *)jumpTo:(NSDictionary *)config{
    CalculatorVC *target = [[CalculatorVC alloc] init];
    target.hidesBottomBarWhenPushed = YES;
    target.config = config;
    [GJumpUtil pushVC:target animated:YES];
    return target;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = CFDLocalizedString(@"计算器");
    self.view.backgroundColor = [GColorUtil C6];
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addNotic];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [self removeNotic];
}

- (void)setupUI{
    [self.view addSubview:self.sectionView];
    [self.view addSubview:self.hScrollView];
    [_hScrollView addSubview:self.calculat1View];
    [_hScrollView addSubview:self.calculat2View];
    [_sectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fit:40]);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [_hScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sectionView.mas_bottom);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [_calculat1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.equalTo(self.hScrollView);
        make.top.mas_equalTo(0);
    }];
    [_calculat2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.equalTo(self.hScrollView);
        make.top.mas_equalTo(0);
        make.left.equalTo(self.calculat1View.mas_right);
        make.right.mas_equalTo(0);
    }];
}

- (void)changedSelectedIndex:(NSInteger)index{
    _selectedIndex = index;
    [self.view endEditing:YES];
    if (_selectedIndex==0) {
        [_calculat1View willAppear];
    }else if (_selectedIndex==1){
        [_calculat2View willAppear];
    }
    if (_hScrollView.dragging==NO) {
        [_hScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*_selectedIndex, 0) animated:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==_hScrollView) {
        NSInteger index = (_hScrollView.contentOffset.x+SCREEN_WIDTH/2)/SCREEN_WIDTH;
        [_sectionView changeSelectedIndex:index];
    }
}

- (void)updatePrice:(NSDictionary *)dic{
    if (_selectedIndex==0) {
        [_calculat1View updatePrice:dic];
    }else if (_selectedIndex==1){
        [_calculat2View updatePrice:dic];
    }
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notic{
    
    UIView *respondView = self.calculat1View;
    UITextField *textField = [_calculat1View firstRespondField];
    if (textField==nil) {
        respondView = self.calculat2View;
        textField = [_calculat2View firstRespondField];
    }
    if (textField==nil) {
        return;
    }
    NSDictionary *dic = [notic userInfo];
    CGRect keyboardFrame = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]; //获得键盘
    CGFloat bottom = [self.view convertPoint:CGPointMake(0, textField.bottom) fromView:textField.superview].y+TOP_BAR_HEIGHT;
    bottom = SCREEN_HEIGHT - bottom;
    CGFloat offset =keyboardFrame.size.height-bottom;
    if (offset>0) {
        [UIView beginAnimations:@"CalculatorVC" context:NULL];
        [UIView setAnimationDuration:[dic[UIKeyboardAnimationDurationUserInfoKey]floatValue]];
        [UIView setAnimationCurve:[dic[UIKeyboardAnimationCurveUserInfoKey]integerValue]];
        self.view.transform = CGAffineTransformMakeTranslation(0, -offset);
        [UIView commitAnimations];
    }
}

- (void)keyboardWillHide:(NSNotification *)notic{
    UIView *respondView = self.calculat1View;
    UITextField *textField = [_calculat1View firstRespondField];
    if (textField==nil) {
        respondView = self.calculat2View;
        textField = [_calculat2View firstRespondField];
    }
    if (textField==nil) {
        return;
    }
    NSDictionary *dic = [notic userInfo];
    [UIView beginAnimations:@"CalculatorVC" context:NULL];
    [UIView setAnimationDuration:[dic[UIKeyboardAnimationDurationUserInfoKey]floatValue]];
    [UIView setAnimationCurve:[dic[UIKeyboardAnimationCurveUserInfoKey]integerValue]];
    self.view.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
    
}

//MARK: - Getter

- (CFDScrollView *)hScrollView{
    if (!_hScrollView) {
        _hScrollView = [[CFDScrollView alloc] init];
        _hScrollView.showsHorizontalScrollIndicator = NO;
        _hScrollView.showsVerticalScrollIndicator = NO;
        _hScrollView.bounces = NO;
        _hScrollView.pagingEnabled = YES;
        _hScrollView.delegate = self;
    }
    return _hScrollView;
}

- (SectionView *)sectionView{
    if (!_sectionView) {
        NSArray *title = @[CFDLocalizedString(@"收益"),CFDLocalizedString(@"平仓价格")];
        _sectionView = [[SectionView alloc] initWithList:title sectionType:SectionTypeDivideWidth];
        _sectionView.backgroundColor = [GColorUtil C6];
        [_sectionView setSectionBgColor:C6_ColorType sectionTextFont:[GUIUtil fitFont:16] sectionTextColor:C3_ColorType sectionSelTextColor:C13_ColorType hasLine:YES];
        WEAK_SELF;
        _sectionView.changedSelectedIndex = ^(NSInteger index) {
            [weakSelf changedSelectedIndex:index];
        };
    }
    return _sectionView;
}

- (Calculator1View *)calculat1View{
    if (!_calculat1View) {
        _calculat1View = [[Calculator1View alloc] init];
        [_calculat1View configView:_config];
    }
    return _calculat1View;
}

- (Calculator2View *)calculat2View{
    if (!_calculat2View) {
        _calculat2View = [[Calculator2View alloc] init];
        [_calculat2View configView:_config];
    }
    return _calculat2View;
}

#pragma mark - Private

- (void)addNotic{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];}

- (void)removeNotic{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
