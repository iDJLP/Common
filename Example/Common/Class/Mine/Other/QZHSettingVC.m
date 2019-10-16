
//
//  QZHSettingVC.m
//  niuguwang
//
//  Created by jly on 16/11/4.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import "QZHSettingVC.h"
#import "EasyCell.h"
#import "QZHAboutUsVC.h"
#import "SelectedSheet.h"

@interface QZHSettingVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy)NSArray *dataArrayLeft;
@property (nonatomic,copy)NSArray *dataArrayRight;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation QZHSettingVC


+ (void)jumpTo{
    QZHSettingVC *target = [[QZHSettingVC alloc] init];
    target.hidesBottomBarWhenPushed = YES;
    [GJumpUtil pushVC:target animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    
    self.view.backgroundColor = [GColorUtil C6];

    self.title = CFDLocalizedString(@"设置");
}


- (void)exitAction:(UIButton *)btn
{
    [[UserModel sharedInstance] logout];
    [GJumpUtil popAnimated:YES];
}
#pragma mark ----TableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EasyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Easy"];
    cell.leftLabel.textColor    = [GColorUtil C2];
    cell.rightLabel.textColor    = [GColorUtil C3];
    cell.rightLabel.font = [GUIUtil fitFont:12];
    [cell reloadData:self.dataArrayLeft[indexPath.row] rightText:self.dataArrayRight[indexPath.row] showArrow:indexPath.row!=1];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.dataArrayLeft count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  [GUIUtil fit:49];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:{
            BOOL isEn = [[FTConfig sharedInstance].lang isEqualToString:@"en"];
            NSDictionary *dic = @{@"currency":@"简体中文",@"isSelected":@(!isEn)};
            NSDictionary *dic1 = @{@"currency":@"English",@"isSelected":@(isEn)};
            WEAK_SELF;
            [SelectedSheet showAlert:CFDLocalizedString(@"语言") dataList:@[dic,dic1] sureHander:^(NSDictionary * _Nonnull dic) {
                NSString *language = [NDataUtil boolWithDic:dic key:@"currency" isEqual:@"English"]?@"en":@"cn";
                if (![[FTConfig sharedInstance].lang isEqualToString:language]) {
                    [FTConfig sharedInstance].lang = language;
                    [NLocalUtil setString:language forKey:@"lang"];
                    [[CFDLocalizedManager sharedInstance] setUserLanguage:[FTConfig sharedInstance].lang];
                    [[NSNotificationCenter defaultCenter] postNotificationName:LanguageDidChangedNotification object:self];
                    [weakSelf.tableView reloadData];
                    self.title = CFDLocalizedString(@"设置");
                }
            }];
        }
            break;
        case 1:{
            
            BOOL isRed = [CFDApp sharedInstance].isRed;
            NSDictionary *dic = @{@"currency":CFDLocalizedString(@"红涨绿跌"),@"isSelected":@(isRed)};
            NSDictionary *dic1 = @{@"currency":CFDLocalizedString(@"绿涨红跌"),@"isSelected":@(!isRed)};
            WEAK_SELF;
            [SelectedSheet showAlert:CFDLocalizedString(@"涨跌颜色") dataList:@[dic,dic1] sureHander:^(NSDictionary * _Nonnull dic) {
                BOOL flag = [NDataUtil boolWithDic:dic key:@"currency" isEqual:CFDLocalizedString(@"红涨绿跌")]?YES:NO;
                if ([CFDApp sharedInstance].isRed!=flag) {
                    [CFDApp sharedInstance].isRed=flag;
                    [NLocalUtil setBool:flag forKey:@"app_isRed"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:ThemeDidChangedNotification object:self];
                    [weakSelf.tableView reloadData];
                }
            }];
        }
            break;
        case 2:  //关于
        {
            QZHAboutUsVC *aboutUSCtrl = [QZHAboutUsVC new];
            [self.navigationController pushViewController:aboutUSCtrl animated:YES];
            
        }
            break;
        case 3:
        {
            if ([CFDApp sharedInstance].hasLastVersionApp) {
                [GJumpUtil updateApp:[CFDApp sharedInstance].updateAppUrl];
            }
        }
            break;
        default:
            break;
            
      
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(![UserModel isLogin]) return 0.001;
    CGFloat top = SCREEN_HEIGHT-TOP_BAR_HEIGHT-[GUIUtil fit:49]*2-[GUIUtil fit:45];
    return top;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(![UserModel isLogin]) return nil;
    UIView *view = [UIView new];
    view.backgroundColor = [GColorUtil C6];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:CFDLocalizedString(@"退出登录") forState:UIControlStateNormal];
    [button setTitleColor:[GColorUtil C2_black] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[GColorUtil C13]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[GColorUtil C13]] forState:UIControlStateHighlighted];
    button.titleLabel.font = [GUIUtil fitFont:17];
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
    WEAK_SELF;
    [button g_clickBlock:^(id sender) {
        [weakSelf exitAction:sender];
    }];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.right.mas_equalTo([GUIUtil fit:-15]);
        CGFloat top = SCREEN_HEIGHT-TOP_BAR_HEIGHT-[GUIUtil fit:49]*self.dataArrayLeft.count-[GUIUtil fit:30]-BOTTOM_BAR_HEIGHT;
        make.top.mas_equalTo(top);
        make.height.mas_equalTo([GUIUtil fit:45]);
    }];
    return view;
}
- (NSArray *)dataArrayLeft
{
    _dataArrayLeft = @[CFDLocalizedString(@"语言"),CFDLocalizedString(@"涨跌颜色"),CFDLocalizedString(@"关于"),CFDLocalizedString(@"检测更新")];
//    _dataArrayLeft = @[CFDLocalizedString(@"关于"),CFDLocalizedString(@"检测更新")];
    return _dataArrayLeft;
}

- (NSArray *)dataArrayRight
{
    NSString *update = @"";
    if ([CFDApp sharedInstance].hasLastVersionApp) {
        update = CFDLocalizedString(@"点击更新");
    }else{
        update = CFDLocalizedString(@"已是最新版本");
    }
    NSString *language = @"简体中文";
    if ([[FTConfig sharedInstance].lang isEqualToString:@"en"]) {
        language = @"English";
    }
    NSString *string = [CFDApp sharedInstance].isRed ? CFDLocalizedString(@"红涨绿跌"):CFDLocalizedString(@"绿涨红跌");
    _dataArrayRight = @[language,string,@"",update];
//    _dataArrayRight = @[@"",update];
    return _dataArrayRight;
}

- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-TOP_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [GColorUtil C6];
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:EasyCell.class forCellReuseIdentifier:@"Easy"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    
    return _tableView;
}
@end
