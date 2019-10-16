//
//  GuidePageController.m
//  globalwin
//
//  Created by 张洪林 on 2018/7/25.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "GuidePageController.h"
#import "GuidePageCell.h"
#import "GuidePageManager.h"

@interface GuidePageController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong)UICollectionViewFlowLayout *layout;
@property (nonatomic, strong)NSArray *picArray;
@end

@implementation GuidePageController
-(instancetype)initWithArray:(NSArray *)picStrArr{
    self = [super init];
    if (self) {
        _picArray = picStrArr;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-(50+(IS_IPHONE_X?IPHONE_X_BOTTOM_HEIGHT:0)));
    }];
    
    
    // Do any additional setup after loading the view.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.picArray.count+1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==self.picArray.count) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
        cell.alpha=0;
        return cell;
    }
    GuidePageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GuidePageCell class]) forIndexPath:indexPath];
    NSString *image = self.picArray[indexPath.row];
    cell.image = [GColorUtil imageNamed:image];
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView!=_collectionView) {
        return;
    }
    CGFloat offsetX = scrollView.contentOffset.x;
    self.pageControl.currentPage=offsetX/SCREEN_MIN_LENGTH;
    if (offsetX>=self.picArray.count*SCREEN_MIN_LENGTH) {
        [GuidePageManager stopGuideAction];
    }
}

-(UIPageControl *)pageControl{
    if(!_pageControl)
    {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.currentPageIndicatorTintColor = [GColorUtil C13];
        _pageControl.pageIndicatorTintColor = [GColorUtil colorWithHex:0xf4f5f6];
        _pageControl.numberOfPages = self.picArray.count;
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:self.layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor clearColor]; _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[GuidePageCell class] forCellWithReuseIdentifier:NSStringFromClass([GuidePageCell class])];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    }
    return _collectionView;
}
-(UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置cell的尺寸
        _layout.itemSize = [UIScreen mainScreen].bounds.size;
        // 清空行距
        _layout.minimumLineSpacing = 0;
        // 设置滚动的方向
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
