//
//  NewsTableView.h
//  Chart
//
//  Created by ngw15 on 2019/3/7.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableView.h"
#import "LockerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsTableView : TableView

@property (nonatomic,weak)UIScrollView *mj_delegate;
@property (nonatomic,weak)id<LockerScrollProtocol> scrollDelegate;
- (void)viewWillAppear;

@end

NS_ASSUME_NONNULL_END
