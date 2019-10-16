//
//  NNTJTrainingVC.m
//  niuguwang
//
//  Created by ngw on 2017/7/21.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "NNTJTrainingVC.h"
#import "NNTJTrainingModel.h"

@interface NNTJTrainingVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIImageView * headView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * imageArray;
@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, strong) NSArray * bannerArray;
@property (nonatomic, assign) NSInteger chooseType;
@property (nonatomic, strong) NNTJTrainingModel * model;

@end

@implementation NNTJTrainingVC

+ (void)jumpTo{
    NNTJTrainingVC *target =[NNTJTrainingVC new];
    target.hidesBottomBarWhenPushed = YES;
    [GJumpUtil pushVC:target animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = CFDLocalizedString(@"帮助中心");
    [self initData];
    [self initUI];
}

- (void)initUI
{
    WEAK_SELF;
    self.view.backgroundColor = [GColorUtil C6];
    
    self.headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [GUIUtil fit:140])];
    self.headView.userInteractionEnabled = YES;
    NSString *imageName = [[FTConfig sharedInstance].lang isEqualToString:@"en"]? @"home_training_banner_en":@"home_training_banner";
    self.headView.image = [GColorUtil imageNamed:imageName];
    [self.view addSubview:self.headView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [GUIUtil fit:140], SCREEN_WIDTH, SCREEN_HEIGHT -[GUIUtil fit:140]-TOP_BAR_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [GColorUtil C6];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, IPHONE_X_BOTTOM_HEIGHT)];
    self.tableView.tableFooterView = footer;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [GUIUtil refreshWithHeader:self.tableView refresh:^{
        [weakSelf getData];
    }];

}

- (void)getData
{
    NSString * category = @"";
    switch (self.chooseType) {
        case 0:
            category = @"xsyd";
            break;
        case 1:
            category = @"jyxg";
            break;
        case 2:
            category = @"cjwt";
            break;
            
        default:
            break;
    }
    WEAK_SELF;
    [self.model postInvestmentCamp:category success:^(id data) {
        weakSelf.dataArray = [NDataUtil arrayWith:data[@"data"]];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
   
    } failure:^(id data) {
        if ([data isKindOfClass:[NSString class]]) {
            
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];

    }];
}

- (void)initData
{
    self.model = [NNTJTrainingModel sharedInstance];
    self.chooseType = 0;
    self.titleArray = [NSArray arrayWithObjects:CFDLocalizedString(@"新手引导"), CFDLocalizedString(@"交易相关"), CFDLocalizedString(@"常见问题"), nil];
    self.imageArray = [NSArray arrayWithObjects:@"mine_icon_help_new",@"mine_icon_help_trade", @"mine_icon_help_problem", nil];
    self.dataArray = [NSArray array];
    self.bannerArray = [NSArray array];
    [self getData];

}

#pragma mark tabelViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1 : self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return indexPath.section == 0 ? [GUIUtil fit:100] : [GUIUtil fit:45];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? CGFLOAT_MIN : [GUIUtil fit:10];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID2"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID2"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [GColorUtil C6];
        }
        
        for (UIView * view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        for (int i = 0; i < 3; i++) {
            
            UIImageView * imageView = [UIImageView new];
            imageView.image = [GColorUtil imageNamed:[self.imageArray objectAtIndex:i]];
            [cell.contentView addSubview:imageView];
            
            UILabel *titleLabel = [UILabel new];
            titleLabel.text = [self.titleArray objectAtIndex:i];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [GUIUtil fitFont:12];

            if (self.chooseType == 0) {
                if (i == 0) {
                    titleLabel.textColor = [GColorUtil C13];
                } else {
                    titleLabel.textColor = [GColorUtil C2];
                }
            } else if (self.chooseType == 1) {
                if (i == 1) {
                    titleLabel.textColor = [GColorUtil C13];
    
                } else {
                    titleLabel.textColor = [GColorUtil C2];
                }

            } else {
                if (i == 2) {
                    titleLabel.textColor = [GColorUtil C13];
                } else {
                    titleLabel.textColor = [GColorUtil C2];
                }
            }
            [cell.contentView addSubview:titleLabel];
            
            WEAK_SELF;
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            [btn g_clickBlock:^(UIButton *sender) {
                weakSelf.chooseType = sender.tag;
                [weakSelf.tableView reloadData];
                [weakSelf getData];
            }];
            [cell.contentView addSubview:btn];
            
            UILabel * lineLabel = [UILabel new];
            lineLabel.backgroundColor = [GColorUtil C7];
            [cell.contentView addSubview:lineLabel];

            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(SCREEN_WIDTH / 3 * i);
                make.top.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 3, [GUIUtil fit:100]));
            }];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(btn.mas_centerX);
                make.top.mas_equalTo([GUIUtil fit:21]);
                make.size.mas_equalTo(CGSizeMake([GUIUtil fit:34], [GUIUtil fit:34]));
            }];

            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(btn.mas_centerX);
                make.bottom.mas_equalTo([GUIUtil fit:-21]);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 3, [GUIUtil fit:14]));
            }];
            
            [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(titleLabel.mas_centerY);
                make.left.mas_equalTo(SCREEN_WIDTH / 3  * i);
                make.size.mas_equalTo(CGSizeMake([GUIUtil fitLine], [GUIUtil fit:19]));
            }];
        }
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [GColorUtil C7];
        [cell.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:0]);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo([GUIUtil fitLine]);
        }];
        return cell;
    } else {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID1"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [GColorUtil C6];
        }
        
        for (UIView * view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake([GUIUtil fit:25], 0, SCREEN_WIDTH - [GUIUtil fit:55], [GUIUtil fit:45])];
        titleLabel.text = [NDataUtil stringWith:[(NSDictionary *)[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"title"] valid:@""];
        titleLabel.font = [GUIUtil fitFont:16];
        titleLabel.textColor = [GColorUtil C2];
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"public_icon_more"]];
        [cell.contentView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo([GUIUtil fit:-15]);
            make.centerY.mas_equalTo(0);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [GColorUtil C7];
        [cell.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:15]);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo([GUIUtil fitLine]);
        }];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (self.dataArray.count > 0) {
            NSDictionary *dict = [NDataUtil dataWithArray:self.dataArray index:indexPath.row];
            NSString * idStr = [NDataUtil stringWith:dict[@"articleid"] valid:@""];
            NSString * title = [NDataUtil stringWith:dict[@"title"] valid:@""];
            NSString *link = [NSString stringWithFormat:@"%@?id=%@",[FTConfig sharedInstance].helpDetail,idStr];
            [CFDJumpUtil jumpToWeb:title link:link type:WebVCTypeNews animated:YES];
        }
    }
}



@end
