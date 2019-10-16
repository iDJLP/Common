//
//  FTOLyMyCell.h
//  niuguwang
//
//  Created by jly on 16/11/2.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"
#import "BaseView.h"
#import "BaseLabel.h"
#import "BaseImageView.h"

@interface MineCell : BaseCell

@property (nonatomic,strong)UIImageView *myImageView;
@property (nonatomic,strong)BaseLabel     * myTitleLabel;
@property (nonatomic,strong)BaseImageView *rowImageView;
@property (nonatomic, strong) UIImageView * newLabel;
@property (nonatomic,strong)BaseView     * line;

@end
