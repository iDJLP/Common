//
//  MarketVC.h
//  Chart
//
//  Created by ngw15 on 2019/3/12.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "NBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MarketVC : NBaseVC

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)void(^didSelectedCell)(NSString *symbol);
@property (nonatomic,copy)void(^flodViewHander)(void);

@end

NS_ASSUME_NONNULL_END
