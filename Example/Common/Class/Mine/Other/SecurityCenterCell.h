//
//  SecurityCenterCell.h
//  Bitmixs
//
//  Created by ngw15 on 2019/5/17.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SecurityCenterCell : BaseCell

@property (nonatomic,strong)BaseLabel     *titleLabel;
@property (nonatomic,strong)BaseLabel  *remarkLabel;;
@property (nonatomic, strong)BaseImageView * arrowImgView;
@property (nonatomic,strong)BaseView     * line;

@end

NS_ASSUME_NONNULL_END
