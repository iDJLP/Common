//
//
//  globalwin
//
//  
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "TabBarItem.h"
#import "YYKit.h"

@implementation TabBarItem

- (void)dealloc{
    [self removeNotic];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addNotic];
        [self addSubviews];
        [self setSubviews];
        
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:tapGr];
    }
    return self;
}
// 添加控件
- (void)addSubviews {
    imageView = [BaseImageView new];
    [self addSubview:imageView];
    
    titleLb = [BaseLabel new];
    [self addSubview:titleLb];
}
// 控件相关属性设置
- (void)setSubviews {
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.font = [GUIUtil fitFont:12];
    titleLb.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    titleLb.frame = (CGRect){0, self.height - 17, self.width, 12.0};
    
    imageView.frame = (CGRect){0, 0, CGRectGetWidth(imageView.bounds) ? CGRectGetWidth(imageView.bounds) : imageView.image.size.width, CGRectGetHeight(imageView.bounds) ? CGRectGetHeight(imageView.bounds) : imageView.image.size.height};
    imageView.centerX = self.width / 2.0;
    imageView.centerY = CGRectGetHeight(self.bounds) - CGRectGetHeight(titleLb.bounds) - CGRectGetHeight(imageView.bounds) / 2 - 8.f;
}

#pragma mark - Pub
// 默认图片
- (void)setImageName:(NSString *)imageName{
    imageView.imageName = imageName;
}
// 选中图片
- (void)setSelectedImageName:(NSString *)selectedImageName{
    imageView.highlightedImageName = selectedImageName;
}
// 名称
- (void)setTextBlock:(NSString *(^)(void))textBlock{
    titleLb.textBlock = textBlock;
}
// 选中之后切换样式
- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if (selected) {
        imageView.highlighted = YES;
        titleLb.textColor = [GColorUtil C13];
    } else {
        imageView.highlighted = NO;
        titleLb.textColor = [GColorUtil C3];
    }
}

#pragma mark - SEL

// 选中之后改变颜色和图片
- (void)tapped:(UITapGestureRecognizer *)gr {
    if ([self.delegate respondsToSelector:@selector(tabBarItemTapped:)]) {
        [self.delegate tabBarItemTapped:self];
    }
}

- (void)themeChangedAction{
    if (_selected) {
        imageView.highlighted = YES;
        titleLb.textColor = [GColorUtil C13];
    } else {
        imageView.highlighted = NO;
        titleLb.textColor = [GColorUtil C3];
    }
}

- (void)addNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:ThemeDidChangedNotification object:nil];
    [center addObserver:self
               selector:@selector(themeChangedAction)
                   name:ThemeDidChangedNotification
                 object:nil];
}

- (void)removeNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

@end
