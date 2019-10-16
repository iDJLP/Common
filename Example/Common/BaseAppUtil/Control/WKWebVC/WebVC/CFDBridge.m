//
//  CFDBridge.m
//  LiveTrade
//
//  Created by ngw15 on 2018/11/29.
//  Copyright © 2018 taojinzhe. All rights reserved.
//

#import "CFDBridge.h"
#import "WebVC.h"
#import <Photos/Photos.h>

@implementation CFDBridge

// GCD单例
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static CFDBridge * sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[CFDBridge alloc] init];
    });
    return sharedInstance;
}

- (void)setup:(WebViewJavascriptBridge *)bridge{
#if DEBUG
    [WebViewJavascriptBridge enableLogging];
#endif
    WEAK_SELF;
    //
    [bridge registerHandler:@"onResult" handler:^(id data, WVJBResponseCallback responseCallback) {
        switch ([data[@"type"] intValue]) {
            case 1: //返回首页
            {
                [CFDJumpUtil jumpToHomeVC];
            }
                break;
            case 2://再次充值
            {
                [[GJumpUtil rootNavC] popToRootViewControllerAnimated:YES];
            }
                break;
            case 4: //失败页面中的返回上一个页面
            {
                [[GJumpUtil rootNavC] popToRootViewControllerAnimated:YES];
            }
                break;
            default:
                break;
        }
        return;
    }];
    
    [bridge registerHandler:@"saveImg" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        if (![data isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSString *imageStr = data[@"content"];
        imageStr = [[imageStr componentsSeparatedByString:@","] lastObject];
        if (imageStr.length<=0) {
            return ;
        }
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:imageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image = [UIImage imageWithData:imageData];
        UIImageWriteToSavedPhotosAlbum(image, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:),nil);
    }];

}

#pragma mark -- <保存到相册>
-  (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = CFDLocalizedString(@"保存图片失败") ;
    }else{
        msg = CFDLocalizedString(@"保存图片成功") ;
    }
    [HUDUtil showInfo:msg];
}


@end
