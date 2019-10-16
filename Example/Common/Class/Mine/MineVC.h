//
//  MineVC.h
//  Bitmixs
//
//  Created by ngw15 on 2019/3/18.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "NBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MineSectionType) {
    MineSectionTypeUnKonw,
    MineSectionTypeFund,
    MineSectionTypeAccount,
    MineSectionTypeMsg,
    MineSectionTypeHelp,
    MineSectionTypeSecurity,
    MineSectionTypeAddress,
    MineSectionTypeSuggest,
    MineSectionTypeSetting,
};

@interface MineVC : NBaseVC

@end

NS_ASSUME_NONNULL_END
