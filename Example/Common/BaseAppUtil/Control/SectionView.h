//
//  SectionView.h
//  Chart
//
//  Created by ngw15 on 2019/3/7.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockerView.h"
#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SectionView : BaseView

@property (nonatomic,strong)void(^changedSelectedIndex)(NSInteger index);
@property (nonatomic,assign)NSInteger selectedIndex;

- (instancetype)initWithList:(NSArray *)list sectionType:(SectionType)type;
- (void)changeSelectedIndex:(NSInteger)index;
- (void)setSectionBgColor:(ColorType)sectionBgColor sectionTextFont:(UIFont *)font sectionTextColor:(ColorType)textColor sectionSelTextColor:(ColorType)selTextColor hasLine:(BOOL)hasLine;
- (void)updateTitleList:(NSArray *)list;

@end

NS_ASSUME_NONNULL_END
