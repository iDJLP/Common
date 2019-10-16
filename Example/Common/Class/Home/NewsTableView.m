//
//  NewsTableView.m
//  Chart
//
//  Created by ngw15 on 2019/3/7.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "NewsTableView.h"
#import "CFDNewsCell.h"
#import "WebVC.h"

@interface NewsTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *dataList;
@property (nonatomic,assign)NSInteger pageIndex;
@property (nonatomic,assign)BOOL isLoaded;

@end

@implementation NewsTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.bgColor = C6_ColorType;
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSelectionStyleNone;
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self registerClass:CFDNewsCell.class forCellReuseIdentifier:@"CFDNewsCell"];
        [StateUtil show:self type:StateTypeProgress];
        WEAK_SELF;
        [GUIUtil refreshWithFooter:self refresh:^{
            [weakSelf loadData:weakSelf.pageIndex+1];
        }];
    }
    return self;
}

- (void)viewWillAppear{
    [self loadData:1];
}

- (void)loadData:(NSInteger )page{
    WEAK_SELF;
    [DCService articlesDataindex:page count:20 category:@"bqzx" success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"code" isEqual:@"0"]) {
            NSDictionary *dict = [NDataUtil dictWith:data[@"result"]];
            NSArray *tem = [NDataUtil arrayWith:dict[@"Items"]];
            [weakSelf successHander:tem page:page];
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
            [weakSelf failedHander];
        }
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
        [weakSelf failedHander];
    }];
}

- (void)successHander:(NSArray *)tem page:(NSInteger)page{
    if (_dataList.count<=0||page==1) {
        _dataList = tem.mutableCopy;
    }else{
        [_dataList addObjectsFromArray:tem];
    }
    if (_isLoaded==NO&&_dataList.count<=0) {
        [StateUtil show:self type:StateTypeNodata];
    }else{
        _pageIndex = page;
        _isLoaded=YES;
        [StateUtil hide:self];
        [self reloadData];
        [_mj_delegate.mj_header endRefreshing];
        if (tem.count==0) {
            [_mj_delegate.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_mj_delegate.mj_footer endRefreshing];
        }
    }
}

- (void)failedHander{
    WEAK_SELF;
    [_mj_delegate.mj_header endRefreshing];
    [_mj_delegate.mj_footer endRefreshing];
    if (_isLoaded==NO) {
        ReloadStateView *stateView = (ReloadStateView *)[StateUtil show:self type:StateTypeReload];
        stateView.onReload = ^{
            [StateUtil show:weakSelf type:StateTypeProgress];
            [weakSelf loadData:1];
        };
    }else{
        [StateUtil hide:self];
    }
}

#pragma mark ----tableview

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CFDNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CFDNewsCell"];
    [cell updateCell:[NDataUtil dataWithArray:_dataList index:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  [CFDNewsCell heightOfCell];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = [NDataUtil dataWithArray:_dataList index:indexPath.row];
    
    NSString *url = [NSString stringWithFormat:@"%@?newsid=%@",[FTConfig sharedInstance].newsDetail,[NDataUtil stringWith:dict[@"articleid"] valid:@""]];
    [WebVC jumpTo:@"资讯详情" link:url type:WebVCTypeNews animated:YES];
    
    NSString *key = [NSString stringWithFormat:@"articleid%@",[NDataUtil stringWith:dict[@"articleid"] valid:@""]];
    [NLocalUtil setBool:YES forKey:key];
    [self reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_scrollDelegate scrollViewDidScroll:scrollView];
}

@end
