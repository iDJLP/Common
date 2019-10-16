//
//  InputView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/3/22.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "BaseLabel.h"
#import "BaseBtn.h"
#import "BaseImageView.h"
#import "BaseTextField.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, InputType) {
    InputTypeNone,
    InputTypeAddSub,
    InputTypeSelected,
} NS_ENUM_AVAILABLE_IOS(7_0);

@interface InputView : UIView

@property (nonatomic,strong)BaseLabel *titleLabel;

@property (nonatomic,strong)BaseView *inputView;
@property (nonatomic,strong)BaseTextField *textField;
@property (nonatomic,strong)BaseBtn *addBtn;
@property (nonatomic,strong)BaseBtn *subBtn;
@property (nonatomic,strong)BaseView *line1;
@property (nonatomic,strong)BaseView *line2;
@property (nonatomic,strong)BaseImageView *selBtn;

@property (nonatomic,assign)InputType type;
@property (nonatomic,copy)NSString *minFloat;

@property (nonatomic,copy)BOOL (^enableBecomeFirstRespondHander)(void);
@property (nonatomic,copy)dispatch_block_t textChangedHander;

+ (CGSize)sizeOfView;
- (instancetype)initWithType:(InputType)type;
- (void)configView:(NSDictionary *)dic;
- (void)countChangedAction:(UIButton *)btn;
+ (NSInteger)decFloat:(NSString *)f;
@end

NS_ASSUME_NONNULL_END
