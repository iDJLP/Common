//
//  CFDBtnListView.h
//  LiveTrade
//
//  Created by ngw15 on 2019/2/19.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFDBtnListView : UIView

@property (nonatomic,copy)void(^indexSelectedHander)(EIndexType indexType);

- (instancetype)initWithList:(NSArray *)list;

@end

NS_ASSUME_NONNULL_END
