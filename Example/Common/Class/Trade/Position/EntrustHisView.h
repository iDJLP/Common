//
//  EntrustHisView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/3/25.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "TableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EntrustHisView : UITableView

@property (nonatomic,copy) NSString *params;

- (void)requestData:(BOOL)isRefresh;

- (void)willAppear;

@end

NS_ASSUME_NONNULL_END
