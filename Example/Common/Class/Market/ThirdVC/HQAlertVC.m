//
//  AlertSLTPVC.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/18.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "HQAlertVC.h"
#import "QZHOfferRemindTitleCell.h"
#import "QZHOfferRemindCell.h"
#import "AlertFrequencyVC.h"
#import "WebSocketManager.h"

@interface HQAlertVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy)NSString *symbol;
@property (nonatomic,copy)NSString *stockname;
@property (nonatomic,assign)NSInteger dotnum;
@property (nonatomic,copy) NSString *nowv;
@property (nonatomic,copy)NSString *iPreclose;
@property (nonatomic,copy) NSString *updown;
@property (nonatomic,copy) NSString *updownRate;

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIBarButtonItem *rightItem;
@property (nonatomic,copy)NSString *alertrate;
@property (nonatomic,strong)NSMutableArray *dataList;
@property (nonatomic, strong) WebSocketManager *webSocket;
@end

@implementation HQAlertVC

+ (void)jumpTo:(NSDictionary *)dic{
    HQAlertVC *target = [[HQAlertVC alloc] init];
    target.dotnum = [NDataUtil integerWith:dic[@"dotnum"]];
    target.symbol = [NDataUtil stringWith:dic[@"symbol"]];
    target.stockname = [NDataUtil stringWith:dic[@"stockname"]];
    target.nowv = [GUIUtil notRoundingString:[NDataUtil stringWith:dic[@"nowv"]] afterPoint:target.dotnum];
    target.iPreclose = [GUIUtil notRoundingString:[NDataUtil stringWith:dic[@"iPreclose"]] afterPoint:target.dotnum];
    target.updown = [NDataUtil stringWith:dic[@"updown"]];
    target.updownRate = [NDataUtil stringWith:dic[@"updownRate"]];
    target.hidesBottomBarWhenPushed = YES;
    [GJumpUtil pushVC:target animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = CFDLocalizedString(@"行情提醒");
    WEAK_SELF;
    [GNavUtil rightTitle:self title:CFDLocalizedString(@"完成") color:C2_ColorType onClick:^{
        [weakSelf sureAction];
    }];
    [self.view addSubview:self.tableView];
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self websocketLoad];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_webSocket disconnect];
    _webSocket=nil;
}

- (void)loadData{
    WEAK_SELF;
    [DCService getalertsymbol:self.symbol success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            [weakSelf parsedata:data];
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
        }
        
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
    }];
}

- (void)parsedata:(id)data
{
    
    self.dataList = [[NSMutableArray alloc]init];
    NSDictionary *dic = @{@"title":CFDLocalizedString(@"价格涨至"),@"swich":[NDataUtil stringWith:data[@"risingpriceisopen"] valid:@""],@"price":[NDataUtil stringWith:data[@"risingprice"] valid:@""],@"placeholder":CFDLocalizedString(@"输入价格")};
    [self.dataList addObject:[dic mutableCopy]];
    
    NSDictionary *dic2 = @{@"title":CFDLocalizedString(@"价格低至"),@"swich":[NDataUtil stringWith:data[@"fallpriceisopen"] valid:@""],@"price":[NDataUtil stringWith:data[@"fallprice"] valid:@""],@"placeholder":CFDLocalizedString(@"输入价格")};
    [self.dataList addObject:[dic2 mutableCopy]];
    
    NSDictionary *dic3 = @{@"title":CFDLocalizedString(@"日涨幅(%)"),@"swich":[NDataUtil stringWith:data[@"dailygainexceedisopen"] valid:@""],@"price":[NDataUtil stringWith:data[@"dailygainexceed"] valid:@""],@"placeholder":CFDLocalizedString(@"输入涨幅")};
    [self.dataList addObject:dic3.mutableCopy];
    NSDictionary *dic4 = @{@"title":CFDLocalizedString(@"日跌幅(%)"),@"swich":[NDataUtil stringWith:data[@"dailydeclineexceedisopen"] valid:@""],@"price":[NDataUtil stringWith:data[@"dailydeclineexceed"] valid:@""],@"placeholder":CFDLocalizedString(@"输入涨幅")};
    [self.dataList addObject:dic4.mutableCopy];
    
    NSDictionary *dic5 = @{@"title":CFDLocalizedString(@"提醒频率"),@"swich":@"",@"price":[self intToAlertrate:[NDataUtil stringWith:data[@"alertrate"] valid:@"2"]],@"placeholder":@""};
    [self.dataList addObject:dic5.mutableCopy];
    _alertrate = [self intToAlertrate:[NDataUtil stringWith:data[@"alertrate"] valid:@"2"]];
    
    [self.tableView reloadData];
}

- (void)sureAction
{
    QZHOfferRemindCell *cell = (QZHOfferRemindCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    QZHOfferRemindCell *cell1 = (QZHOfferRemindCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    QZHOfferRemindCell *dayupcell = (QZHOfferRemindCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    QZHOfferRemindCell *daydowncell = (QZHOfferRemindCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    
    if((cell.swich.on && cell.tx.text.length == 0)||(cell1.swich.on && cell1.tx.text.length == 0))
    {
        
        [HUDUtil showInfo:CFDLocalizedString(@"请输入价格")];
        return;
    }
    double nowP =  [_nowv doubleValue];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    BOOL flag = NO;
    if(cell.swich.on && cell.tx.text.length !=0)
    {
        
        if([cell.tx.text doubleValue]<=nowP)
        {
            NSMutableDictionary *dict = [NDataUtil dataWithArray:_dataList index:0];
            [dict setObject:CFDLocalizedString(@"上涨提醒价格不得低于当前价") forKey:@"remark"];
            [self.tableView reloadRow:1 inSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
            flag = YES;
        }
        [dic setObject:[NSString stringWithFormat:@"1"] forKey:@"risingpriceisopen"];
        [dic setObject:cell.tx.text forKey:@"risingprice"];
    }else if (cell.swich.on == NO){
        [dic setObject:[NSString stringWithFormat:@"0"] forKey:@"risingpriceisopen"];
    }
    
    if(cell1.swich.on && cell1.tx.text.length !=0)
    {
        if([cell1.tx.text doubleValue]>=nowP)
        {
            NSMutableDictionary *dict1 = [NDataUtil dataWithArray:_dataList index:1];
            [dict1 setObject:CFDLocalizedString(@"下跌提醒价格不得高于当前价") forKey:@"remark"];
            [self.tableView reloadRow:2 inSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
            flag = YES;
        }
        [dic setObject:[NSString stringWithFormat:@"1"] forKey:@"fallpriceisopen"];
        [dic setObject:cell1.tx.text forKey:@"fallprice"];
        
    }else if (cell1.swich.on == NO){
        [dic setObject:[NSString stringWithFormat:@"0"] forKey:@"fallpriceisopen"];
    }
    
    if(dayupcell.swich.on && dayupcell.tx.text.length !=0)
    {
        [dic setObject:[NSString stringWithFormat:@"1"] forKey:@"dailygainexceedisopen"];
        [dic setObject:dayupcell.tx.text forKey:@"dailygainexceed"];
    }
    else{
        [dic setObject:[NSString stringWithFormat:@"0"] forKey:@"dailygainexceedisopen"];
    }
    
    if(daydowncell.swich.on && daydowncell.tx.text.length !=0)
    {
        [dic setObject:[NSString stringWithFormat:@"1"] forKey:@"dailydeclineexceedisopen"];
        [dic setObject:daydowncell.tx.text forKey:@"dailydeclineexceed"];
    }
    else{
        [dic setObject:[NSString stringWithFormat:@"0"] forKey:@"dailydeclineexceedisopen"];
    }
    if (flag) {
        return;
    }
    WEAK_SELF;
    [DCService setalertsymbol:self.symbol alertrate:[self convertToInt] dic:dic success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            
            [HUDUtil showInfo:CFDLocalizedString(@"操作成功")];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
        }
        
    } failure:^(NSError *error) {
        [HUDUtil showInfo:nil];
    }];
    
}


#pragma mark - tableView dataSource delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataList count]>0?[_dataList count]+1:0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0)
        return [GUIUtil fit:40]+[GUIUtil fitBoldFont:18].lineHeight + [GUIUtil fitBoldFont:14].lineHeight;
    else
        return [QZHOfferRemindCell heightOfCell:[NDataUtil dataWithArray:_dataList index:indexPath.row-1]];
}



- (NSString *)convertToInt
{
    if([_alertrate isEqualToString:CFDLocalizedString(@"仅一次")])
    {
        return @"1";
    }
    return @"2";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0)
    {
        QZHOfferRemindTitleCell *titleCell = (QZHOfferRemindTitleCell *)[tableView dequeueReusableCellWithIdentifier:@"QZHOfferRemindTitleCell"];
        [titleCell updateData:self.titleDic];
        return titleCell;
    }
    QZHOfferRemindCell *cell = (QZHOfferRemindCell *)[tableView dequeueReusableCellWithIdentifier:@"QZHOfferRemindCell"];
    
    if(indexPath.row != _dataList.count)
    {
        cell.swich.hidden       = NO;
        cell.chooseTitle.hidden = YES;
        cell.chooseImage.hidden = YES;
        cell.tx.enabled         = YES;
        [cell updateData:[NDataUtil dataWithArray:_dataList index:indexPath.row-1]];
        WEAK_SELF;
        cell.reloadCell = ^{
            [weakSelf.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
        };
    }
    else
    {
        cell.swich.hidden       = YES;
        cell.chooseTitle.hidden = NO;
        cell.chooseImage.hidden = NO;
        cell.tx.enabled         = NO;
        [cell updateData:[NDataUtil dataWithArray:_dataList index:indexPath.row-1]];
        cell.chooseTitle.text   = _alertrate;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == _dataList.count)
    {
        AlertFrequencyVC *target = [AlertFrequencyVC new];
        WEAK_SELF;
        target.setAlertrateBlock = ^(NSString * alertrate) {
            weakSelf.alertrate = alertrate;
            QZHOfferRemindCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.dataList.count inSection:0]];
            cell.chooseTitle.text = alertrate;
        };
        target.alertrate = _alertrate;
        [self.navigationController pushViewController:target animated:YES];
    }
}

#pragma mark -----
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-TOP_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [GColorUtil C6];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView registerClass:[QZHOfferRemindCell class] forCellReuseIdentifier:@"QZHOfferRemindCell"];
        [_tableView registerClass:[QZHOfferRemindTitleCell class] forCellReuseIdentifier:@"QZHOfferRemindTitleCell"];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
    }
    return _tableView;
}


- (void)websocketLoad{
    if (_webSocket) {
        [_webSocket reconnect];
        return;
    }
    _webSocket = [[WebSocketManager alloc] init];
    _webSocket.target = self.view;
    [_webSocket  singleContractData:_symbol];
    WEAK_SELF;
    [_webSocket setReciveMessage:^(NSArray *array) {
        NSLog(@"HQAlertVC的websocket收到数据");
        for (NSDictionary *dic in array) {
            if ([NDataUtil boolWithDic:dic key:@"S" isEqual:weakSelf.symbol]) {
                
                NSString *lastPrice = [GUIUtil notRoundingString:[NDataUtil stringWith:dic[@"t"]] afterPoint:weakSelf.dotnum];
                weakSelf.nowv = lastPrice;
                NSString *raise = [GUIUtil decimalSubtract:lastPrice num:weakSelf.iPreclose];
                NSString *raiseRate = [GUIUtil decimalDivide:raise num:weakSelf.iPreclose];
                NSInteger rate = [raiseRate floatValue]*10000;
                weakSelf.updown =  raise;
                weakSelf.updownRate =  [NSString stringWithFormat:@"%.2f%%",(float)(rate/100.0)];
                QZHOfferRemindTitleCell *cell = (QZHOfferRemindTitleCell *)[weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                if ([cell isKindOfClass:[QZHOfferRemindTitleCell class]]) {                
                    [cell updateData:weakSelf.titleDic];
                }
            }
        }
    }];
}

//MARK: - Private

//提醒级别 1 仅提醒一次 2 每日提醒 3 每次提醒 默认是每日提醒
- (NSString *)intToAlertrate:(NSString *)alertrate
{
    if([alertrate intValue] == 1)
        return CFDLocalizedString(@"仅一次");
    else
        return CFDLocalizedString(@"每天一次");
    
}

- (NSDictionary *)titleDic{
    return @{@"name":[NDataUtil stringWith:_stockname],
             @"code":[NDataUtil stringWith:_symbol],
             @"nowv":[NDataUtil stringWith:_nowv],
             @"updownRate":[NDataUtil stringWith:_updownRate]
             };
}

@end

