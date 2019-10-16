//
//  FCCheckIDStatusVC.h
//  niuguwang
//
//  Created by jly on 2017/4/1.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    
    QZHCheckIDFailure=0,//认证状态 0:失败
    QZHCheckIDSuccess,//认证状态 1;成功
    QZHWebVCLoadFailue,//webview 加载失败

}QZHCheckIDStatus;


@interface QZHCheckIDStatusVC : UIViewController

@property (nonatomic,copy)void(^reConfimblock)(void);
/**认证状态 0:失败 1;成功 2:webview 加载失败*/
@property (nonatomic,assign)QZHCheckIDStatus ststus;
@property (nonatomic,copy)NSString *info;
@end
