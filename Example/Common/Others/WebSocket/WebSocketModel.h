//
//  WebSocketModel.h
//  BitInfi
//
//  Created by 黄春晓 on 2018/2/9.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebSocketModel : NSObject
@property (nonatomic,copy)NSString * marketWssUrl;     //行情ws地址
//初始化并获取webSocket连接地址
+ (instancetype)sharedInstance;

//登录状态切换时重新请求webSocket连接地址
-(void)requestWssUrl;

// 预加载
- (void) preload;
@end
