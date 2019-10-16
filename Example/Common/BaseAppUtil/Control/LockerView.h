//
//  LockerView.h
//  Chart
//
//  Created by ngw15 on 2019/3/4.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseScrollView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SectionType) {
    SectionTypeLeft,
    SectionTypeDivideWidth,
};

@protocol LockerScrollProtocol <NSObject>

@property (nonatomic,weak)id<LockerScrollProtocol> scrollDelegate;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

@interface LockerView : BaseScrollView

@property (nonatomic,assign,readonly) NSInteger selectedIndex;
@property(nonatomic,copy)BOOL (^shouldEdgePanable)(void);

@property(nonatomic,copy)void(^selectedIndexHander)(NSInteger index);

- (instancetype)initWithTopHeight:(CGFloat)topHeight lists:(NSArray <NSDictionary *>*)list;
- (instancetype)initWithTopHeight:(CGFloat)topHeight lists:(NSArray <NSDictionary *>*)list sectionType:(SectionType)type;
- (void)hScrollviewShouldScroll:(BOOL)flag;
- (void)updateTopHeight:(CGFloat)height;
- (void)updateTitleList:(NSArray *)list;
- (void)setSectionBgColor:(ColorType)sectionBgColor sectionTextFont:(UIFont *)font sectionTextColor:(ColorType)textColor sectionSelTextColor:(ColorType)selTextColor hasLine:(BOOL)hasLine;

+ (CGFloat)sectionHeight;

@end

NS_ASSUME_NONNULL_END
