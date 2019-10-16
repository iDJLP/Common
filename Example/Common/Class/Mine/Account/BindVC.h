//
//  BindVC.h
//  Bitmixs
//
//  Created by ngw15 on 2019/3/21.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "NBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BindType) {
    BindTypeAlterPhone,  //修改绑定手机
    BindTypeVaildPhone,  //验证手机(修改绑定手机前的步骤)
    BindTypeAddPhone,    //绑定手机
    BindTypeAddEmail,    //绑定邮箱
    BindTypeSetFundPwd,  //设置资金密码
    BindTypeAlterFundPwd,  //修改资金密码
    BindTypeIdAuth,      //身份认证
    BindTypeBank,      //银行卡绑定
    BindTypeAddAddress,      //添加地址
};

@interface BindVC : NBaseVC

+ (void)jumpTo:(BindType)type;
+ (void)jumpTo:(BindType)type object:(id)object complete:(void(^)(id data))hander;

@end

NS_ASSUME_NONNULL_END
