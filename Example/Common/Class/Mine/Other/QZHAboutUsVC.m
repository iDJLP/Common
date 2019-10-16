//
//  FTOLYAboutUsViewController.m
//  niuguwang
//
//  Created by jly on 16/11/4.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import "QZHAboutUsVC.h"
#import "EasyCell.h"


@interface QZHAboutUsVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *aboutUsTableView;
@property (nonatomic,strong)NSArray     *dataArray;
@end

@implementation QZHAboutUsVC

- (void)loadView
{
    [super loadView];
    [self.view addSubview:self.aboutUsTableView];
    
    [self.aboutUsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = CFDLocalizedString(@"关于");
    self.view.backgroundColor = [GColorUtil C6];
    self.edgesForExtendedLayout = UIRectEdgeNone;

}
#pragma mark ----TableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Easy";
    EasyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
    {
        cell = [[EasyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    
    cell.leftLabel.textColor = [GColorUtil C2];
    [cell reloadData:self.dataArray[indexPath.row] rightText:@"" showArrow:YES];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *title = @"";
    NSString *link = @"";
    switch (indexPath.row) {
        case 0:  //注册协议
        {
            title = CFDLocalizedString(@"注册协议");
            link = [NSString stringWithFormat:@"%@?name=%@",[[FTConfig sharedInstance] registrationAgreement],[[[FTConfig sharedInstance] displayName] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        }
            break;
        case 1:  //风险揭示
        {
            title = CFDLocalizedString(@"风险揭示");
            link = [NSString stringWithFormat:@"%@?name=%@",[[FTConfig sharedInstance] riskDisclosure],[[[FTConfig sharedInstance] displayName] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        }
            break;
       
        default:
            break;
    }
    [CFDJumpUtil jumpToWeb:title link:link animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [GUIUtil fit:241];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view            = [UIView new];
    UIImageView *icon       = [UIImageView new];
    icon.image              = [GColorUtil imageNamed:@"mine_about_logo"];
    icon.clipsToBounds      = YES;
    icon.layer.cornerRadius = 22;
    [view addSubview:icon];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:55]);
        make.height.width.mas_equalTo([GUIUtil fit:100]);
        make.centerX.equalTo(view);
    }];
    
    UILabel *label  = [UILabel new];
    label.textColor = [GColorUtil C2];
    label.font      = [GUIUtil fitFont:16];
    label.text      = [NSString stringWithFormat:@"%@ V%@",[FTConfig sharedInstance].displayName,[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.mas_equalTo(icon.mas_bottom).mas_offset([GUIUtil fit:20]);
    }];
    return view;
}
- (NSArray *)dataArray
{
    if(!_dataArray)
    {
        NSString *registerProtocol = [NSString stringWithFormat:CFDLocalizedString(@"《%@注册协议》"),[FTConfig sharedInstance].displayName];
        
        _dataArray = @[registerProtocol,CFDLocalizedString(@"《风险揭示》")];
    }
    return _dataArray;
}


#pragma mark---- init

- (UITableView *)aboutUsTableView
{
    if(!_aboutUsTableView)
    {
        _aboutUsTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _aboutUsTableView.delegate   = self;
        _aboutUsTableView.dataSource = self;
        _aboutUsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _aboutUsTableView.backgroundColor = [UIColor clearColor];
        
        _aboutUsTableView.estimatedRowHeight = 0;
        _aboutUsTableView.estimatedSectionHeaderHeight = 0;
        _aboutUsTableView.estimatedSectionFooterHeight = 0;
        
        UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, IPHONE_X_BOTTOM_HEIGHT)];
        _aboutUsTableView.tableFooterView = footer;
        if (@available(iOS 11.0, *)) {
            _aboutUsTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _aboutUsTableView;
}

@end
