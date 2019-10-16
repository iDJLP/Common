//
//  WebSocketManager.h
//  BitInfi
//
//  Created by 黄春晓 on 2018/2/9.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

typedef void(^WebSocketDidReciveMessageBlock)(NSArray * array);

#import <Foundation/Foundation.h>

@interface WebSocketManager : NSObject

@property (nonatomic,weak)UIView *target;
//参数模型数组回调
@property (nonatomic,copy)WebSocketDidReciveMessageBlock reciveMessage;
@property (nonatomic,copy)NSString *urlString;

//MARK:--------------行情

- (void)contractDataList;

- (void)singleContractData:(NSString *)symbol;
- (void)contractOrderBook:(NSString *)symbol;
- (void)multipleContractData:(NSArray *)symbol;

/*
 *  闭关socket连接
 */
-(void) disconnect;

/**
 *  重新打开连接
 */
-(void) reconnect;

/**
 *  发送数据
 */
//-(void) send:(id)data;
@end
