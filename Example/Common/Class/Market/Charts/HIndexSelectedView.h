//
//  HIndexSelectedView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/3/29.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HIndexSelectedView : UIView

@property (nonatomic,strong) NSMutableDictionary *config;
- (instancetype)initWithTitles:(NSArray <NSArray *>*)titles frame:(CGRect)frame;
@property(nonatomic,copy)void(^selectedIndexHander)(NSMutableDictionary *dic);

@end

NS_ASSUME_NONNULL_END
